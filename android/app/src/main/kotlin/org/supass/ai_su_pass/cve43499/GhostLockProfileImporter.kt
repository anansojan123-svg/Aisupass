package org.supass.ai_su_pass.cve43499

import android.content.Context
import java.io.File
import org.json.JSONObject
import org.supass.ai_su_pass.cve98260.HoconSupport

/**
 * 从 boot.img / payload.bin / OTA 提取 GhostLock profile。
 *
 * 提取本身在 Rust（`libvrext.so`）里完成；本类只负责线程切换、结果解析与落盘。
 * 解析（[probe]）与落盘（[save]）分开：用户选完落点才写文件。
 */
internal class GhostLockProfileImporter(private val context: Context) {

    /** 导入时解析 include 需要查内置表。 */
    private val assets = GhostLockAssets(context)

    /** 解析结果，尚未落盘。 */
    data class Probe(
        val release: String,
        val conf: String,
        val warnings: List<String>,
        /** 实际参与解析的 boot 镜像；供 GhostKey 复用同一份文件。 */
        val bootPath: String,
        /** `kernel_phys_load`；空串表示未取到。 */
        val kernelPhysLoad: String,
        /** `kernel_phys_offset`；空串表示未取到。 */
        val kernelPhysOffset: String,
        /** `kernel_phys_load` 的来源；空串表示未取到。 */
        val physSource: String,
        /** 内核审查报告；早期失败时为空串。 */
        val analysis: String,
    )

