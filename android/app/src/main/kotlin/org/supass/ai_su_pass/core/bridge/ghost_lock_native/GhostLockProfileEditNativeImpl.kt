package org.supass.ai_su_pass.core.bridge.ghost_lock_native

import android.content.Context
import android.os.Handler
import android.os.Looper
import java.io.File
import java.util.concurrent.Executors
import org.supass.ai_su_pass.cve43499.GhostLockAssets
import org.supass.ai_su_pass.cve43499.GhostLockFieldNodeView
import org.supass.ai_su_pass.cve43499.GhostLockProfileController
import org.supass.ai_su_pass.cve43499.GhostLockProfileEditStore
import org.supass.ai_su_pass.cve43499.GhostLockProfileStore
import org.supass.ai_su_pass.cve43499.GhostLockProfileView
import org.supass.ai_su_pass.cve43499.profile.valueMapOf

/**
 * profile 编辑的原生桥：线程分发与视图翻译，合并逻辑在
 * [GhostLockProfileController]。
 *
 * 编辑用 Controller 与运行用 Controller 分离：编辑期的合并结果不进运行缓存。
 */
class GhostLockProfileEditNativeImpl(context: Context) : GhostLockProfileEditNative {

    private val appContext = context.applicationContext

    private val editStore = GhostLockProfileEditStore(appContext)

    /** 用户文档落点；「写回当前文件」直接覆盖它。 */
    private val store = GhostLockProfileStore(GhostLockProfileStore.directory(appContext))

    /**
     * 编辑用 Controller 与运行用 Controller 分离：编辑期的合并结果不进运行缓存。
     *
     * 不传 forcedUserProfile / forcedBuiltinRelease —— 它们在构造时取值会冻结
     * 当时的选择，用户随后导入或切换就失效；Controller 自身按需读
     * [GhostLockProfileEditStore]，与运行侧共用同一份偏好。
     */
    private val controller = GhostLockProfileController(
        assets = GhostLockAssets(appContext),
        store = store,
        editStore = editStore,
    )

    /**
     * 编辑会话：与 live 隔离的 Controller，override 落在独立 prefs。
     *
     * 目标文档按其自身 release 解析；只有保存时才决定写回 live 还是覆盖文档。
     */
    private var editSession: GhostLockProfileController? = null

    private val sessionStore = GhostLockProfileEditStore(
        appContext,
        SESSION_PREFS,
    )

    private var sessionName: String? = null

    private var sessionRelease: String = ""

    /** 会话使用的内置表 release；空表示按设备 release 解析。 */
    private var sessionBuiltinRelease: String = ""

    private var sessionDeviceRelease: String = ""

    private var sessionLive = false

    /** 编辑操作优先落在会话，未开会话时退回 live。 */
    private val active: GhostLockProfileController
        get() = editSession ?: controller

    /** 解析与落盘都碰 IO，必须离开通道线程。 */
    private val worker = Executors.newSingleThreadExecutor()

    private val mainHandler = Handler(Looper.getMainLooper())

    override fun loadProfile(
        release: String,
        callback: (Result<GhostLockProfileConfig>) -> Unit,
    ) {
        worker.execute {
            val result = runCatching {
                val target = if (editSession != null) sessionRelease else release
                active.load(target).toPigeon()
            }
            mainHandler.post { callback(result) }
        }
    }

    override fun updateGeneralFields(
        release: String,
        values: Map<String, Long>,
        callback: (Result<GhostLockProfileConfig>) -> Unit,
    ) {
        worker.execute {
            val result = runCatching {
                val target = sessionReleaseIfOpen(release)
                active.updateGeneral(target, values)
                commitSessionLocked(target)
            }
            mainHandler.post { callback(result) }
        }
    }

    override fun updateAdvancedFields(
        release: String,
        values: Map<String, Long>,
        callback: (Result<GhostLockProfileConfig>) -> Unit,
    ) {
        worker.execute {
            val result = runCatching {
                val target = sessionReleaseIfOpen(release)
                active.applyEdits(target, values)
                commitSessionLocked(target)
            }
            mainHandler.post { callback(result) }
        }
    }

    override fun updateRoute(
        release: String,
        route: String,
        callback: (Result<GhostLockProfileConfig>) -> Unit,
    ) {
        worker.execute {
            val result = runCatching {
                val target = sessionReleaseIfOpen(release)
                active.updateRoute(target, route.ifEmpty { null })
                commitSessionLocked(target)
            }
            mainHandler.post { callback(result) }
        }
    }

