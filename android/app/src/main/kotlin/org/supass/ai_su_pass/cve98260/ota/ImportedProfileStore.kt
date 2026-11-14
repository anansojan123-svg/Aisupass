package org.supass.ai_su_pass.cve98260.ota

import android.content.Context
import android.util.Log
import org.supass.ai_su_pass.cve98260.KernelProfile
import org.supass.ai_su_pass.cve98260.ProfileDocument
import java.io.File

/**
 * 用户导入的 profile 目录（App 私有）。
 *
 * 一份文档一个 `.conf` 文件，**文件名即文档名**（唯一键），release 只是文档内的
 * 字段。与 GhostLock 一致：同一 release 可以有多份文档，谁生效由
 * [ImportedProfileSelection] 显式选择，未选时取最近修改的一份。
 */
class ImportedProfileStore(private val context: Context) {

    data class ImportedProfile(
        val name: String,
        val release: String,
        val detail: String,
        val parseError: Boolean,
        val importedAt: Long,
    )

    /** 列出全部文档，最近修改优先；解析失败的仍返回，便于用户删掉。 */
    fun list(): List<ImportedProfile> = files().map { file ->
        val doc = runCatching { ProfileDocument.parse(file.readText(Charsets.UTF_8)) }
            .onFailure { Log.w(TAG, "读取 ${file.name} 失败: ${it.message}") }
            .getOrNull()
        ImportedProfile(
            name = file.name,
            release = doc?.release ?: file.nameWithoutExtension,
            detail = doc?.getString("_source").orEmpty(),
            parseError = doc == null,
            importedAt = file.lastModified(),
        )
    }

    /** 全部已存文档的原始文本，按文件名索引，供 HOCON `include` 解析。 */
    fun documents(): Map<String, String> {
        val byName = linkedMapOf<String, String>()
        for (file in files()) {
            runCatching { file.readText(Charsets.UTF_8) }.getOrNull()?.let { byName[file.name] = it }
        }
        return byName
    }

    /** 按文档名读原始 HOCON 文本；不存在返回空串。 */
    fun readRaw(name: String): String {
        val file = fileOf(name)
        if (!file.isFile) return ""
        return runCatching { file.readText(Charsets.UTF_8) }.getOrDefault("")
    }

    /** 按文档名读可编辑文档；不存在或解析失败返回 null。 */
    fun readDocument(name: String): ProfileDocument? {
        val file = fileOf(name)
        if (!file.isFile) return null
        val documents = documents()
        return runCatching {
            ProfileDocument.parse(file.readText(Charsets.UTF_8)) { path ->
                val key = path.substringAfterLast('/')
                documents[key]
            }
        }.onFailure { Log.w(TAG, "解析 ${file.name} 失败: ${it.message}") }
            .getOrNull()
    }

    /** 按文档名读完整 profile；不存在或解析失败返回 null。 */
    fun loadByName(name: String): KernelProfile? =
        readDocument(name)?.let { doc ->
            runCatching { doc.toKernelProfile() }
                .onFailure { Log.w(TAG, "转换 ${name} 失败: ${it.message}") }
                .getOrNull()
        }

    /** 覆盖写入一份文档；文档名固定为 [name]。 */
    fun save(name: String, doc: ProfileDocument): Boolean = runCatching {
        val dir = dir()
        if (!dir.isDirectory && !dir.mkdirs()) return false
        fileOf(name).writeText(doc.toHocon(), Charsets.UTF_8)
        true
    }.onFailure { Log.w(TAG, "写入 $name 失败: ${it.message}") }
        .getOrDefault(false)

    /**
     * 以 [preferredName] 为基础另存为一份新文档。
     *
     * 为空时用文档 release 派生默认名；同名已存在则追加 `-2`、`-3`。
     * 返回实际使用的文档名，失败返回空串。
     */
    fun saveAs(doc: ProfileDocument, preferredName: String = ""): String {
        val base = preferredName.ifBlank { fileNameOf(doc.release) }.removeSuffix(".$EXT")
        val stem = sanitize(base).ifBlank { "profile" }
        val name = uniqueName(stem)
        return if (save(name, doc)) name else ""
    }

    /** 导入落盘：同一 release 覆盖默认名，不产生副本。 */
    fun saveImported(doc: ProfileDocument): String {
        val name = fileNameOf(doc.release)
        return if (save(name, doc)) name else ""
    }

    fun remove(name: String): Boolean = fileOf(name).delete()

    /** 重命名；目标已存在或源不存在返回空串。 */
    fun rename(name: String, newName: String): String {
        val file = fileOf(name)
        if (!file.isFile) return ""
        val stem = sanitize(newName.removeSuffix(".$EXT"))
        if (stem.isEmpty()) return ""
        val target = File(dir(), "$stem.$EXT")
        if (target.name == file.name) return file.name
        if (target.exists()) return ""
        return if (file.renameTo(target)) target.name else ""
    }

    private fun files(): List<File> = dir().listFiles { f -> f.isFile && f.extension == EXT }
        .orEmpty()
        .sortedByDescending { it.lastModified() }

    private fun dir(): File = File(context.filesDir, DIR)

    private fun fileOf(name: String): File = File(dir(), sanitize(name).let {
        if (it.endsWith(".$EXT")) it else "$it.$EXT"
    })

    /** 在目录里找一个不冲突的名字。 */
    private fun uniqueName(stem: String): String {
        if (!fileOf(stem).exists()) return "$stem.$EXT"
        var index = 2
        while (fileOf("$stem-$index").exists()) index++
        return "$stem-$index.$EXT"
    }

    private fun sanitize(name: String): String = name
        .replace(Regex("[\\\\/:*?\"<>|\\x00-\\x1f]"), "_")
        .trim('.')
        .takeIf { it.isNotEmpty() } ?: "profile"

    companion object {
        private const val TAG = "ImportedProfileStore"

        /** App 私有子目录，与 assets 的 `kernel_profiles` 区分开。 */
        const val DIR = "profiles"

        private const val EXT = "conf"

        /**
         * 由 release 派生默认文件名（导入落盘使用）。
         *
         * release 来自 boot.img 内的字符串，属**不可信输入**：只保留文件安全字符，
         * 防止 `../` 之类的路径穿越。
         */
        fun fileNameOf(release: String): String =
            release.map { c ->
                if (c.isLetterOrDigit() || c == '.' || c == '-' || c == '_') c else '_'
            }.joinToString("").trim('.').ifEmpty { "unknown" } + ".$EXT"
    }
}
