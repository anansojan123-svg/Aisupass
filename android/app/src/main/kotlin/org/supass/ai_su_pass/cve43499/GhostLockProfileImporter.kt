package org.supass.ai_su_pass.cve43499

import android.content.Context
import java.io.File
import org.json.JSONObject

/**
 * 从 boot.img / payload.bin / OTA 提取 GhostLock profile。
 *
 * 提取本身在 Rust（`libvrext.so`）里完成；本类只负责线程切换、结果解析与落盘。
 * 解析（[probe]）与落盘（[save]）分开：用户选完落点才写文件。
 */
internal class GhostLockProfileImporter(private val context: Context) {

    /** 解析结果，尚未落盘。 */
    data class Probe(
        val release: String,
        val conf: String,
        val warnings: List<String>,
        /** 实际参与解析的 boot 镜像；供 GhostKey 复用同一份文件。 */
        val bootPath: String,
    )

    /** 解析结果 + 失败原因；`probe` 为 null 表示失败，`reason` 为空串表示成功。 */
    data class ProbeOutcome(val probe: Probe?, val reason: String)

    /** 提取成功后的落点与 release。 */
    data class Imported(val release: String, val fileName: String, val overwritten: Boolean)

    /** 失败原因码；`reason` 为空串表示成功。 */
    data class Outcome(
        val imported: Imported?,
        val reason: String,
        val requiresOverwrite: Boolean = false,
    )

    /**
     * 只解析不落盘。
     *
     * 返回的 [Probe.conf] 由 Dart 侧暂存，用户选定落点后原样回传 [save]。
     */
    fun probe(input: String, insecure: Boolean): ProbeOutcome {
        val trimmed = input.trim()
        if (trimmed.isEmpty()) return ProbeOutcome(null, "emptyInput")

        val json = runCatching {
            GhostLockProfileExtractor.nativeDeriveProfile(
                trimmed,
                context.cacheDir.absolutePath,
                insecure,
            )
        }.getOrElse { return ProbeOutcome(null, it.javaClass.simpleName) }

        val obj = runCatching { JSONObject(json) }
            .getOrElse { return ProbeOutcome(null, "malformedResult") }
        if (!obj.optBoolean("ok", false)) {
            return ProbeOutcome(null, obj.optString("error").ifEmpty { "unknown" })
        }
        val release = obj.optString("release")
        val conf = obj.optString("conf")
        if (release.isEmpty() || conf.isEmpty()) return ProbeOutcome(null, "emptyProfile")

        val warnings = buildList {
            val array = obj.optJSONArray("warnings") ?: return@buildList
            for (index in 0 until array.length()) {
                val item = array.optString(index)
                if (item.isNotEmpty()) add(item)
            }
        }
        val bootPath = obj.optString("bootPath")
        return ProbeOutcome(Probe(release, conf, warnings, bootPath), "")
    }

    /** 把 [probe] 返回的文本落盘；同 release 已存在且未允许覆盖时返回 `alreadyExists`。 */
    fun save(release: String, conf: String, overwrite: Boolean): Outcome {
        if (release.isEmpty() || conf.isEmpty()) return Outcome(null, "emptyProfile")

        val dir = GhostLockProfileStore.directory(context)
        val file = File(dir, GhostLockProfileStore.fileNameFor(release))
        val existed = file.isFile
        if (existed && !overwrite) {
            return Outcome(null, "alreadyExists", requiresOverwrite = true)
        }
        return runCatching {
            dir.mkdirs()
            file.writeText(conf, Charsets.UTF_8)
            Outcome(Imported(release, file.name, existed), "")
        }.getOrElse { Outcome(null, "writeFailed") }
    }

    /** 解析并直接落盘，供不需要选落点的调用方使用。 */
    fun import(input: String, insecure: Boolean, overwrite: Boolean): Outcome {
        val probed = probe(input, insecure)
        val probe = probed.probe ?: return Outcome(null, probed.reason)
        return save(probe.release, probe.conf, overwrite)
    }
}
