package org.supass.ai_su_pass.cve98260.ota

import android.content.Context
import android.util.Log
import org.supass.ai_su_pass.cve98260.KernelProfile
import org.supass.ai_su_pass.cve98260.ProfileDocument
import java.io.File

/**
 * 用户导入的 profile 目录（App 私有）。
 *
 * 一个 release 一个文件，不维护索引；文件名由 [fileNameOf] 归一化，
 * 与 `BuiltinProfileCatalog.match()` 共用同一套归一化，保证「写进去的」与
 * 「查得到的」是同一个文件名。
 */
class ImportedProfileStore(private val context: Context) {

    data class ImportedProfile(val release: String, val detail: String)

    /** 列出全部可解析的导入项；解析失败的仍返回，`detail` 为空串，便于用户删掉。 */
    fun list(): List<ImportedProfile> {
        val files = dir().listFiles { f -> f.isFile && f.extension == EXT } ?: return emptyList()
        return files.map { f ->
            val doc = runCatching { ProfileDocument.parse(f.readText(Charsets.UTF_8)) }
                .onFailure { Log.w(TAG, "读取 ${f.name} 失败: ${it.message}") }
                .getOrNull()
            ImportedProfile(
                release = doc?.release ?: f.nameWithoutExtension,
                detail = doc?.getString("_source").orEmpty(),
            )
        }.sortedBy { it.release }
    }

    /** 按精确 release 读一份完整 profile；文件不存在或解析失败返回 null。 */
    fun load(release: String): KernelProfile? {
        val file = fileOf(release)
        if (!file.isFile) return null
        return runCatching { ProfileDocument.parse(file.readText(Charsets.UTF_8)).toKernelProfile() }
            .onFailure { Log.w(TAG, "解析 ${file.name} 失败: ${it.message}") }
            .getOrNull()
    }

    /** 落盘并返回真正使用的 release；写失败抛 [java.io.IOException]，由调用方转错误码。 */
    fun save(doc: ProfileDocument): String {
        val dir = dir()
        if (!dir.isDirectory && !dir.mkdirs()) {
            throw java.io.IOException("mkdirs failed: ${dir.absolutePath}")
        }
        fileOf(doc.release).writeText(doc.toHocon(), Charsets.UTF_8)
        return doc.release
    }

    /** 按精确 release 读原始 HOCON 文本；文件不存在返回空串。 */
    fun readRaw(release: String): String {
        val file = fileOf(release)
        if (!file.isFile) return ""
        return runCatching { file.readText(Charsets.UTF_8) }
            .onFailure { Log.w(TAG, "读取 ${file.name} 失败: ${it.message}") }
            .getOrDefault("")
    }

    fun remove(release: String): Boolean = fileOf(release).delete()

    private fun dir(): File = File(context.filesDir, DIR)

    private fun fileOf(release: String): File = File(dir(), "${fileNameOf(release)}.$EXT")

    companion object {
        private const val TAG = "ImportedProfileStore"

        /** App 私有子目录，与 assets 的 `kernel_profiles` 区分开。 */
        const val DIR = "profiles"

        private const val EXT = "conf"

        /**
         * release 来自 boot.img 内的字符串，属**不可信输入**：
         * 只保留文件安全字符，防止 `../` 之类的路径穿越。
         */
        fun fileNameOf(release: String): String {
            val safe = release.map { c ->
                if (c.isLetterOrDigit() || c == '.' || c == '-' || c == '_') c else '_'
            }.joinToString("").trim('.')
            return safe.ifEmpty { "unknown" }
        }
    }
}
