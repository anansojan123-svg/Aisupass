package org.supass.ai_su_pass.cve43499

import android.content.Context
import java.io.File
import org.supass.ai_su_pass.cve98260.HoconSupport

/**
 * 用户导入的 profile，按原样存放在应用私有目录。
 *
 * 文档里的 `include` 由 [GhostLockProfileController] 在解析时展开：
 * 先查 [documents]，再查内置 assets。
 */
internal class GhostLockProfileStore(private val directory: File) {

    data class Stored(
        val name: String,
        val release: String?,
        val importedAt: Long,
        val sizeBytes: Long,
        val parseError: Boolean,
    )

    /**
     * 按导入时间倒序。
     *
     * 与上游 `UserProfileStore.list()` 一致：include 依赖也列出，
     * 取不到 `release` 的标记 [Stored.parseError]。
     */
    fun list(): List<Stored> = files().map { file ->
        val text = runCatching { file.readText() }.getOrDefault("")
        val release = runCatching { parseRelease(text) }
            .getOrNull()
            ?.takeIf { it.isNotEmpty() }
        Stored(
            name = file.name,
            release = release,
            importedAt = file.lastModified(),
            sizeBytes = file.length(),
            parseError = release == null,
        )
    }

    fun rawText(name: String): String? =
        fileByName(name)?.let { runCatching { it.readText() }.getOrNull() }

    /**
     * 全部已存文档，按文件名索引，供 HOCON `include` 解析。
     *
     * 与上游 `UserProfileStore.documents()` 一致：依赖文档一起导入后，
     * include 就能在本地命中。
     */
    fun documents(): Map<String, String> {
        val byName = linkedMapOf<String, String>()
        for (file in files()) {
            val text = runCatching { file.readText() }.getOrNull() ?: continue
            byName[file.name] = text
        }
        return byName
    }

    fun delete(name: String): Boolean = fileByName(name)?.delete() == true

    /**
     * 重命名一份文档；扩展名统一为 `.conf`。
     *
     * 目标已存在或源不存在时返回 null，否则返回新的文件名。
     */
    fun rename(name: String, newName: String): String? {
        val file = fileByName(name) ?: return null
        val stem = sanitize(newName).removeSuffix(".conf")
        if (stem.isEmpty()) return null
        val target = File(directory, "$stem.conf")
        if (target.name == file.name) return file.name
        if (target.exists()) return null
        return if (file.renameTo(target)) target.name else null
    }

    fun save(name: String, text: String): Boolean = runCatching {
        directory.mkdirs()
        File(directory, sanitize(name)).writeText(text, Charsets.UTF_8)
        true
    }.getOrDefault(false)

    private fun files(): List<File> = directory.listFiles().orEmpty()
        .filter { it.isFile && it.extension == "conf" }
        .sortedByDescending { it.lastModified() }

    private fun fileByName(name: String): File? = files().firstOrNull { it.name == name }

    /**
     * 从文档里取 release；取不到返回 null。
     *
     * 先按 HOCON/JSON 正式解析，能覆盖 `profiles: [...]` 多文档与 JSON 写法；
     * 解析失败（例如含无法展开的 `include`）时退回按行匹配 `release`。
     */
    private fun parseRelease(text: String): String? {
        val parsed = runCatching { HoconSupport.parseValue(text) }.getOrNull()
        releaseFrom(parsed)?.let { return it }
        return Regex("(?m)\"?release\"?\\s*[:=]\\s*\"([^\"]+)\"")
            .find(text)?.groupValues?.getOrNull(1)?.takeIf { it.isNotEmpty() }
    }

    private fun releaseFrom(value: Any?): String? = when (value) {
        is Map<*, *> -> {
            (value["release"] as? String)?.takeIf { it.isNotEmpty() }
                ?: (value["profiles"] as? List<*>)
                    ?.firstNotNullOfOrNull { releaseFrom(it) }
        }

        is List<*> -> value.firstNotNullOfOrNull { releaseFrom(it) }
        else -> null
    }

    private fun sanitize(name: String): String =
        name.replace(Regex("[\\\\/:*?\"<>|\\x00-\\x1f]"), "_")

    companion object {
        fun directory(context: Context): File =
            File(context.filesDir, "ghostlock_profiles")

        fun fileNameFor(release: String): String =
            release.replace(Regex("[^A-Za-z0-9._-]"), "_") + ".conf"
    }
}
