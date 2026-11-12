package org.supass.ai_su_pass.core.bridge.ghost_lock_native

import android.content.Context
import android.os.Handler
import android.os.Looper
import java.util.concurrent.Executors
import org.supass.ai_su_pass.cve43499.GhostLockAssets
import org.supass.ai_su_pass.cve43499.GhostLockFieldNodeView
import org.supass.ai_su_pass.cve43499.GhostLockProfileController
import org.supass.ai_su_pass.cve43499.GhostLockProfileEditStore
import org.supass.ai_su_pass.cve43499.GhostLockProfileStore
import org.supass.ai_su_pass.cve43499.GhostLockProfileView

/**
 * profile 编辑的原生桥：线程分发与视图翻译，合并逻辑在
 * [GhostLockProfileController]。
 *
 * 编辑用 Controller 与运行用 Controller 分离：编辑期的合并结果不进运行缓存。
 */
class GhostLockProfileEditNativeImpl(context: Context) : GhostLockProfileEditNative {

    private val appContext = context.applicationContext

    private val editStore = GhostLockProfileEditStore(appContext)

    /**
     * 编辑用 Controller 与运行用 Controller 分离：编辑期的合并结果不进运行缓存。
     *
     * 不传 forcedUserProfile / forcedBuiltinRelease —— 它们在构造时取值会冻结
     * 当时的选择，用户随后导入或切换就失效；Controller 自身按需读
     * [GhostLockProfileEditStore]，与运行侧共用同一份偏好。
     */
    private val controller = GhostLockProfileController(
        assets = GhostLockAssets(appContext),
        store = GhostLockProfileStore(GhostLockProfileStore.directory(appContext)),
        editStore = editStore,
    )

    /** 解析与落盘都碰 IO，必须离开通道线程。 */
    private val worker = Executors.newSingleThreadExecutor()

    private val mainHandler = Handler(Looper.getMainLooper())

    override fun loadProfile(
        release: String,
        callback: (Result<GhostLockProfileConfig>) -> Unit,
    ) {
        worker.execute {
            val result = runCatching { controller.load(release).toPigeon() }
            mainHandler.post { callback(result) }
        }
    }

    override fun updateGeneralFields(
        release: String,
        values: Map<String, Long>,
        callback: (Result<GhostLockProfileConfig>) -> Unit,
    ) {
        worker.execute {
            val result = runCatching { controller.updateGeneral(release, values).toPigeon() }
            mainHandler.post { callback(result) }
        }
    }

    override fun updateAdvancedFields(
        release: String,
        values: Map<String, Long>,
        callback: (Result<GhostLockProfileConfig>) -> Unit,
    ) {
        worker.execute {
            val result = runCatching { controller.updateAdvanced(release, values).toPigeon() }
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
                controller.updateRoute(release, route.ifEmpty { null }).toPigeon()
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
                controller.updateFallback(release, fallbackTo.ifEmpty { null }).toPigeon()
            }
            mainHandler.post { callback(result) }
        }
    }

    override fun resetProfile(
        release: String,
        callback: (Result<GhostLockProfileConfig>) -> Unit,
    ) {
        worker.execute {
            val result = runCatching { controller.reset(release).toPigeon() }
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
            val result = runCatching { controller.export(release, path) }
            mainHandler.post { callback(result) }
        }
    }

    override fun saveModifiedProfile(
        release: String,
        callback: (Result<Boolean>) -> Unit,
    ) {
        worker.execute {
            val result = runCatching { controller.saveModified(release) }
            mainHandler.post { callback(result) }
        }
    }

    /** 由 [org.supass.ai_su_pass.NativeProvider] 在重建或销毁时调用。 */
    fun dispose() {
        worker.shutdownNow()
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
