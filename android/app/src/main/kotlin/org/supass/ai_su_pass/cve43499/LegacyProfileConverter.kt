package org.supass.ai_su_pass.cve43499

import org.supass.ai_su_pass.cve43499.profile.ValueMap
import org.supass.ai_su_pass.cve43499.profile.asValueMap
import org.supass.ai_su_pass.cve43499.profile.mutableChild
import org.supass.ai_su_pass.cve43499.profile.valueMapOf

/**
 * 把 remote/main 时期的 `offsets.json` 迁移到当前 schema。
 *
 * 该时期的报文只含 6.x 内核、无 Shizuku、无 5.x 几何：字段为
 * `kernel_phys_load`、`pselect_waiter_shift`、`compact_waiter`、`mm_struct_sz`，
 * `symbols.off_*` 与 `struct_fields.task_*`，外加 `kimage_text_base` / `btf_size`。
 * 转换幂等，同时归一化过渡期的扁平前缀、`route` 字符串与 `fallback_to`。
 * multicast 是后出的 route，该时期从未选择，故此处不支持。
 */
private fun moveKey(
    source: ValueMap,
    target: ValueMap,
    from: String,
    to: String,
) {
    if (source.containsKey(from) && source[from] != null && !target.containsKey(to)) {
        target[to] = source[from]
    }
    source.remove(from)
}

internal object LegacyProfileConverter {
    private val MetadataKeys = listOf("kimage_text_base", "btf_size", "kallsyms")

    /* 只搬当前 schema 认识的键；BTE 专属字段（rt_mutex_waiter / cred_uid /
     * seccomp_*）原样留在原处，由校验侧忽略。 */
    private val TaskStructFields = setOf(
        "prio", "normal_prio", "sched_task_group", "pi_lock", "pi_waiters",
        "pi_top_task", "pi_blocked_on", "pid", "tgid", "atomic_flags",
        "real_cred", "cred", "comm", "tasks", "seccomp",
    )
    private val CredFields = setOf(
        "copy_size", "usage_offset", "usage_value", "caps_offset", "caps_count",
        "caps_value", "ref_count", "ref0_offset", "ref1_offset", "ref2_offset",
        "ref3_offset", "ref0_image", "ref1_image", "ref2_image", "ref3_image",
    )
    private val OffsetFields = setOf(
        "init_task", "init_cred",
        "root_task_group", "selinux_enforcing", "selinux_blob_sizes",
        "security_hook_heads", "slide_nfulnl_logger", "slide_loggers_0_1",
        "slide_boot_id",
    )

    /* 每条 route 一个旧布局编解码器；新增 route = 加一个 codec 并在此注册，
     * 不再用 `when` 罗列 route 名。 */
    private interface LegacyRouteCodec {
        fun fillBranch(entry: ValueMap, branch: ValueMap)
        fun fillFallback(entry: ValueMap, branch: ValueMap)
    }

    private object TcpRouteCodec : LegacyRouteCodec {
        override fun fillBranch(entry: ValueMap, branch: ValueMap) =
            moveKey(entry, branch, "compact_waiter", "compact_waiter")

        override fun fillFallback(entry: ValueMap, branch: ValueMap) =
            moveKey(entry, branch, "compact_waiter", "compact_waiter")
    }

    private object SelectRouteCodec : LegacyRouteCodec {
        override fun fillBranch(entry: ValueMap, branch: ValueMap) =
            moveKey(entry, branch, "pselect_waiter_shift", "waiter_shift")

        override fun fillFallback(entry: ValueMap, branch: ValueMap) =
            moveKey(entry, branch, "pselect_waiter_shift", "waiter_shift")
    }

    private val RouteCodecs: Map<String, LegacyRouteCodec> = mapOf(
        "tcp_zerocopy" to TcpRouteCodec,
        "select_stack" to SelectRouteCodec,
    )

    /* 与内置 `credential-6x.conf` / `kernelsnitch-6x.conf` 保持一致。 */
    private val CredDefaults6x = valueMapOf(
        "caps_offset" to 48L,
        "copy_size" to 136L,
        "usage_value" to 1L,
        "caps_count" to 5L,
        "caps_value" to -1L,
    )
    private val KernelsnitchDefaults6x = valueMapOf(
        "collisions" to 4L,
    )