    override fun updateFallback(
        release: String,
        fallbackTo: String,
        callback: (Result<GhostLockProfileConfig>) -> Unit,
    ) {
        worker.execute {
            val result = runCatching {
                val target = sessionReleaseIfOpen(release)
                active.updateFallback(target, fallbackTo.ifEmpty { null })
                commitSessionLocked(target)
            }
            mainHandler.post { callback(result) }
        }
    }

    override fun resetProfile(
        release: String,
        callback: (Result<GhostLockProfileConfig>) -> Unit,
    ) {
        worker.execute {
            val result = runCatching {
                active.reset(sessionReleaseIfOpen(release)).toPigeon()
            }
            mainHandler.post { callback(result) }
        }
    }

    override fun selectBuiltin(
        release: String,
        profileRelease: String,
        callback: (Result<GhostLockProfileConfig>) -> Unit,
    ) {
        worker.execute {
            val result = runCatching {
                controller
                    .selectBuiltin(profileRelease.ifEmpty { null }, release)
                    .toPigeon()
            }
            mainHandler.post { callback(result) }
        }
    }

    override fun selectUserProfile(
        release: String,
        name: String,
        callback: (Result<GhostLockProfileConfig>) -> Unit,
    ) {
        worker.execute {
            val result = runCatching {
                controller.selectUserProfile(name.ifEmpty { null }, release).toPigeon()
            }
            mainHandler.post { callback(result) }
        }
    }

    override fun exportProfile(
        release: String,
        path: String,
        callback: (Result<Boolean>) -> Unit,
    ) {
        worker.execute {
            val result = runCatching { active.export(sessionReleaseIfOpen(release), path) }
            mainHandler.post { callback(result) }
        }
    }

    override fun renderProfile(
        release: String,
        callback: (Result<String>) -> Unit,
    ) {
        worker.execute {
            val result = runCatching {
                active.renderResolved(sessionReleaseIfOpen(release)) ?: ""
            }
            mainHandler.post { callback(result) }
        }
    }

    override fun saveModifiedProfile(
        release: String,
        callback: (Result<Boolean>) -> Unit,
    ) {
        worker.execute {
            val result = runCatching {
                active.saveModified(sessionReleaseIfOpen(release))
            }
            mainHandler.post { callback(result) }
        }
    }

    override fun resetGeneralFields(
        release: String,
        callback: (Result<GhostLockProfileConfig>) -> Unit,
    ) {
        worker.execute {
            val result = runCatching {
                active.resetGeneral(sessionReleaseIfOpen(release)).toPigeon()
            }
            mainHandler.post { callback(result) }
        }
    }

    override fun resetAdvancedFields(
        release: String,
        callback: (Result<GhostLockProfileConfig>) -> Unit,
    ) {
        worker.execute {
            val result = runCatching {
                active.resetAdvanced(sessionReleaseIfOpen(release)).toPigeon()
            }
            mainHandler.post { callback(result) }
        }
    }

    override fun overwriteProfile(
        release: String,
        name: String,
        callback: (Result<Boolean>) -> Unit,
    ) {
        worker.execute {
            val result = runCatching {
                if (editSession != null && sessionName != null) {
                    return@runCatching saveSessionInPlaceLocked()
                }
                val text = controller.renderResolved(release) ?: return@runCatching false
                if (!store.save(name, text)) return@runCatching false
                // 写回后 override 已并入文档，清掉避免双重叠加。
                editStore.write(release, valueMapOf())
                true
            }
            mainHandler.post { callback(result) }
        }
    }

    override fun beginEditSession(
        name: String,
        deviceRelease: String,
        callback: (Result<GhostLockProfileConfig>) -> Unit,
    ) {
        worker.execute {
            val result = runCatching {
                endSessionLocked()
                val documentName = name.ifEmpty { null }
                val documentRelease = documentName
                    ?.let { controller.releasesOf(it).firstOrNull() }
                    ?.takeIf { it.isNotEmpty() }
                /* live 的条件：既是当前生效文档，又与设备内核同 release。
                 * 只满足前者时它的 override 键会和设备态错位，按文档态处理。 */
                val live = documentName != null &&
                    documentName == controller.activeUserProfile() &&
                    documentRelease == deviceRelease
                val targetRelease = if (live) {
                    deviceRelease
                } else {
                    documentRelease ?: deviceRelease
                }
                sessionStore.write(targetRelease, valueMapOf())
                if (live) inheritLiveOverridesLocked()
                val builtinRelease = controller.activeBuiltinRelease().orEmpty()
                val session = GhostLockProfileController(
                    assets = GhostLockAssets(appContext),
                    store = store,
                    editStore = sessionStore,
                    forcedUserProfile = documentName,
                    forcedBuiltinRelease = controller.activeBuiltinRelease(),
                )
                val view = session.load(targetRelease)
                editSession = session
                sessionName = documentName
                sessionRelease = targetRelease
                sessionBuiltinRelease = builtinRelease
                sessionDeviceRelease = deviceRelease
                sessionLive = live
                view.toPigeon()
            }
            mainHandler.post { callback(result) }
        }
    }

