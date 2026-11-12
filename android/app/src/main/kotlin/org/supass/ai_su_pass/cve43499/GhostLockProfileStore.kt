package org.supass.ai_su_pass.cve43499

import android.content.Context
import java.io.File

/**
 * 用户导入的 profile，按原样存放在应用私有目录。
 *
 * 与上游的差别：文档不展开 include（`render_conf` 产出的是 self-contained 文本），
 * 因此没有 `MissingIncludes` 与 include 链。
 */
internal class GhostLockProfileStore(private val directory: File) {

    data class Stored(
        val name: String,
        val release: String?,
        val importedAt: Long,
        val sizeBytes: Long,
        val parseError: Boolean,
    )

    /** 按导入时间倒序。 */
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

    fun delete(name: String): Boolean = fileByName(name)?.delete() == true

    fun save(name: String, text: String): Boolean = runCatching {
        directory.mkdirs()
        File(directory, sanitize(name)).writeText(text, Charsets.UTF_8)
        true
    }.getOrDefault(false)

    private fun files(): List<File> = directory.listFiles().orEmpty()
        .filter { it.isFile && it.extension == "conf" }
        .sortedByDescending { it.lastModified() }

    private fun fileByName(name: String): File? = files().firstOrNull { it.name == name }

    /** 从 HOCON 文本取 `release = "..."`；取不到返回 null。 */
    private fun parseRelease(text: String): String? =
        Regex("(?m)^\\s*release\\s*=\\s*\"([^\"]+)\"")
            .find(text)?.groupValues?.getOrNull(1)

    private fun sanitize(name: String): String =
        name.replace(Regex("[\\\\/:*?\"<>|\\x00-\\x1f]"), "_")

    companion object {
        fun directory(context: Context): File =
            File(context.filesDir, "ghostlock_profiles")

        fun fileNameFor(release: String): String =
            release.replace(Regex("[^A-Za-z0-9._-]"), "_") + ".conf"
    }
}
