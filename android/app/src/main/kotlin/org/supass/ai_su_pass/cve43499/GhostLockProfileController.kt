package org.supass.ai_su_pass.cve43499

import java.io.File
import org.supass.ai_su_pass.cve43499.profile.CpuPairView
import org.supass.ai_su_pass.cve43499.profile.NativeProfileDocument
import org.supass.ai_su_pass.cve43499.profile.ProfileMerger
import org.supass.ai_su_pass.cve43499.profile.ProfileResolver
import org.supass.ai_su_pass.cve43499.profile.ValueMap
import org.supass.ai_su_pass.cve43499.profile.asValueMap
import org.supass.ai_su_pass.cve43499.profile.copyValue
import org.supass.ai_su_pass.cve43499.profile.getValueAt
import org.supass.ai_su_pass.cve43499.profile.getLongAt
import org.supass.ai_su_pass.cve43499.profile.mutableChild
import org.supass.ai_su_pass.cve43499.profile.route.RouteKind
import org.supass.ai_su_pass.cve43499.profile.setValueAt
import org.supass.ai_su_pass.cve43499.profile.valueMapOf
import org.supass.ai_su_pass.cve98260.HoconSupport

/** profile 树的一个节点（编辑视图）；`value == null` 表示 profile 未提供该字段。 */
internal class GhostLockFieldNodeView(
    val path: String,
    val name: String,
    val value: Long?,
    val overridden: Boolean,
    val children: List<GhostLockFieldNodeView>,
)

/** 通用参数页的一行。 */
internal class GhostLockExecutionFieldView(
    val path: String,
    val value: Long,
    val overridden: Boolean,
)

/** 一次 profile 解析结果（编辑视图）。 */
internal class GhostLockProfileView(
    val release: String,
    val hasProfile: Boolean,
    val roots: List<GhostLockFieldNodeView>,
    val general: List<GhostLockExecutionFieldView>,
    /** 空串表示未声明。 */
    val route: String,
    /** 空串表示未声明；`none` 是显式关闭。 */
    val fallbackTo: String,
    val invalidPaths: List<String>,
    /** 内置表里的全部 release，供「指定生效表」的下拉使用。 */
    val builtinReleases: List<String>,
)

/**
 * profile 的唯一权威：加载、三层合并、sparse override 落盘、GLK1 编码。
 *
 * HOCON 是持久化格式，`ValueMap` 是内存表示。导入的用户文档只读，所有编辑
 * 都落 [GhostLockProfileEditStore] 的 sparse override。
 *
 * CPU 对取自共享 tuning 的 `execution.recommended_cpus`（与运行路径一致）。
 */