    /** 解析结果 + 失败原因；`probe` 为 null 表示失败，`reason` 为空串表示成功。 */
    data class ProbeOutcome(
        val probe: Probe?,
        val reason: String,
        /** 失败时的审查报告，供 UI 分诊；成功时为空串。 */
        val analysis: String = "",
    )

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
     * [xblPath] / [uefiPath] / [vendorBootPath] 是可选的附加镜像，用于补齐
     * `kernel_phys_load`；[phys] 是用户手填的物理装载基址。
     * [kallsymsPath] / [iomemPath] 是外部文本文件，空串表示自动；[route]
     * 强制路由，空串表示自动推荐。
     */
    fun probe(
        input: String,
        insecure: Boolean,
        xblPath: String = "",
        uefiPath: String = "",
        vendorBootPath: String = "",
        phys: String = "",
        kallsymsPath: String = "",
        iomemPath: String = "",
        route: String = "",
        allowMissing: Boolean = false,
        noDisasm: Boolean = false,
    ): ProbeOutcome {
        val trimmed = input.trim()
        if (trimmed.isEmpty()) return ProbeOutcome(null, "emptyInput")

        val json = runCatching {
            GhostLockProfileExtractor.nativeDeriveProfile(
                trimmed,
                context.cacheDir.absolutePath,
                insecure,
                xblPath.trim(),
                uefiPath.trim(),
                vendorBootPath.trim(),
                phys.trim(),
                kallsymsPath.trim(),
                iomemPath.trim(),
                route.trim(),
                allowMissing,
                noDisasm,
            )
        }.getOrElse { return ProbeOutcome(null, it.javaClass.simpleName) }

        val obj = runCatching { JSONObject(json) }
            .getOrElse { return ProbeOutcome(null, "malformedResult") }
        val analysis = obj.optString("analysis")
        if (!obj.optBoolean("ok", false)) {
            return ProbeOutcome(null, obj.optString("error").ifEmpty { "unknown" }, analysis)
        }
        val release = obj.optString("release")
        val conf = obj.optString("conf")
        if (release.isEmpty() || conf.isEmpty()) return ProbeOutcome(null, "emptyProfile", analysis)

        val warnings = buildList {
            val array = obj.optJSONArray("warnings") ?: return@buildList
            for (index in 0 until array.length()) {
                val item = array.optString(index)
                if (item.isNotEmpty()) add(item)
            }
        }
        val bootPath = obj.optString("bootPath")
        return ProbeOutcome(
            Probe(
                release = release,
                conf = conf,
                warnings = warnings,
                bootPath = bootPath,
                kernelPhysLoad = obj.optString("kernelPhysLoad"),
                kernelPhysOffset = obj.optString("kernelPhysOffset"),
                physSource = obj.optString("physSource"),
                analysis = analysis,
            ),
            "",
            "",
        )
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

    /**
     * 导入现成的 profile 文本（HOCON 或 JSON），原样落盘。
     *
     * 取不到 `release` 时按 include 依赖处理：文件名必填，原样保存，
     * 返回的 release 为空串。这样多选导入时依赖文档能落盘，主文档的
     * `include` 才有东西可展开。
     */
    fun importText(text: String, fileName: String, overwrite: Boolean): Outcome {
        if (text.isBlank()) return Outcome(null, "emptyProfile")
        if (text.length > MaxProfileChars) return Outcome(null, "profileTooLarge")
        /* 落盘即可能参与解析，先确认是合法 HOCON/JSON 对象。 */
        if (!parses(text)) return Outcome(null, "invalidProfile")
        val store = GhostLockProfileStore(GhostLockProfileStore.directory(context))
        val release = releaseOf(text)
        if (release == null) {
            /* 依赖文档本身也可能没有 release，按显式文件名原样保存。 */
            if (fileName.isBlank()) return Outcome(null, "invalidProfile")
            val dependency = fileName.trim().let {
                if (it.endsWith(".conf")) it else "$it.conf"
            }
            if (!overwrite && store.rawText(dependency) != null) {
                return Outcome(null, "alreadyExists", requiresOverwrite = true)
            }
            if (!store.save(dependency, text)) return Outcome(null, "writeFailed")
            return Outcome(Imported("", dependency, overwrite), "")
        }
        val target = fileName.trim().ifEmpty {
            GhostLockProfileStore.fileNameFor(release)
        }.let { if (it.endsWith(".conf")) it else "$it.conf" }
        if (!overwrite && store.rawText(target) != null) {
            return Outcome(null, "alreadyExists", requiresOverwrite = true)
        }
        if (!store.save(target, text)) return Outcome(null, "writeFailed")
        return Outcome(Imported(release, target, overwrite), "")
    }

    /** 从 HOCON 或 JSON 文本取 `release`；支持 `profiles: [...]` 多文档。 */
    private fun releaseOf(text: String): String? {
        val parsed = runCatching {
            HoconSupport.parseValue(text) { path -> builtinInclude(path) }
        }.getOrNull()
        releaseFrom(parsed)?.let { return it }
        return Regex("(?m)\"?release\"?\\s*[:=]\\s*\"([^\"]+)\"")
            .find(text)?.groupValues?.getOrNull(1)?.takeIf { it.isNotEmpty() }
    }

    /**
     * 语法校验：`include` 能查内置表就查，查不到按空片段处理。
     *
     * 依赖文档可能引入尚未落盘的其它依赖，这里只判断是否为合法 HOCON 片段；
     * 真正的缺失会在解析主文档时报给用户。
     */
    private fun parses(text: String): Boolean =
        runCatching { HoconSupport.parseObject(text) { path -> builtinInclude(path) } }.isSuccess ||
            runCatching { HoconSupport.parseObject(text) { "" } }.isSuccess

    private fun builtinInclude(path: String): String? =
        assets.load("$BUILTIN_DIR/$path").takeIf { it.isNotBlank() }
            ?: assets.load("$BUILTIN_DIR/${path.substringAfterLast('/')}").takeIf { it.isNotBlank() }

    private fun releaseFrom(value: Any?): String? = when (value) {
        is Map<*, *> -> {
            (value["release"] as? String)?.takeIf { it.isNotEmpty() }
                ?: (value["profiles"] as? List<*>)
                    ?.firstNotNullOfOrNull { releaseFrom(it) }
        }

        is List<*> -> value.firstNotNullOfOrNull { releaseFrom(it) }
        else -> null
    }

    private companion object {
        const val BUILTIN_DIR = "kernel_profiles/ghostlock"

        /** 与 UI 侧导入上限一致：4 MiB 文本。 */
        const val MaxProfileChars = 4 shl 20
    }
}
