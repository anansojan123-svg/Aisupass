package org.supass.ai_su_pass.cve98260

/**
 * 用户 profile 的可编辑字段集合。
 *
 * 路径与 [ProfileDocument.fromKernelProfile] 的键名逐字一致，顺序即 UI 展示顺序；
 * `hex` 为 true 的字段是 64 位地址，其余是 32 位结构偏移。
 */
object KernelProfileEditor {

    /** 单个可编辑字段：[advanced] 为 true 时归入「高级布局」分组。 */
    data class FieldSpec(val path: String, val hex: Boolean, val advanced: Boolean)

    /** 基础偏移：calib 与 cred 定位的核心项。 */
    private val CORE: List<FieldSpec> = listOf(
        FieldSpec("page_offset", hex = true, advanced = false),
        FieldSpec("offset.timer_link", hex = true, advanced = false),
        FieldSpec("offset.cred_link", hex = true, advanced = false),
        FieldSpec("offset.selinux_link", hex = true, advanced = false),
        FieldSpec("offset.user_ns", hex = true, advanced = false),
        FieldSpec("offset.root_user", hex = true, advanced = false),
        FieldSpec("offset.groups", hex = true, advanced = false),
        FieldSpec("offset.ucounts", hex = true, advanced = false),
        FieldSpec("offset.task_cred", hex = false, advanced = false),
        FieldSpec("offset.task_struct_size", hex = false, advanced = false),
        FieldSpec("offset.cred_uid", hex = false, advanced = false),
        FieldSpec("offset.kitimer_node", hex = false, advanced = false),
    )

    /** 高级布局：kitimer/cred 结构体布局，按 KMI 平移，通常无需改动。 */
    private val ADVANCED: List<FieldSpec> = listOf(
        FieldSpec("offset.kitimer_size", hex = true, advanced = true),
        FieldSpec("offset.task_alloc_link", hex = true, advanced = true),
        FieldSpec("offset.cred_size", hex = false, advanced = true),
        FieldSpec("offset.cred_cap_inheritable", hex = false, advanced = true),
        FieldSpec("offset.cred_cap_permitted", hex = false, advanced = true),
        FieldSpec("offset.cred_cap_effective", hex = false, advanced = true),
        FieldSpec("offset.cred_cap_bset", hex = false, advanced = true),
        FieldSpec("offset.cred_cap_ambient", hex = false, advanced = true),
        FieldSpec("offset.cred_security", hex = false, advanced = true),
        FieldSpec("offset.cred_user", hex = false, advanced = true),
        FieldSpec("offset.cred_user_ns", hex = false, advanced = true),
        FieldSpec("offset.cred_ucounts", hex = false, advanced = true),
        FieldSpec("offset.cred_groups", hex = false, advanced = true),
    )

    val FIELDS: List<FieldSpec> = CORE + ADVANCED

    private val PATHS: Set<String> = FIELDS.map { it.path }.toSet()

    /** 读出当前文档里这些字段的值；未提供的字段不出现在结果里。 */
    fun read(doc: ProfileDocument): Map<String, Long> {
        val values = linkedMapOf<String, Long>()
        for (spec in FIELDS) {
            doc.getLong(spec.path)?.let { values[spec.path] = it }
        }
        return values
    }

    /**
     * 把 [values] 合并进文档副本并返回。
     *
     * 只接受 [FIELDS] 内的路径；数值支持十进制与 `0x` 十六进制，
     * 解析失败抛 [ProfileConversionException]，由调用方转错误码。
     */
    fun apply(doc: ProfileDocument, values: Map<String, String>): ProfileDocument {
        val fields = deepCopy(doc.fields)
        for ((path, raw) in values) {
            if (path !in PATHS) {
                throw ProfileConversionException("未知字段: $path")
            }
            val value = coerceLong(raw)
                ?: throw ProfileConversionException("字段 $path 不是数值: $raw")
            setPath(fields, path, value)
        }
        return doc.copy(fields = fields)
    }

    /** 按点分路径写入，缺失的中间层按需创建。 */
    private fun setPath(fields: MutableMap<String, Any?>, path: String, value: Long) {
        val parts = path.split('.')
        var current = fields
        for (part in parts.dropLast(1)) {
            val child = current[part]
            val next = child as? MutableMap<String, Any?>
                ?: linkedMapOf<String, Any?>().also { current[part] = it }
            current = next
        }
        current[parts.last()] = value
    }

    /** 深拷贝嵌套 Map，保证 apply 不改动入参文档。 */
    private fun deepCopy(map: Map<*, *>): MutableMap<String, Any?> {
        val copy = linkedMapOf<String, Any?>()
        for ((key, value) in map) {
            if (key !is String) continue
            copy[key] = if (value is Map<*, *>) deepCopy(value) else value
        }
        return copy
    }
}