    override fun reloadEditSession(
        callback: (Result<GhostLockProfileConfig>) -> Unit,
    ) {
        worker.execute {
            val result = runCatching {
                val session = editSession ?: error("no edit session")
                /* 丢弃未保存改动：清会话 override，live 时重新继承。 */
                sessionStore.write(sessionRelease, valueMapOf())
                if (sessionLive) inheritLiveOverridesLocked()
                session.load(sessionRelease).toPigeon()
            }
            mainHandler.post { callback(result) }
        }
    }

    override fun editSessionIsLive(callback: (Result<Boolean>) -> Unit) {
        worker.execute {
            val result = runCatching { sessionLive }
            mainHandler.post { callback(result) }
        }
    }

    override fun editSessionTarget(callback: (Result<String>) -> Unit) {
        worker.execute {
            val result = runCatching { sessionName ?: "" }
            mainHandler.post { callback(result) }
        }
    }

    override fun editSessionRelease(callback: (Result<String>) -> Unit) {
        worker.execute {
            val result = runCatching { sessionRelease }
            mainHandler.post { callback(result) }
        }
    }

    override fun commitEditSession(callback: (Result<Boolean>) -> Unit) {
        worker.execute {
            val result = runCatching {
                if (!sessionLive) return@runCatching false
                val session = editSession ?: return@runCatching false
                /* live 侧的 override 以设备 release 为键，不能用文档自身 release。 */
                controller.replaceOverrides(
                    sessionDeviceRelease,
                    session.overridesSnapshot(sessionDeviceRelease),
                )
                /* 能重新加载即算写入成功；解析为空属于「不生效」，不是保存失败。 */
                runCatching { controller.load(sessionDeviceRelease) }.isSuccess
            }
            mainHandler.post { callback(result) }
        }
    }

    override fun saveEditSessionInPlace(callback: (Result<Boolean>) -> Unit) {
        worker.execute {
            val result = runCatching { saveSessionInPlaceLocked() }
            mainHandler.post { callback(result) }
        }
    }

    override fun saveEditSessionAsNew(callback: (Result<String>) -> Unit) {
        worker.execute {
            val result = runCatching {
                val session = editSession ?: return@runCatching ""
                /* 文档名去掉 .conf；内置态用选中的内置 release，release 里的点不是
                 * 扩展名。不能用 sessionRelease——内置表会话的解析键是设备 release，
                 * 拿它命名会把 6.1 的表存成 5.15 的名字。 */
                val stem = (sessionName ?: sessionBuiltinRelease.ifEmpty { sessionRelease })
                    .let { if (sessionName != null) it.substringBeforeLast('.') else it }
                    .replace(Regex("[^A-Za-z0-9._-]"), "_")
                val name = "${stem.ifEmpty { "profile" }}-edited.conf"
                val text = session.renderResolved(
                    sessionRelease,
                    sessionBuiltinRelease.ifEmpty { sessionRelease },
                ) ?: error("cannot render the edited profile")
                if (store.save(name, text)) name else ""
            }
            mainHandler.post { callback(result) }
        }
    }

    override fun exportEditSession(
        path: String,
        callback: (Result<Boolean>) -> Unit,
    ) {
        worker.execute {
            val result = runCatching {
                val session = editSession ?: return@runCatching false
                val text = session.renderResolved(
                    sessionRelease,
                    sessionBuiltinRelease.ifEmpty { sessionRelease },
                ) ?: return@runCatching false
                File(path).parentFile?.mkdirs()
                File(path).writeText(text, Charsets.UTF_8)
                true
            }
            mainHandler.post { callback(result) }
        }
    }

    override fun endEditSession(callback: (Result<Unit>) -> Unit) {
        worker.execute {
            endSessionLocked()
            mainHandler.post { callback(Result.success(Unit)) }
        }
    }

