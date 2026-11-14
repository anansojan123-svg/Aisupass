package org.supass.ai_su_pass.cve98260

/**
 * 纯 Kotlin HOCON 子集解析器 / 序列化器（无外部依赖）。
 *
 * 支持：
 *  - `#` 与 `//` 行注释（字符串内不生效）
 *  - 键值对：`key = value` / `key: value` / `key value`（空格分隔）
 *  - 嵌套对象：`key { ... }` / `key = { ... }`
 *  - 点分路径赋值：`a.b.c = 1` → { a: { b: { c: 1 } } }
 *  - 数组：`[ 1, 2, 3 ]`（支持尾逗号）
 *  - 字符串：双引号（支持 `\" \\ \n \t \r` 转义）与无引号裸串
 *  - 数值：十进制 / 十六进制（`0x`/`0X`，支持无符号 64 位）、浮点
 *  - 布尔：`true` / `false`，空值：`null`
 *  - `include "rel/file"`（通过可选 includer 回调解析，默认忽略并告警）
 *
 * 不支持（本工具用不到）：多行字符串、变量替换 `${...}`、类型注解、+= 等。
 */
object HoconSupport {

    /** 解析文本为嵌套 Map/List/标量结构。解析失败抛 [HoconParseException]。 */
    fun parseValue(text: String, includer: ((String) -> String?)? = null): Any? {
        val p = Parser(text, includer)
        val v = p.parseDocument()
        return v
    }

    /** 解析为顶层对象（Map）。若顶层不是对象则抛异常。 */
    fun parseObject(text: String, includer: ((String) -> String?)? = null): Map<String, Any?> {
        val v = parseValue(text, includer)
        @Suppress("UNCHECKED_CAST")
        return v as? Map<String, Any?> ?: throw HoconParseException("顶层必须是对象")
    }

    /** 反向序列化：将嵌套结构渲染为合法 HOCON 文本。 */
    fun render(value: Any?, indent: Int = 0): String {
        val sb = StringBuilder()
        renderValue(value, sb, indent)
        return sb.toString()
    }

    // ---------------------------------------------------------------- 解析

    class HoconParseException(message: String) : RuntimeException(message)