    fun convertValue(entry: ValueMap?): ValueMap? {
        if (entry == null) return null
        /* 内置提取器仍输出无 schema_version 的 v1 报文，需归一化并补默认值；
         * v2 只在原处归一化，作者的编辑仍能看到自己的缺字段。 */
        val legacy = !entry.containsKey("schema_version")
        MetadataKeys.forEach(entry::remove)
        moveFlatNamespaces(entry)
        moveSymbolGroups(entry)
        moveKernelsnitch(entry)
        if (legacy && entry.containsKey("release")) {
            /* remote/main 时期只有 6.x；文档未声明时补 6，显式值优先。 */
            if (!entry.containsKey("kernel_major")) entry["kernel_major"] = 6L
        }
        moveRouteLayout(entry)
        moveFallback(entry)
        dropEmptyRouteBranches(entry)
        if (legacy) applySharedDefaults(entry)
        return entry
    }

    /** 补齐旧报文从不携带的公共 6.x 几何；仅对含 release 的完整文档生效。 */
    private fun applySharedDefaults(entry: ValueMap) {
        if (!entry.containsKey("release")) return
        if ((entry["kernel_major"] as? Number)?.toLong() != 6L) return
        fillMissing(entry, "cred", CredDefaults6x)
        fillMissing(entry, "kernelsnitch", KernelsnitchDefaults6x)
    }

    private fun fillMissing(entry: ValueMap, namespace: String, defaults: Map<String, Any?>) {
        val target = entry.mutableChild(namespace)
        for ((field, value) in defaults) {
            if (!target.containsKey(field)) target[field] = value
        }
    }

    /**
     * 早期构建把 route 切换写成空分支对象；它不含几何，不能遮蔽内置 route。
     * 当前写法的空值字段是显式 null，不会被这里删掉。
     */
    private fun dropEmptyRouteBranches(entry: ValueMap) {
        entry["route"].asValueMap()?.let { route ->
            route.keys.toList()
                .filter { key -> route[key].asValueMap()?.isEmpty() == true }
                .forEach(route::remove)
            if (route.isEmpty()) entry.remove("route")
        }
        entry["fallback"].asValueMap()?.get("route").asValueMap()?.let { route ->
            route.keys.toList()
                .filter { key -> route[key].asValueMap()?.isEmpty() == true }
                .forEach(route::remove)
            if (route.isEmpty()) entry["fallback"].asValueMap()?.remove("route")
        }
    }

    /** `symbols.off_x` → `offset.x`，`struct_fields.task_x` → `task_struct.x`。 */
    private fun moveSymbolGroups(entry: ValueMap) {
        moveGroup(entry, "symbols", "offset", "off_", OffsetFields)
        moveGroup(entry, "struct_fields", "task_struct", "task_", TaskStructFields)
        /* 过渡期构建也把凭据/调参键放在这里。 */
        moveGroup(entry, "struct_fields", "cred", "cred_", CredFields)
        val structFields = entry["struct_fields"].asValueMap() ?: return
        val snitch = entry.mutableChild("kernelsnitch")
        moveKey(structFields, snitch, "kernelsnitch_collisions", "collisions")
        moveKey(structFields, snitch, "mm_struct_sz", "mm_struct_sz")
        if (snitch.isEmpty()) entry.remove("kernelsnitch")
        if (structFields.isEmpty()) entry.remove("struct_fields")
    }

    private fun moveGroup(
        entry: ValueMap,
        groupName: String,
        namespace: String,
        prefix: String,
        allowed: Set<String>,
    ) {
        val group = entry[groupName].asValueMap() ?: return
        val matching = group.keys
            .filter { it.startsWith(prefix) && it.removePrefix(prefix) in allowed }
        if (matching.isEmpty()) return
        val target = entry.mutableChild(namespace)
        for (key in matching) {
            val field = key.removePrefix(prefix)
            if (!target.containsKey(field)) target[field] = group[key]
            group.remove(key)
        }
        if (group.isEmpty()) entry.remove(groupName)
    }

