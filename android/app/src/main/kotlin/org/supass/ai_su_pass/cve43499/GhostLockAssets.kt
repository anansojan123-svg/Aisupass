package org.supass.ai_su_pass.cve43499

import android.content.Context

/**
 * 从 assets 读取配置文本，并展开 HOCON 风格的 `include "file.conf"`。
 *
 * 展开相对于包含方所在目录、支持嵌套、按访问集合防环。展开后的文本
 * 交给 [org.supass.ai_su_pass.cve98260.HoconSupport] 解析。
 */
internal class GhostLockAssets(private val context: Context) {

    fun load(relativePath: String): String = expand(relativePath, linkedSetOf())

    private fun expand(relativePath: String, visiting: MutableSet<String>): String {
        if (!visiting.add(relativePath)) return ""
        val text = runCatching {
            context.assets.open(relativePath).bufferedReader().use { it.readText() }
        }.getOrElse {
            visiting.remove(relativePath)
            return ""
        }
        val baseDir = relativePath.substringBeforeLast('/', "")
        val expanded = StringBuilder()
        for (line in text.lineSequence()) {
            val trimmed = line.trim()
            val target = when {
                trimmed.startsWith("#") || trimmed.startsWith("//") -> null
                trimmed.startsWith("include ") ->
                    trimmed.removePrefix("include ").trim()
                        .trim('"')
                        .takeIf { it.isNotEmpty() }

                else -> null
            }
            if (target == null) {
                expanded.append(line).append('\n')
            } else {
                val resolved = if (baseDir.isEmpty()) target else "$baseDir/$target"
                expanded.append(expand(resolved, visiting)).append('\n')
            }
        }
        visiting.remove(relativePath)
        return expanded.toString()
    }
}