    private class Parser(
        private val src: String,
        private val includer: ((String) -> String?)?,
    ) {
        private var i = 0
        private val n = src.length

        fun parseDocument(): Any? {
            skipWsAndComments()
            // 顶层若是显式 { } 或 [ ]，直接作为对象/数组解析
            if (i < n && (src[i] == '{' || src[i] == '[')) {
                val v = parseValue(false)
                skipWsAndComments()
                if (i < n) throw HoconParseException("解析后存在多余字符 @$i")
                return v
            }
            // 否则顶层是隐式对象（无花括号包裹的字段序列）
            val map = LinkedHashMap<String, Any?>()
            while (i < n) {
                skipWsAndComments()
                if (i >= n) break
                if (src[i] == '}') { i++; break }
                if (src[i] == ',') { i++; continue } // 顶层逗号分隔
                val includedTop = tryParseInclude()
                if (includedTop != null) {
                    mergeMap(map, includedTop)
                    continue
                }
                val pair = parseKey()
                val key = pair.first ?: continue
                val hasEq = pair.second
                skipWsAndComments()
                val isNested = i < n && src[i] == '{'
                val value: Any? = if (isNested) {
                    parseObjectBody()
                } else if (hasEq) {
                    parseValue(true)
                } else {
                    throw HoconParseException("字段 '$key' 缺少值或 '{' @$i")
                }
                assignPath(map, key, value, pair.third)
            }
            skipWsAndComments()
            return map
        }

        /** 解析一个值；inField 表示当前处于对象内部（遇到 `}` 应结束对象）。 */
        private fun parseValue(inField: Boolean): Any? {
            skipWsAndComments()
            if (i >= n) return null
            val c = src[i]
            return when {
                c == '{' -> parseObjectBody()
                c == '[' -> parseArray()
                c == '"' -> parseQuotedString()
                c == '}' && inField -> null
                else -> parseUnquotedOrLiteral()
            }
        }

        private fun parseObjectBody(): Map<String, Any?> {
            // src[i] == '{'
            i++ // consume {
            val map = LinkedHashMap<String, Any?>()
            while (true) {
                skipWsAndComments()
                if (i >= n) throw HoconParseException("对象未闭合")
                if (src[i] == '}') { i++; break }
                if (src[i] == ',') { i++; continue } // JSON/HOCON 字段间可选逗号
                val includedNested = tryParseInclude()
                if (includedNested != null) {
                    mergeMap(map, includedNested)
                    continue
                }
                val (key, hasEq, quoted) = parseKey()
                // 解析不出键（例如刚消费掉的 include 指令残留）→ 跳过，避免 assignPath 收到 null
                if (key == null) continue
                skipWsAndComments()
                // 判断是 "key { ... }" 还是 "key = value"
                val isNested = (i < n && src[i] == '{')
                val value: Any? = if (isNested) {
                    parseObjectBody()
                } else {
                    if (hasEq) {
                        skipWsAndComments()
                        parseValue(true)
                    } else {
                        // 裸 key 后既无 = 也无 { ：视为缺值
                        throw HoconParseException("字段 '$key' 缺少值或 '{' @$i")
                    }
                }
                assignPath(map, key, value, quoted)
            }
            return map
        }

        private fun parseArray(): List<Any?> {
            i++ // consume [
            val list = ArrayList<Any?>()
            while (true) {
                skipWsAndComments()
                if (i >= n) throw HoconParseException("数组未闭合")
                if (src[i] == ']') { i++; break }
                list.add(parseValue(false))
                skipWsAndComments()
                if (i < n && src[i] == ',') { i++; continue }
                if (i < n && src[i] == ']') { i++; break }
                // 允许换行分隔
            }
            return list
        }

        /**
         * 若当前位置是 `include "path"` 指令，消费它并返回被包含文件解析出的对象。
         * - 未提供 [includer] 却遇到 include：抛 [HoconParseException]（不再静默丢弃配置，R5 修复）。
         * - 提供了 [includer]：调用其取回内容，递归解析为对象后返回，由调用方合并进当前对象。
         * 返回 null 表示当前位置不是 include 指令。
         */
        private fun tryParseInclude(): Map<String, Any?>? {
            if (!src.startsWith("include", i)) return null
            var j = i + "include".length
            // 必须是 "include" + 至少一个空白 + 引号，才是 include 指令；
            // 否则（如 include_foo / include = 1 / include 后非引号）只是普通键，交回 parseKey。
            if (j >= n || (src[j] != ' ' && src[j] != '\t')) return null
            while (j < n && (src[j] == ' ' || src[j] == '\t')) j++
            if (j >= n || src[j] != '"') return null
            val (incPath, ni) = parseQuotedStringAt(j)
            i = ni
            skipWsAndComments()
            if (i < n && src[i] == ';') i++ // 允许尾随分号
            val text = includer?.invoke(incPath)
                ?: throw HoconParseException(
                    "遇到 include \"$incPath\" 但未提供 includer 回调，无法解析被包含文件（配置会被静默丢弃，已拒绝）")
            // parseObject 返回非空 Map（顶层非对象时内部已抛异常），无需再判空。
            return HoconSupport.parseObject(text, includer)
        }

        /** 将 [source] 深度合并进 [target]（嵌套对象递归合并，标量/列表覆盖）。 */
        private fun mergeMap(target: MutableMap<String, Any?>, source: Map<String, Any?>) {
            for ((k, v) in source) {
                val existing = target[k]
                if (existing is MutableMap<*, *> && v is Map<*, *>) {
                    @Suppress("UNCHECKED_CAST")
                    mergeMap(existing as MutableMap<String, Any?>, v as Map<String, Any?>)
                } else {
                    target[k] = v
                }
            }
        }

        /** 解析键：支持裸串 / 引号串。返回 (key, hasSeparator, isQuoted)。 */
        private fun parseKey(): Triple<String?, Boolean, Boolean> {
            skipWsAndComments()
            if (i >= n) return Triple(null, false, false)
            // include 指令在对象解析循环层统一处理（见 tryParseInclude），此处不再处理。
            val key: String
            val hasSep: Boolean
            val quoted: Boolean
            val c = src[i]
            when {
                c == '"' -> {
                    val (s, ni) = parseQuotedStringAt(i)
                    key = s
                    i = ni
                    quoted = true
                }
                else -> {
                    key = readUnquotedKey()
                    quoted = false
                }
            }
            // 分隔符：= 或 : （可选，后面跟值）；也可能直接接 {
            skipWsAndComments()
            hasSep = if (i < n && (src[i] == '=' || src[i] == ':')) {
                i++
                // 允许 =: 连写（HOCON 允许 := 与 = 相同，这里只认一个）
                skipWsAndComments()
                true
            } else {
                false
            }
            return Triple(key, hasSep, quoted)
        }

        private fun readUnquotedKey(): String {
            val start = i
            while (i < n) {
                val c = src[i]
                if (c == ' ' || c == '\t' || c == '\n' || c == '\r' ||
                    c == '=' || c == ':' || c == '{' || c == '}' ||
                    c == '[' || c == ']' || c == ',' || c == '#' ||
                    c == '"' || c == 0.toChar()
                ) break
                i++
            }
            return src.substring(start, i).trim()
        }

        private fun parseUnquotedOrLiteral(): Any? {
            val start = i
            while (i < n) {
                val c = src[i]
                if (c == ' ' || c == '\t' || c == '\n' || c == '\r' ||
                    c == '#' || c == ',' || c == '}' || c == ']' ||
                    c == '"' || c == 0.toChar()
                ) break
                i++
            }
            val raw = src.substring(start, i).trim()
            if (raw.isEmpty()) throw HoconParseException("空字面量 @$start")
            return coerceLiteral(raw)
        }

        private fun coerceLiteral(raw: String): Any? = when (raw) {
            "true" -> true
            "false" -> false
            "null" -> null
            else -> {
                // 数值
                if (raw.startsWith("0x", ignoreCase = true) || raw.startsWith("0X")) {
                    try {
                        java.lang.Long.parseUnsignedLong(raw.removePrefix("0x").removePrefix("0X"), 16)
                    } catch (_: NumberFormatException) {
                        raw
                    }
                } else if (raw.any { it == '.' || it == 'e' || it == 'E' }) {
                    raw.toDoubleOrNull() ?: raw
                } else {
                    // 十进制整数：可能溢出 Long（极少见），回退 unsigned
                    raw.toLongOrNull()
                        ?: runCatching { java.lang.Long.parseUnsignedLong(raw) }.getOrElse { raw }
                }
            }
        }

        private fun parseQuotedString(): String {
            val (s, ni) = parseQuotedStringAt(i)
            i = ni
            return s
        }

        /** 在位置 at（必须为 '"'）解析引号字符串，返回 (内容, 新位置)。 */
        private fun parseQuotedStringAt(at: Int): Pair<String, Int> {
            require(src[at] == '"')
            i = at + 1
            val sb = StringBuilder()
            while (i < n) {
                val c = src[i]
                when {
                    c == '\\' -> {
                        i++
                        if (i >= n) break
                        val e = src[i]
                        when (e) {
                            '"' -> sb.append('"')
                            '\\' -> sb.append('\\')
                            '/' -> sb.append('/')
                            'n' -> sb.append('\n')
                            't' -> sb.append('\t')
                            'r' -> sb.append('\r')
                            'b' -> sb.append('\b')
                            'f' -> sb.append('\u000C')
                            else -> sb.append(e)
                        }
                        i++
                    }
                    c == '"' -> { i++; return sb.toString() to i }
                    else -> { sb.append(c); i++ }
                }
            }
            throw HoconParseException("引号字符串未闭合 @$at")
        }

        /**
         * 将 key 按路径赋值到 map。
         *
         * [quoted] 为真时 key 是字面量，不做点分路径展开（HOCON 规范）。
         */
        private fun assignPath(
            map: MutableMap<String, Any?>,
            key: String,
            value: Any?,
            quoted: Boolean = false,
        ) {
            if (quoted) {
                map[key] = value
                return
            }
            val parts = key.split('.')
            var cur: MutableMap<String, Any?> = map
            for (k in 0 until parts.size - 1) {
                val seg = parts[k]
                val existing = cur[seg]
                val next = if (existing is MutableMap<*, *>) {
                    @Suppress("UNCHECKED_CAST")
                    existing as MutableMap<String, Any?>
                } else {
                    val m = LinkedHashMap<String, Any?>()
                    cur[seg] = m
                    m
                }
                cur = next
            }
            cur[parts.last()] = value
        }

        // ---------------------------------------------------------------- 注释 / 空白

        private fun skipWsAndComments() {
            while (i < n) {
                val c = src[i]
                when {
                    c == ' ' || c == '\t' || c == '\n' || c == '\r' || c == 0.toChar() -> i++
                    c == '#' -> { while (i < n && src[i] != '\n') i++; }
                    c == '/' && i + 1 < n && src[i + 1] == '/' -> { while (i < n && src[i] != '\n') i++; }
                    c == '/' && i + 1 < n && src[i + 1] == '*' -> {
                        i += 2
                        while (i + 1 < n && !(src[i] == '*' && src[i + 1] == '/')) i++
                        if (i + 1 < n) i += 2
                    }
                    else -> break
                }
            }
        }
    }