    private fun moveFlatNamespaces(entry: ValueMap) {
        val namespaces = listOf(
            Triple("task_struct", "task_", TaskStructFields),
            Triple("cred", "cred_", CredFields),
            Triple("offset", "off_", OffsetFields),
        )
        for ((namespace, flatPrefix, allowed) in namespaces) {
            val keys = entry.keys
                .filter { it.startsWith(flatPrefix) && it.removePrefix(flatPrefix) in allowed }
            if (keys.isEmpty()) continue
            val nested = entry.mutableChild(namespace)
            for (key in keys) {
                val field = key.removePrefix(flatPrefix)
                if (!nested.containsKey(field)) nested[field] = entry[key]
                entry.remove(key)
            }
        }
        /* 过渡期构建的命名空间拼写。 */
        for ((legacy, current) in listOf("task" to "task_struct", "off" to "offset")) {
            val legacyObject = entry[legacy].asValueMap() ?: continue
            val target = entry.mutableChild(current)
            legacyObject.forEach { (field, value) ->
                if (!target.containsKey(field)) target[field] = value
            }
            entry.remove(legacy)
        }
    }

    private fun moveKernelsnitch(entry: ValueMap) {
        val hasFlat = entry.containsKey("kernelsnitch_collisions") || entry.containsKey("mm_struct_sz")
        if (!hasFlat) return
        val nested = entry.mutableChild("kernelsnitch")
        moveKey(entry, nested, "kernelsnitch_collisions", "collisions")
        moveKey(entry, nested, "mm_struct_sz", "mm_struct_sz")
        if (nested.isEmpty()) entry.remove("kernelsnitch")
    }

    private fun moveRouteLayout(entry: ValueMap) {
        fun fillBranch(name: String, branch: ValueMap) {
            RouteCodecs[name]?.fillBranch(entry, branch)
        }

        when (val route = entry["route"]) {
            is String -> {
                val branch = valueMapOf()
                fillBranch(route, branch)
                entry["route"] = valueMapOf(route to branch)
            }

            is Map<*, *> -> Unit

            else -> if (entry.containsKey("release")) {
                /* remote/main 报文没有 route 字段：按 6.x 专有几何推断
                 * （有 compact waiter → tcp，否则 select）。稀疏覆盖片段无
                 * release，不推断，避免空的覆盖注入 route。 */
                val inferred = inferRoute(entry)
                val branch = valueMapOf()
                fillBranch(inferred, branch)
                entry["route"] = valueMapOf(inferred to branch)
            }
        }
        /* 扁平键留给 moveFallback：tcp route 的 pselect shift 仍要作为
         * 显式 select_stack fallback，由它移除。 */
    }

    private fun moveFallback(entry: ValueMap) {
        val fallbackValue = entry["fallback_to"]
        if (fallbackValue is String) {
            entry.remove("fallback_to")
            val fallback = entry["fallback"].asValueMap() ?: valueMapOf()
            fallback["to"] = fallbackValue
            if (fallbackValue != "none") {
                val branch = fallback["route"].asValueMap()?.get(fallbackValue).asValueMap()
                    ?: valueMapOf()
                RouteCodecs[fallbackValue]?.fillFallback(entry, branch)
                if (branch.isNotEmpty()) {
                    fallback["route"] = valueMapOf(fallbackValue to branch)
                }
            }
            entry["fallback"] = fallback
            entry.remove("compact_waiter")
            entry.remove("pselect_waiter_shift")
            return
        }
        if (entry["fallback"].asValueMap() != null || entry["route"].asValueMap() == null) {
            entry.remove("compact_waiter")
            entry.remove("pselect_waiter_shift")
            return
        }
        if (!entry.containsKey("release")) {
            /* 稀疏覆盖片段不得凭空获得 fallback，否则会覆盖 offsets 里的选择。 */
            entry.remove("compact_waiter")
            entry.remove("pselect_waiter_shift")
            return
        }
        /* remote/main 没有 fallback 字段；有 pselect shift 时 tcp 仍可回退，
         * 故显式声明该能力。 */
        val routeName = entry["route"].asValueMap()?.keys?.firstOrNull()
        val pselect = entry["pselect_waiter_shift"]
        if (routeName == "tcp_zerocopy" && pselect != null) {
            entry["fallback"] = valueMapOf(
                "to" to "select_stack",
                "route" to valueMapOf("select_stack" to valueMapOf("waiter_shift" to pselect)),
            )
        } else {
            entry["fallback"] = valueMapOf("to" to "none")
        }
        entry.remove("compact_waiter")
        entry.remove("pselect_waiter_shift")
    }

    private fun inferRoute(entry: ValueMap): String {
        if (((entry["compact_waiter"] as? Number)?.toLong() ?: 0L) != 0L) return "tcp_zerocopy"
        return "select_stack"
    }
}