    private fun sessionReleaseIfOpen(release: String): String =
        if (editSession != null) sessionRelease else release

    /** 内置表/设备态：改动只能留在 override，同步到运行侧。 */
    private fun syncLiveOverridesLocked() {
        val session = editSession ?: return
        if (!sessionLive) return
        controller.replaceOverrides(
            sessionDeviceRelease,
            session.overridesSnapshot(sessionRelease),
        )
    }

    /**
     * 写完一批字段后落到最终载体。
     *
     * 编辑用户文档时文档就是唯一真相：合并结果直接写回文件，两层 override 清空，
     * 重开读到的就是刚保存的内容。编辑内置表/设备态没有可写文件，只能把改动留在
     * override 里供运行侧合并。
     */
    private fun commitSessionLocked(target: String): GhostLockProfileConfig {
        val session = editSession
        val name = sessionName
        if (session == null || name == null) {
            syncLiveOverridesLocked()
            return active.load(target).toPigeon()
        }
        val text = session.renderResolved(target) ?: error("profileRenderFailed")
        if (!store.save(name, text)) error("profileWriteFailed")
        /* 改动已进文件：override 必须清掉，否则下次打开会与文件内容重复叠加。 */
        sessionStore.write(target, valueMapOf())
        if (sessionLive) controller.replaceOverrides(sessionDeviceRelease, valueMapOf())
        return session.load(target).toPigeon()
    }

    /**
     * 把 live override 复制进会话。
     *
     * live 侧以设备 release 为键；会话按自己解析用的 release 落盘，两者在 live
     * 场景下通常相等，但仍按各自主键读写，避免键错位。
     */
    private fun inheritLiveOverridesLocked() {
        val overrides = controller.overridesSnapshot(sessionDeviceRelease)
        if (overrides.isNotEmpty()) {
            sessionStore.write(sessionRelease, overrides)
        }
    }

    private fun endSessionLocked() {
        editSession = null
        sessionName = null
        sessionRelease = ""
        sessionBuiltinRelease = ""
        sessionDeviceRelease = ""
        sessionLive = false
    }

    private fun saveSessionInPlaceLocked(): Boolean {
        val session = editSession ?: return false
        val target = sessionName ?: return false
        val document = session.renderResolved(sessionRelease)
            ?: error("cannot render the edited profile")
        return store.save(target, document)
    }

    override fun activeUserProfile(callback: (Result<String>) -> Unit) {
        worker.execute {
            val result = runCatching { controller.activeUserProfile() ?: "" }
            mainHandler.post { callback(result) }
        }
    }

    override fun activeBuiltinRelease(callback: (Result<String>) -> Unit) {
        worker.execute {
            val result = runCatching { controller.activeBuiltinRelease() ?: "" }
            mainHandler.post { callback(result) }
        }
    }

    /** 由 [org.supass.ai_su_pass.NativeProvider] 在重建或销毁时调用。 */
    fun dispose() {
        endSessionLocked()
        worker.shutdownNow()
    }

    private companion object {
        /** 会话 override 的独立 prefs，避免与 live 互相污染。 */
        const val SESSION_PREFS = "ghostlock_profile_edit_session"
    }
}

/** 编辑视图 → Pigeon 数据类；`value == null` 翻译成 `provided = false`。 */
private fun GhostLockProfileView.toPigeon(): GhostLockProfileConfig = GhostLockProfileConfig(
    release = release,
    hasProfile = hasProfile,
    roots = flattenRoots(roots),
    general = general.map {
        GhostLockExecutionField(path = it.path, value = it.value, overridden = it.overridden)
    },
    route = route,
    fallbackTo = fallbackTo,
    invalidPaths = invalidPaths,
    builtinReleases = builtinReleases,
)

/** 先序拍平字段树：契约里不能自引用，层级用 depth 表达。 */
private fun flattenRoots(roots: List<GhostLockFieldNodeView>): List<GhostLockFieldNode> {
    val out = ArrayList<GhostLockFieldNode>()
    fun walk(nodes: List<GhostLockFieldNodeView>, depth: Long) {
        for (node in nodes) {
            out += GhostLockFieldNode(
                path = node.path,
                name = node.name,
                depth = depth,
                value = node.value ?: 0L,
                provided = node.value != null,
                overridden = node.overridden,
            )
            walk(node.children, depth + 1)
        }
    }
    walk(roots, 0L)
    return out
}