    // ---------------------------------------------------------------- 渲染

    private fun renderValue(value: Any?, sb: StringBuilder, indent: Int) {
        when (value) {
            null -> sb.append("null")
            is Map<*, *> -> renderObject(value, sb, indent)
            is List<*> -> renderArray(value, sb, indent)
            is String -> sb.append('"').append(value.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("\n", "\\n").replace("\t", "\\t")).append('"')
            is Boolean, is Long, is Int, is Double, is Float -> sb.append(value)
            else -> sb.append('"').append(value.toString()).append('"')
        }
    }

    private fun renderObject(map: Map<*, *>, sb: StringBuilder, indent: Int) {
        sb.append("{\n")
        val pad = "  ".repeat(indent + 1)
        for ((k, v) in map) {
            val key = k.toString()
            sb.append(pad)
            // 裸 key 里的 `.` 是路径分隔符，必须加引号才能作为字面量读回。
            if (key.contains(' ') || key.contains('"') || key.contains('.')) {
                sb.append('"').append(key).append('"')
            } else {
                sb.append(key)
            }
            sb.append(" = ")
            renderValue(v, sb, indent + 1)
            sb.append("\n")
        }
        sb.append("  ".repeat(indent)).append("}")
    }

    private fun renderArray(list: List<*>, sb: StringBuilder, indent: Int) {
        sb.append("[ ")
        list.forEachIndexed { idx, v ->
            renderValue(v, sb, indent)
            if (idx < list.size - 1) sb.append(", ")
        }
        sb.append(" ]")
    }
}