internal class GhostLockProfileController(
    private val assets: GhostLockAssets,
    private val store: GhostLockProfileStore,
    private val editStore: GhostLockProfileEditStore,
    private val forcedUserProfile: String? = null,
    private val forcedBuiltinRelease: String? = null,
) {

    private val lock = Any()

    private var cachedRelease: String? = null

    private var cachedDocument: NativeProfileDocument? = null

    /** 最近一次 [resolve] 的失败原因；成功时清空。 */
    private var lastResolveError: String? = null

    private val builtinFiles: Map<String, String> by lazy { loadIndex() }

    val routes: List<String> = RouteKind.entries.map { it.token }

    /** 内置表里的全部 release；模板表由编辑器单独分区展示，只读不可选。 */
    fun builtinReleases(): List<String> = builtinFiles.keys.sorted()

    /** 按 release 读内置表的原始 HOCON 文本；不存在返回空串。 */
    fun builtinRawText(release: String): String {
        val file = builtinFiles[release] ?: return ""
        return assets.load("$BUILTIN_DIR/$file")
    }

    /** 文档声明的 release；文档不存在或不可解析时返回空列表。 */
    fun releasesOf(name: String): List<String> = store.list()
        .firstOrNull { it.name == name }
        ?.release
        ?.let { listOf(it) }
        ?: emptyList()

    /** 最近一次解析失败原因；空表示没有记录。运行路径用它把 noProfile 归因到具体环节。 */
    fun resolveError(): String? = synchronized(lock) { lastResolveError }

    /** 同步加载；编辑桥与运行预检都在后台线程调用。 */
    fun load(release: String): GhostLockProfileView = synchronized(lock) {
        reconcileActiveSource()
        var advanced = editStore.read(release)
        var full = resolveCurrent(release, advanced, includeImported = true)
        if (full == null && advanced.isNotEmpty()) {
            /* 历史遗留的坏 override 会让整页失效；回滚到基线视图，用户仍能编辑。 */
            editStore.write(release, valueMapOf())
            advanced = valueMapOf()
            full = resolveCurrent(release, null, includeImported = true)
        }
        if (full == null) {
            cache(release, null)
            return@synchronized GhostLockProfileView(
                release = release,
                hasProfile = false,
                roots = emptyList(),
                general = emptyList(),
                route = "",
                fallbackTo = "",
                invalidPaths = emptyList(),
                builtinReleases = builtinReleases(),
            )
        }
        val baseline = resolveCurrent(release, null, includeImported = false) ?: full
        val route = routeNameOf(full)
        val fallbackTo = fallbackTargetOf(full)
        val invalid = (
            validateProfileFields(full, route, fallbackTo) +
                ProfileResolver.validateMerged(full, route, fallbackTo).map { it.fieldPath }
            ).toMutableSet()
        /* 违规字段即使文档里没有也要出现一行，否则运行被拦却无处可改。 */
        materializeInvalidPaths(full, invalid)
        val complete = completeProfileFields(full, route, fallbackTo)
        val roots = buildTree(complete, "", baseline, advanced)
        cache(release, buildNativeDocument(release, full))
        GhostLockProfileView(
            release = release,
            hasProfile = true,
            roots = roots,
            general = generalFields(full, baseline, route, fallbackTo),
            route = route.orEmpty(),
            fallbackTo = fallbackTo.orEmpty(),
            invalidPaths = invalid.sorted(),
            builtinReleases = builtinReleases(),
        )
    }

    /** 当前生效配置的 GLK1 字节；[view] 不是最近一次加载结果时返回 null。 */
    fun nativeDocument(view: GhostLockProfileView): ByteArray? = synchronized(lock) {
        if (cachedRelease != view.release) return@synchronized null
        cachedDocument?.toBinary()
    }

    fun updateGeneral(release: String, values: Map<String, Long>): GhostLockProfileView {
        val override = editStore.read(release)
        for ((path, value) in values) {
            /* CPU 对跟随设备，不接受 profile 固化（与上游一致）。 */
            if (path.startsWith("execution.selected_cpus")) continue
            if (path.startsWith("execution.")) {
                override.mutableChild("execution")
                    .setValueAt(path.removePrefix("execution."), value)
            } else {
                override.setValueAt(path, value)
            }
        }
        return commit(release, override)
    }

    /**
     * 增量写入若干字段，供编辑器保存使用。
     *
     * 与 [updateAdvanced] 的整片重建不同：这里只把用户改动的条目并进现有
     * override，其余条目不参与，避免未改动字段被重新解释。
     */
    fun applyEdits(release: String, values: Map<String, Long>): GhostLockProfileView {
        val override = editStore.read(release)
        var editedRoute: String? = null
        for ((path, value) in values) {
            if (path.isEmpty() || path == "release" ||
                path.startsWith("execution.selected_cpus")
            ) {
                continue
            }
            override.setValueAt(path, value)
            /* 改的是 route 分支里的字段，就把这条分支定为唯一分支：
             * 其余分支若留着，合并时按出现顺序取第一条，改动会被顶掉。 */
            if (path.startsWith("route.")) {
                path.removePrefix("route.").substringBefore('.').takeIf { it in routes }
                    ?.let { editedRoute = it }
            }
        }
        editedRoute?.let { pruneOverrideBranches(override, "route", it) }
        return commit(release, override)
    }

    fun updateAdvanced(release: String, values: Map<String, Long>): GhostLockProfileView {
        /* 从零重建 sparse override：只有与 baseline 不同的值保留，
         * 未改动的字段（含旧版本留下的条目）不会继续高亮。 */
        val baseline = resolveCurrent(release, null, includeImported = true)
        if (baseline != null) {
            val rebuilt = valueMapOf()
            for ((path, value) in values) {
                if (path.isEmpty() || path == "release" ||
                    path.startsWith("execution.selected_cpus")
                ) {
                    continue
                }
                if (value != baseline.getLongAt(path)) rebuilt.setValueAt(path, value)
            }
            /* 高级编辑器不带 fallback（也可能丢掉 baseline 已匹配的 route 分支）；
             * 二者原样保留。selected_cpus 属于设备态，不再回写。 */
            val current = editStore.read(release)
            current["route"].asValueMap()?.let { route -> rebuilt.putIfAbsent("route", route) }
            current["fallback"].asValueMap()?.let { fallback ->
                val rebuiltFallback = rebuilt["fallback"].asValueMap()
                if (rebuiltFallback == null) {
                    rebuilt["fallback"] = fallback
                } else {
                    fallback["to"]?.let { rebuiltFallback["to"] = it }
                }
            }
            return commit(release, rebuilt)
        }
        return load(release)
    }

    fun updateRoute(release: String, route: String?): GhostLockProfileView {
        val override = editStore.read(release)
        if (route.isNullOrBlank()) {
            override.remove("route")
        } else {
            val existingBranch = override["route"].asValueMap()?.get(route).asValueMap()
                ?: routeBranchTemplate(route)
            override["route"] = valueMapOf(route to existingBranch)
            pruneOverrideBranches(override, "route", route)
        }
        val view = commit(release, override)
        /* 写入没体现在解析结果里时必须报错，否则用户看到「点了没反应」。 */
        if (!route.isNullOrBlank() && view.route != route) {
            val merged = resolveCurrent(release, editStore.read(release), true)
            val mergedKeys = merged?.get("route").asValueMap()?.keys?.joinToString(",")
            throw IllegalStateException(
                "profileRouteNotApplied: requested=$route resolved=${view.route} " +
                    "mergedRouteKeys=[$mergedKeys]",
            )
        }
        return view
    }

    fun updateFallback(release: String, fallbackTo: String?): GhostLockProfileView {
        val override = editStore.read(release)
        if (fallbackTo.isNullOrBlank()) {
            override.remove("fallback")
        } else {
            val fallback = override["fallback"].asValueMap() ?: valueMapOf()
            fallback["to"] = fallbackTo
            if (fallbackTo in routes) {
                val branch = fallback["route"].asValueMap()?.get(fallbackTo).asValueMap()
                    ?: routeBranchTemplate(fallbackTo)
                fallback["route"] = valueMapOf(fallbackTo to branch)
            } else {
                fallback.remove("route")
            }
            override["fallback"] = fallback
            pruneOverrideBranches(override, "fallback", fallbackTo.takeIf { it in routes })
        }
        return commit(release, override)
    }

    fun reset(release: String): GhostLockProfileView {
        editStore.write(release, valueMapOf())
        return load(release)
    }

    /** 读该 release 的 sparse override 快照；供编辑会话复制到 live。 */
    fun overridesSnapshot(release: String): ValueMap = synchronized(lock) {
        editStore.read(release).copyValue().asValueMap() ?: valueMapOf()
    }

    /** 整体替换该 release 的 sparse override；供编辑会话提交到 live。 */
    fun replaceOverrides(release: String, overrides: ValueMap) {
        synchronized(lock) { editStore.write(release, overrides) }
    }

    /** 只清通用参数（`execution`）。 */
    fun resetGeneral(release: String): GhostLockProfileView {
        val override = editStore.read(release)
        override.remove("execution")
        editStore.write(release, override)
        return load(release)
    }

    /** 清掉 `execution` 以外的全部 override，保留通用参数。 */
    fun resetAdvanced(release: String): GhostLockProfileView {
        val override = editStore.read(release)
        override.keys.toList().filter { it != "execution" }.forEach(override::remove)
        editStore.write(release, override)
        return load(release)
    }

    /** 把当前生效配置写到 [path]（本地文件路径）。 */
    fun export(release: String, path: String): Boolean {
        val text = renderResolved(release) ?: return false
        return runCatching {
            File(path).parentFile?.mkdirs()
            File(path).writeText(text, Charsets.UTF_8)
            true
        }.getOrDefault(false)
    }

    /** 把当前生效配置另存为一份用户文档。 */
    fun saveModified(release: String): Boolean = saveResolved(release, modifiedName(release))

    /**
     * 生效配置的 HOCON 文本（含 route 调参收尾）。
     *
     * [release] 是解析用的键；[declaredRelease] 是写进文档的 `release`。内置表会话
     * 的解析键是设备 release，但产物应当声明它自己的 release，否则另存出来会被
     * 当成设备那一份。
     */
    fun renderResolved(release: String, declaredRelease: String = release): String? {
        val resolved = resolveCurrent(release, editStore.read(release), includeImported = true)
            ?: return null
        val view = resolved.copyValue().asValueMap() ?: return null
        view["schema_version"] = 1
        view["release"] = declaredRelease
        /* CPU 选择跟随设备，不在这里冻结。 */
        view["execution"].asValueMap()?.remove("selected_cpus")
        fillRouteExecutionDefaults(view)
        trimRouteTuning(view)
        return HoconSupport.render(view)
    }

    fun saveResolved(release: String, fileName: String): Boolean {
        val text = renderResolved(release) ?: return false
        return runCatching { store.save(fileName, text) }.getOrDefault(false)
    }

    fun activeBuiltinRelease(): String? =
        (forcedBuiltinRelease ?: editStore.activeBuiltinRelease())?.takeUnless(::isTemplate)

    fun activeUserProfile(): String? =
        forcedUserProfile ?: editStore.activeUserProfile()

    fun selectBuiltin(selected: String?, deviceRelease: String): GhostLockProfileView {
        /* 生效来源二选一：内置表与用户文档同时存在时，运行侧按内置表选表、
         * 编辑侧按文档开会话，两边会解出两份不同配置。 */
        if (!selected.isNullOrEmpty()) editStore.setActiveUserProfile(null)
        editStore.setActiveBuiltinRelease(selected)
        return load(deviceRelease)
    }

    fun selectUserProfile(name: String?, deviceRelease: String): GhostLockProfileView {
        if (!name.isNullOrEmpty()) editStore.setActiveBuiltinRelease(null)
        editStore.setActiveUserProfile(name)
        return load(deviceRelease)
    }

    /**
     * 收敛历史遗留的生效来源。
     *
     * 模板字段全为 null，选它只会拿到一条几何缺失的路由；双来源并存时
     * 保留用户文档——它若与设备 release 不符会如实报 mismatch，而不是被
     * 遗留的内置表悄悄顶掉。
     */
    private fun reconcileActiveSource() {
        editStore.activeBuiltinRelease()?.let { if (isTemplate(it)) editStore.setActiveBuiltinRelease(null) }
        if (activeUserProfile() == null) return
        if (activeBuiltinRelease() == null) return
        editStore.setActiveBuiltinRelease(null)
    }

    private fun isTemplate(release: String): Boolean = release.endsWith(TEMPLATE_SUFFIX)

    // ---- 解析 ----

    private fun resolveCurrent(
        deviceRelease: String,
        overrides: ValueMap?,
        includeImported: Boolean,
    ): ValueMap? {
        val profileRelease = activeBuiltinRelease() ?: deviceRelease
        return resolve(deviceRelease, profileRelease, overrides, includeImported)
    }

    private fun resolve(
        deviceRelease: String,
        profileRelease: String,
        overrides: ValueMap?,
        includeImported: Boolean,
    ): ValueMap? {
        lastResolveError = null
        return try {
            val builtinFile = builtinFiles[profileRelease]
            val imported = if (includeImported) importedEntry(deviceRelease) else null
            LegacyProfileConverter.convertValue(overrides)
            /* 元数据只由文档声明，override 不得覆盖：历史遗留的坏值会让整份配置
             * 永久解析失败（invalid kernel_major）。 */
            stripMetadata(overrides)
            if (builtinFile == null && imported == null) return null
            val builtin = builtinFile?.let { file ->
                val parsed = parseObject("$BUILTIN_DIR/$file") ?: error("profileUnreadable")
                require((parsed["schema_version"] as? Number)?.toInt() == 1) {
                    "unsupportedProfileSchema"
                }
                require(parsed["release"] == profileRelease) { "profileIndexReleaseMismatch" }
                parsed
            }
            val tuning = readExecutionTuning()
            val presets = routePresets()
            ProfileMerger.resolveMerged(
                deviceRelease = deviceRelease,
                builtin = builtin,
                imported = imported,
                overrides = overrides,
                tuningExecution = tuning?.get("execution").asValueMap(),
                pair = pairFor(tuning),
                routePresets = presets,
            )
        } catch (error: Throwable) {
            lastResolveError = error.message ?: error.javaClass.simpleName
            null
        }
    }

    /**
     * 写入 override 前先验证可解析；不可解析则回滚并抛出原因。
     *
     * 否则编辑一个字段就会把整页变成「没有可编辑的 profile」，用户看不到哪里错。
     */
    private fun commit(release: String, override: ValueMap): GhostLockProfileView {
        val previous = editStore.read(release)
        /* 写入前先剥元数据，顺带把历史遗留的坏值从偏好里清掉。 */
        stripMetadata(override)
        editStore.write(release, override)
        if (resolveCurrent(release, override, includeImported = true) == null) {
            editStore.write(release, previous)
            throw IllegalStateException(
                "profileOverrideRejected: ${lastResolveError ?: "unresolved"}",
            )
        }
        return load(release)
    }

    /** 共享几何/凭据校验；profile 显式声明 route，其它 route 的字段可以缺席。 */
    private fun validateProfileFields(
        profile: ValueMap,
        explicitRoute: String?,
        fallbackTo: String?,
    ): Set<String> {
        val invalid = mutableSetOf<String>()
        fun value(path: String): Long? = profile.getLongAt(path)
        fun requireNonZero(vararg paths: String) {
            paths.forEach { path ->
                val current = value(path)
                if (current == null || current == 0L) invalid += path
            }
        }

        val route = explicitRoute?.takeIf { it in routes }
        if (route == null) invalid += "route"

        requireNonZero(*RouteCommonRequired.toTypedArray())
        val major = value("kernel_major")
        if (major != 5L && major != 6L) invalid += "kernel_major"

        val copySize = value("cred.copy_size")
        if (copySize == null || copySize == 0L) invalid += "cred.copy_size"
        /* 缺席的 cred.usage_offset 解码为 0 并通过，与 native 一致。 */
        val usageOffset = value("cred.usage_offset") ?: 0L
        if (copySize != null && usageOffset + SizeofU32 > copySize) {
            invalid += "cred.usage_offset"
        }

        val capsCount = value("cred.caps_count")
        val capsOffset = value("cred.caps_offset")
        if (capsCount == null || capsCount == 0L) invalid += "cred.caps_count"
        if (copySize != null && capsCount != null && capsOffset != null &&
            capsOffset + capsCount * SizeofU64 > copySize
        ) {
            invalid += "cred.caps_offset"
            invalid += "cred.caps_count"
        }

        val refCount = value("cred.ref_count") ?: 0L
        if (refCount > 4) invalid += "cred.ref_count"
        for (index in 0 until 4) {
            if (index >= refCount) break
            val image = value("cred.ref${index}_image")
            if (image == null || image == 0L) invalid += "cred.ref${index}_image"
            val offset = value("cred.ref${index}_offset")
            if (copySize != null && offset != null && offset + SizeofU64 > copySize) {
                invalid += "cred.ref${index}_offset"
            }
        }

        val routePrefix = route?.let { "route.$it" } ?: "route"
        val fallbackPrefix = fallbackTo?.takeIf { it != "none" }
            ?.let { "fallback.route.$it" }
        when (route) {
            "tcp_zerocopy" -> {
                val compact = value("$routePrefix.compact_waiter")
                if (compact == null || compact == 0L) {
                    invalid += "$routePrefix.compact_waiter"
                } else if (compact < 0L || compact > 0xffL) {
                    invalid += "$routePrefix.compact_waiter"
                }
            }

            "select_stack" -> {
                val shift = value("$routePrefix.waiter_shift")
                if (shift == null ||
                    shift < Int.MIN_VALUE.toLong() || shift > Int.MAX_VALUE.toLong()
                ) {
                    invalid += "$routePrefix.waiter_shift"
                }
            }

            "multicast_waiter" -> {
                for (field in RouteMulticastFields) {
                    val current = value("$routePrefix.$field")
                    if (current == null || current == 0L) {
                        invalid += "$routePrefix.$field"
                    } else if (current < 0L || current > UInt.MAX_VALUE.toLong()) {
                        invalid += "$routePrefix.$field"
                    }
                }
                val compact = value("$routePrefix.compact_waiter")
                if (compact == null || compact == 0L) {
                    invalid += "$routePrefix.compact_waiter"
                } else if (compact < 0L || compact > 0xffL) {
                    invalid += "$routePrefix.compact_waiter"
                }
                requireNonZero(
                    "kernelsnitch.mm_struct_sz",
                    "offset.empty_zero_page",
                    "cred.ref_count",
                )
                if (copySize != null && copySize < 0xa0L) invalid += "cred.copy_size"
                val waiterOff = value("$routePrefix.waiter_off")
                if (waiterOff == null || waiterOff <= 0L || waiterOff > Int.MAX_VALUE.toLong()) {
                    invalid += "$routePrefix.waiter_off"
                }
                val bufferSize = value("$routePrefix.buffer_size")
                val lockOffset = value("$routePrefix.lock_offset")
                if (waiterOff != null && waiterOff > 0L && waiterOff <= Int.MAX_VALUE.toLong() &&
                    bufferSize != null && bufferSize in 0L..UInt.MAX_VALUE.toLong() &&
                    lockOffset != null && lockOffset in 0L..UInt.MAX_VALUE.toLong() &&
                    waiterOff + lockOffset + SizeofU64 > bufferSize
                ) {
                    invalid += "$routePrefix.waiter_off"
                    invalid += "$routePrefix.lock_offset"
                    invalid += "$routePrefix.buffer_size"
                }
            }
        }
        if (fallbackTo != null && fallbackTo != "none" && fallbackTo !in routes) {
            invalid += "fallback.to"
        } else if (fallbackPrefix != null) {
            when (fallbackTo) {
                "tcp_zerocopy" -> {
                    val compact = value("$fallbackPrefix.compact_waiter")
                    if (compact == null || compact == 0L) {
                        invalid += "$fallbackPrefix.compact_waiter"
                    } else if (compact < 0L || compact > 0xffL) {
                        invalid += "$fallbackPrefix.compact_waiter"
                    }
                }

                "select_stack" -> {
                    val shift = value("$fallbackPrefix.waiter_shift")
                    if (shift == null ||
                        shift < Int.MIN_VALUE.toLong() || shift > Int.MAX_VALUE.toLong()
                    ) {
                        invalid += "$fallbackPrefix.waiter_shift"
                    }
                }

                "multicast_waiter" -> {
                    for (field in RouteMulticastFields) {
                        val current = value("$fallbackPrefix.$field")
                        if (current == null || current == 0L) {
                            invalid += "$fallbackPrefix.$field"
                        } else if (current < 0L || current > UInt.MAX_VALUE.toLong()) {
                            invalid += "$fallbackPrefix.$field"
                        }
                    }
                }
            }
        }
        return invalid
    }

    /** `route` 下声明的唯一分支名（兼容字符串写法）。 */
    private fun routeNameOf(profile: ValueMap): String? = when (val value = profile["route"]) {
        is String -> value.takeIf { it.isNotEmpty() && it != "null" }
        is Map<*, *> -> value.keys.filterIsInstance<String>().firstOrNull { it in routes }
        else -> null
    }

    private fun fallbackTargetOf(profile: ValueMap): String? {
        profile["fallback"].asValueMap()?.let { fallback ->
            val to = fallback["to"] as? String ?: ""
            if (to.isNotEmpty() && to != "null") return to
        }
        /* 过渡期构建的扁平写法。 */
        return (profile["fallback_to"] as? String)?.takeIf { it.isNotEmpty() && it != "null" }
    }

    // ---- 视图组装 ----

    private fun generalFields(
        profile: ValueMap,
        baseline: ValueMap,
        route: String?,
        fallbackTo: String?,
    ): List<GhostLockExecutionFieldView> {
        fun read(root: ValueMap, path: String): Long? = if (path.startsWith("execution.")) {
            root["execution"].asValueMap()?.getLongAt(path.removePrefix("execution."))
        } else {
            root.getLongAt(path)
        }
        /* route 调参只列当前 route（含 fallback）的叶子，按名排序保证顺序稳定。 */
        val paths = GeneralPaths +
            routeTuningPaths(profile, route) +
            routeTuningPaths(profile, fallbackTo?.takeIf { it != "none" && it != route })
        return paths.map { path ->
            val value = read(profile, path) ?: 0L
            GhostLockExecutionFieldView(
                path = path,
                value = value,
                overridden = read(baseline, path)?.let { it != value } == true,
            )
        }
    }

    private fun routeTuningPaths(profile: ValueMap, route: String?): List<String> {
        if (route == null || route !in routes) return emptyList()
        val group = profile["execution"].asValueMap()?.get("routes").asValueMap()
            ?.get(route).asValueMap() ?: return emptyList()
        return group.keys.filterIsInstance<String>().sorted()
            .map { "execution.routes.$route.$it" }
    }

    /** 用显式 null 补全共享几何与当前 route 的字段，编辑器才看得到完整可编辑面。 */
    private fun completeProfileFields(
        profile: ValueMap,
        route: String?,
        fallbackTo: String?,
    ): ValueMap {
        val out = profile.copyValue().asValueMap() ?: return profile
        if (!out.containsKey("kernel_phys_load")) out["kernel_phys_load"] = null
        if (!out.containsKey("kernel_phys_offset")) out["kernel_phys_offset"] = null
        completeSection(out, "task_struct", TaskStructFieldNames)
        completeSection(out, "cred", CredFieldNames)
        completeSection(out, "offset", OffsetFieldNames)
        completeSection(out, "kernelsnitch", KernelsnitchFieldNames)
        route?.let { completeRouteBranch(out["route"].asValueMap(), it) }
        if (fallbackTo != null && fallbackTo != "none") {
            completeRouteBranch(
                out["fallback"].asValueMap()?.get("route").asValueMap(),
                fallbackTo,
            )
        }
        return out
    }

    private fun completeSection(out: ValueMap, section: String, fields: List<String>) {
        val target = out[section].asValueMap() ?: valueMapOf().also { out[section] = it }
        for (field in fields) if (!target.containsKey(field)) target[field] = null
    }

    private fun completeRouteBranch(container: ValueMap?, route: String) {
        val fields = RouteBranchFields[route] ?: return
        val containerMap = container ?: return
        val branch = containerMap[route].asValueMap()
            ?: valueMapOf().also { containerMap[route] = it }
        for (field in fields) if (!branch.containsKey(field)) branch[field] = null
    }

    private fun buildTree(
        node: ValueMap,
        prefix: String,
        baseline: ValueMap,
        override: ValueMap,
    ): List<GhostLockFieldNodeView> {
        val groups = mutableListOf<GhostLockFieldNodeView>()
        val leaves = mutableListOf<GhostLockFieldNodeView>()
        for ((key, value) in node) {
            val path = if (prefix.isEmpty()) key else "$prefix.$key"
            when {
                value is Map<*, *> -> {
                    /* execution 在通用页编辑，不进高级树。 */
                    if (key == "execution") continue
                    val children = buildTree(
                        value.asValueMap() ?: valueMapOf(), path, baseline, override,
                    )
                    if (children.isNotEmpty()) {
                        groups += GhostLockFieldNodeView(
                            path = path,
                            name = key,
                            value = null,
                            overridden = children.any { it.overridden },
                            children = children,
                        )
                    }
                }

                value is Number -> if (path !in ExcludedPaths) {
                    val overrideValue = override.getLongAt(path)
                    leaves += GhostLockFieldNodeView(
                        path = path,
                        name = key,
                        value = value.toLong(),
                        overridden = overrideValue != null &&
                            overrideValue != baseline.getLongAt(path),
                        children = emptyList(),
                    )
                }

                value == null -> if (path !in ExcludedPaths) {
                    leaves += GhostLockFieldNodeView(
                        path = path,
                        name = key,
                        value = null,
                        overridden = override.getValueAt(path) != null,
                        children = emptyList(),
                    )
                }
            }
        }
        return groups.sortedBy { it.name } + leaves.sortedBy { it.name }
    }

    // ---- 持久化与来源 ----

    private fun cache(release: String, document: NativeProfileDocument?) {
        cachedRelease = release
        cachedDocument = document
    }

    private fun buildNativeDocument(release: String, profile: ValueMap): NativeProfileDocument? {
        val route = routeNameOf(profile)
        val fallbackTo = fallbackTargetOf(profile)
        return NativeProfileDocument.from(
            release = release,
            route = route,
            fallbackTo = fallbackTo,
        ) { path -> ProfileResolver.nativeValue(profile, route, fallbackTo, path) }
    }

    /** 从 override 层剥掉 profile 元数据；元数据只能由文档声明。 */
    private fun stripMetadata(override: ValueMap?) {
        override ?: return
        ExcludedPaths.forEach(override::remove)
    }

    /** 新建一个 route 分支时用它种下字段，否则编辑器没有可填的格子。 */
    private fun routeBranchTemplate(route: String): ValueMap {
        val template = valueMapOf()
        RouteBranchFields[route].orEmpty().forEach { template[it] = null }
        return template
    }

    /** 切换 route/fallback 后只保留选中分支，旧分支的编辑不能把选择拉回去。 */
    private fun pruneOverrideBranches(entry: ValueMap, key: String, keep: String?) {
        val container = if (key == "fallback") {
            entry["fallback"].asValueMap()?.get("route").asValueMap()
        } else {
            entry[key].asValueMap()
        }
        if (container != null) {
            container.keys.toList().filter { it != keep }.forEach(container::remove)
            if (container.isEmpty()) {
                if (key == "fallback") {
                    entry["fallback"].asValueMap()?.remove("route")
                } else {
                    entry.remove(key)
                }
            }
        }
        if (key == "fallback") {
            entry["fallback"].asValueMap()?.let { fallback ->
                if (fallback.isEmpty()) entry.remove("fallback")
            }
        }
    }

    /** 用户导入的 profile 条目：优先当前选中，其次同 release 的最新文档。 */
    private fun importedEntry(release: String): ValueMap? {
        val preferred = activeUserProfile()
        val names = if (preferred != null) {
            listOf(preferred)
        } else {
            store.list().filter { it.release == release }.map { it.name }
        }
        /* 每个候选文档都要解析 include，一次性读全部已存文档避免重复 IO。 */
        val documents = store.documents()
        var lastError: String? = null
        for (name in names) {
            val text = documents[name]
            if (text == null) {
                if (preferred != null) lastError = "profileMissing: $name"
                continue
            }
            val parsed = runCatching {
                HoconSupport.parseValue(text) { path ->
                    resolveImportedInclude(path, documents)
                }.asValueMap()
            }
            if (parsed.isFailure) {
                /* 坏文档不能让用户面对「没有可用 profile」而不知道原因。 */
                val error = parsed.exceptionOrNull()!!
                lastError = "$name: ${error.message ?: error.javaClass.simpleName}"
                continue
            }
            val entry = parsed.getOrNull() ?: continue
            val candidate = if (entry.containsKey("release")) {
                entry
            } else {
                (entry["profiles"] as? List<*>)
                    ?.mapNotNull { it.asValueMap() }
                    ?.firstOrNull { it["release"] == release }
            }
            if (candidate == null) {
                /* 选中的文档里没有这一段：把文档实际声明的 release 带出去，
                 * 否则运行侧只能笼统报 noProfile。 */
                if (preferred != null) {
                    val declared = entry["release"] as? String
                        ?: (entry["profiles"] as? List<*>)
                            ?.firstNotNullOfOrNull { item ->
                                (item.asValueMap()?.get("release") as? String)
                                    ?.takeIf { it.isNotEmpty() }
                            }
                    lastError = "profileReleaseMismatch: ${declared ?: "?"} != $release"
                }
                continue
            }
            if (candidate["release"] != release) {
                lastError = "profileReleaseMismatch: ${candidate["release"]} != $release"
                continue
            }
            return LegacyProfileConverter.convertValue(candidate) ?: candidate
        }
        if (lastError != null) lastResolveError = lastError
        return null
    }

    /**
     * 解析用户文档里的 `include`：先查已存文档，再查内置表。
     *
     * 返回 null 时 [HoconSupport] 会抛出带路径的异常，最终由导入/加载链路报给用户。
     */
    private fun resolveImportedInclude(path: String, documents: Map<String, String>): String? {
        val key = path.substringAfterLast('/')
        documents[key]?.let { return it }
        assets.load("$BUILTIN_DIR/$path").takeIf { it.isNotBlank() }?.let { return it }
        return assets.load("$BUILTIN_DIR/$key").takeIf { it.isNotBlank() }
    }

    private fun materializeInvalidPaths(profile: ValueMap, invalidPaths: Set<String>) {
        invalidPaths.forEach { path ->
            val segments = path.split('.')
            var node: ValueMap = profile
            for (index in 0 until segments.size - 1) {
                node = node.mutableChild(segments[index])
            }
            if (!node.containsKey(segments.last())) node[segments.last()] = null
        }
    }

    private fun fillRouteExecutionDefaults(profile: ValueMap) {
        ProfileMerger.fillRouteExecutionDefaults(profile, routePresets())
    }

    private fun trimRouteTuning(profile: ValueMap) {
        val routesMap = profile["execution"].asValueMap()?.get("routes").asValueMap() ?: return
        val keep = buildSet {
            routeNameOf(profile)?.let(::add)
            fallbackTargetOf(profile)?.takeIf { it != "none" }?.let(::add)
        }
        routesMap.keys.toList().filter { it !in keep }.forEach(routesMap::remove)
    }

    private fun routePresets(): Map<String, ValueMap> = routes.mapNotNull { route ->
        readExecutionRoute(route)?.let { route to it }
    }.toMap()

    private fun readExecutionRoute(route: String): ValueMap? = runCatching {
        parseObject("$BUILTIN_DIR/execution-${route.replace('_', '-')}.conf")
            ?.get("execution").asValueMap()
            ?.get("routes").asValueMap()
            ?.get(route).asValueMap()
    }.getOrNull()

    private fun readExecutionTuning(): ValueMap? = parseObject("$BUILTIN_DIR/execution-tuning.conf")

    private fun loadIndex(): Map<String, String> {
        val root = parseObject("$BUILTIN_DIR/index.conf") ?: return emptyMap()
        val profiles = root["profiles"] as? List<*> ?: return emptyMap()
        val out = LinkedHashMap<String, String>()
        for (item in profiles) {
            val map = item.asValueMap() ?: continue
            val release = map["release"] as? String ?: continue
            val file = map["file"] as? String ?: continue
            out[release] = file
        }
        return out
    }

    private fun parseObject(path: String): ValueMap? {
        val text = assets.load(path)
        if (text.isBlank()) return null
        return runCatching { HoconSupport.parseValue(text).asValueMap() }.getOrNull()
    }

    private fun pairFor(tuning: ValueMap?): CpuPairView {
        val recommended = tuning?.get("execution").asValueMap()?.get("recommended_cpus").asValueMap()
        return CpuPairView(
            main = (recommended?.get("main") as? Number)?.toInt() ?: 0,
            consumer = (recommended?.get("consumer") as? Number)?.toInt() ?: 1,
        )
    }

    private fun modifiedName(release: String): String =
        "${release.replace(Regex("[^A-Za-z0-9._-]"), "_")}-modified.conf"

    private companion object {
        const val BUILTIN_DIR = "kernel_profiles/ghostlock"

        /** 模板表的 release 后缀。 */
        const val TEMPLATE_SUFFIX = "-template"

        /** 编辑器不接受这些字段的修改。 */
        val ExcludedPaths = setOf(
            "schema_version",
            "release",
            /* 内核主版本是 profile 元数据，改坏会让整份配置无法解析。 */
            "kernel_major",
            "recommend_shizuku",
        )

        /** 编辑器暴露的 route 无关的 execution 调参。 */
        val GeneralPaths = listOf(
            "execution.selected_cpus.main",
            "execution.selected_cpus.consumer",
            "execution.heap.prepare_max_attempts",
            "execution.heap.prepare_timeout_ms",
            "execution.heap.kernelsnitch_timeout_ms",
            "execution.race.route_wait_ms",
            "execution.race.route_done_timeout_ms",
            "execution.race.setup_settle_us",
            "execution.race.state_poll_interval_us",
            "execution.stages.w1_attempts",
            "execution.stages.w1_settle_us",
            "execution.stages.w1_scratch_repair_attempts",
            "execution.stages.w2_attempts",
            "execution.stages.w2_settle_us",
            "execution.stages.w3_chain_rounds",
            "execution.stages.w3_attempts",
            "execution.stages.w3_settle_us",
            "execution.handoff.pre_dispatch_settle_ms",
            "execution.handoff.module_poll_attempts",
            "execution.handoff.module_poll_interval_ms",
            "execution.handoff.enforce_poll_attempts",
            "execution.handoff.enforce_poll_interval_ms",
        )

        val RouteCommonRequired = listOf(
            "offset.init_task", "offset.init_cred", "offset.root_task_group",
            "offset.selinux_enforcing",
            "task_struct.prio", "task_struct.pi_lock", "task_struct.pi_waiters",
            "task_struct.pi_blocked_on",
            "task_struct.cred", "task_struct.seccomp",
        )

        val TaskStructFieldNames = listOf(
            "prio", "normal_prio", "sched_task_group", "pi_lock", "pi_waiters", "pi_top_task",
            "pi_blocked_on", "pid", "tgid", "atomic_flags", "real_cred", "cred", "comm", "tasks",
            "seccomp",
        )

        val CredFieldNames = listOf(
            "copy_size", "usage_offset", "usage_value", "caps_offset", "caps_count", "caps_value",
            "ref_count", "ref0_offset", "ref1_offset", "ref2_offset", "ref3_offset",
            "ref0_image", "ref1_image", "ref2_image", "ref3_image",
        )

        val OffsetFieldNames = listOf(
            "init_task", "init_cred", "empty_zero_page", "root_task_group", "selinux_enforcing",
            "selinux_blob_sizes", "security_hook_heads", "slide_nfulnl_logger",
            "slide_loggers_0_1", "slide_boot_id",
        )

        val KernelsnitchFieldNames = listOf("collisions", "mm_struct_sz")

        val RouteBranchFields = mapOf(
            "tcp_zerocopy" to listOf("compact_waiter"),
            "select_stack" to listOf("waiter_shift"),
            "multicast_waiter" to listOf(
                "waiter_off", "buffer_size", "task_offset", "lock_offset", "compact_waiter",
            ),
        )

        val RouteMulticastFields = listOf("buffer_size", "task_offset", "lock_offset")

        const val SizeofU32 = 4L
        const val SizeofU64 = 8L
    }
}
