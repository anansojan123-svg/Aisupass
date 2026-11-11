package org.supass.ai_su_pass.data.runlog

import java.io.File
import java.io.RandomAccessFile
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * Run log file store, ported from upstream data/RunLogStore.kt.
 *
 * Format (kept verbatim):
 *
 *   # run=12
 *   # start_ms=1730000000000
 *   # device=...
 *   # kernel=...
 *   # profile=...
 *   === log ===
 *   [12:00:01] ...
 *   ...
 *   === end ===
 *   # result=SUCCESS
 *   # exit=0
 *   # end_ms=...
 *   # duration_ms=...
 *   # lines=42
 *
 * The head gives the meta of a fresh run; the tail gives the outcome. Reading
 * only 8 head lines + the last 4 KiB keeps listRuns() cheap with many files.
 */
class RunLogStore(private val dir: File) {

    enum class RunResult { RUNNING, SUCCESS, FAILED, STOPPED, INTERRUPTED }

    data class RunLogMeta(
        val file: File,
        val runId: Int,
        val startedAt: Long,
        val result: RunResult,
        val exitCode: Int?,
        val durationMs: Long,
        val lineCount: Int?,
        val device: String,
        val kernel: String,
        val profile: String,
    )

    private val active = HashSet<String>()

    @Synchronized
    fun begin(device: String, kernel: String, profile: String): Session {
        dir.mkdirs()
        val runId = nextRunId()
        val stamp = STAMP.format(Date())
        val base = "run-$stamp-" + runId.toString().padStart(4, '0')
        var name = "$base$EXT"
        var dup = 1
        while (File(dir, name).exists()) {
            name = "$base-$dup$EXT"
            dup++
        }
        val file = File(dir, name)
        active.add(file.name)
        val session = Session(file, runId, System.currentTimeMillis())
        session.writeHeader(device, kernel, profile)
        prune()
        return session
    }

    @Synchronized
    fun listRuns(): List<RunLogMeta> =
        (dir.listFiles { f -> f.isFile && f.name.endsWith(EXT) } ?: emptyArray())
            .map { parseMeta(it) }
            .sortedByDescending { it.startedAt }

    @Synchronized
    fun nextRunId(): Int = (listRuns().maxOfOrNull { it.runId } ?: 0) + 1

    @Synchronized
    fun readBody(fileName: String): List<String> {
        val file = File(dir, fileName)
        if (!file.isFile) return emptyList()
        val out = ArrayList<String>()
        var inside = false
        file.useLines { seq ->
            for (raw in seq) {
                val line = raw.trimEnd('\r')
                if (!inside) {
                    if (line == BODY_BEGIN) inside = true
                } else {
                    if (line == BODY_END) break
                    out.add(line)
                }
            }
        }
        return out
    }

    /** ASCII headers only, so the exported bundle stays readable without l10n. */
    @Synchronized
    fun textOf(meta: RunLogMeta): String = buildString {
        append("# run=").append(meta.runId).append('\n')
        append("# start=").append(FULL.format(Date(meta.startedAt))).append('\n')
        append("# device=").append(sanitize(meta.device)).append('\n')
        append("# kernel=").append(sanitize(meta.kernel)).append('\n')
        append("# profile=").append(sanitize(meta.profile)).append('\n')
        append("# result=").append(meta.result.name)
        if (meta.exitCode != null) append(" (exit=").append(meta.exitCode).append(')')
        append('\n')
        append("# duration_ms=").append(meta.durationMs)
        if (meta.lineCount != null) append(" lines=").append(meta.lineCount)
        append('\n').append('\n')
        readBody(meta.file.name).forEach { append(it).append('\n') }
    }.trimEnd()

    @Synchronized
    fun exportAllText(): String = listRuns()
        .sortedBy { it.startedAt }
        .joinToString(("\n\n" + "=".repeat(48) + "\n\n")) { textOf(it) }
        .trimEnd()

    @Synchronized
    fun delete(fileName: String) {
        val file = File(dir, fileName)
        if (active.contains(file.name)) return
        if (file.isFile) file.delete()
    }

    @Synchronized
    fun clear() {
        (dir.listFiles { f -> f.isFile && f.name.endsWith(EXT) } ?: emptyArray())
            .filterNot { active.contains(it.name) }
            .forEach { it.delete() }
    }

    @Synchronized
    fun prune() {
        listRuns()
            .sortedBy { it.file.lastModified() }
            .dropLast(MAX_RUNS)
            .filterNot { active.contains(it.file.name) }
            .forEach { it.file.delete() }
    }

    private fun parseMeta(file: File): RunLogMeta {
        val head = readHeadLines(file, HEAD_LINES)
        val tail = readTailLines(file, TAIL_LINES)

        fun valueOf(lines: List<String>, key: String): String? =
            lines.firstOrNull { it.startsWith(key) }
                ?.substring(key.length)
                ?.let { sanitize(it) }

        var runId = valueOf(head, K_RUN)?.toIntOrNull() ?: 0
        if (runId <= 0) {
            runId = NAME_ID.find(file.name)?.groupValues?.get(1)?.toIntOrNull() ?: 0
        }
        var startedAt = valueOf(head, K_START)?.toLongOrNull() ?: 0L
        if (startedAt <= 0L) startedAt = file.lastModified()

        val result = if (active.contains(file.name)) {
            RunResult.RUNNING
        } else {
            val raw = valueOf(tail, K_RESULT)
            if (raw == null) RunResult.INTERRUPTED
            else RunResult.values().firstOrNull { it.name == raw } ?: RunResult.INTERRUPTED
        }

        return RunLogMeta(
            file = file,
            runId = runId,
            startedAt = startedAt,
            result = result,
            exitCode = valueOf(tail, K_EXIT)?.toIntOrNull(),
            durationMs = valueOf(tail, K_DURATION)?.toLongOrNull() ?: 0L,
            lineCount = valueOf(tail, K_LINES)?.toIntOrNull(),
            device = valueOf(head, K_DEVICE) ?: "",
            kernel = valueOf(head, K_KERNEL) ?: "",
            profile = valueOf(head, K_PROFILE) ?: "",
        )
    }

    /** Reads the first [maxLines] lines byte by byte, dropping CR. */
    private fun readHeadLines(file: File, maxLines: Int): List<String> {
        val out = ArrayList<String>(maxLines)
        RandomAccessFile(file, "r").use { raf ->
            val sb = StringBuilder()
            var read = raf.read()
            while (read != -1 && out.size < maxLines) {
                val c = read.toChar()
                when (c) {
                    '\n' -> { out.add(sb.toString()); sb.setLength(0) }
                    '\r' -> Unit
                    else -> sb.append(c)
                }
                read = raf.read()
            }
        }
        return out
    }

    /** Reads the last [maxLines] lines from the final 4 KiB window. */
    private fun readTailLines(file: File, maxLines: Int): List<String> {
        RandomAccessFile(file, "r").use { raf ->
            val length = raf.length()
            val window = if (length > TAIL_BYTES) TAIL_BYTES else length
            if (window <= 0L) return emptyList()
            val buf = ByteArray(window.toInt())
            raf.seek(length - window)
            raf.readFully(buf)
            val text = String(buf, Charsets.UTF_8)
            val lines = text.split('\n').map { it.trimEnd('\r') }
            // The window may start mid-line, drop that half line first.
            return lines.drop(1).takeLast(maxLines)
        }
    }

    inner class Session internal constructor(
        val file: File,
        val runId: Int,
        val startedAt: Long,
    ) {
        private var writer: java.io.BufferedWriter? = file.bufferedWriter()
        private var finished = false

        var lineCount = 0
            private set

        internal fun writeHeader(device: String, kernel: String, profile: String) {
            write("$K_RUN$runId")
            write("$K_START$startedAt")
            write("$K_DEVICE${sanitize(device)}")
            write("$K_KERNEL${sanitize(kernel)}")
            write("$K_PROFILE${sanitize(profile)}")
            write(BODY_BEGIN)
        }

        @Synchronized
        fun append(message: String) {
            if (finished) return
            write("[" + HMS.format(Date()) + "] " + message.replace('\r', ' '))
            lineCount++
        }

        @Synchronized
        fun appendLines(lines: List<String>) {
            lines.forEach { append(it) }
        }

        @Synchronized
        fun finish(result: RunResult, exitCode: Int?, durationMs: Long) {
            if (finished) return
            write(BODY_END)
            write("$K_RESULT${result.name}")
            if (exitCode != null) write("$K_EXIT$exitCode")
            write("$K_END_MS" + System.currentTimeMillis())
            write("$K_DURATION$durationMs")
            write("$K_LINES$lineCount")
            runCatching { writer?.flush() }
            runCatching { writer?.close() }
            writer = null
            finished = true
            active.remove(file.name)
        }

        private fun write(line: String) {
            val w = writer ?: return
            w.write(line)
            w.newLine()
            w.flush()
        }
    }

    private fun sanitize(value: String): String =
        value.replace('\n', ' ').replace('\r', ' ').trim()

    companion object {
        const val DIR = "run_logs"
        const val EXT = ".log"
        const val BODY_BEGIN = "=== log ==="
        const val BODY_END = "=== end ==="
        const val K_RUN = "# run="
        const val K_START = "# start_ms="
        const val K_DEVICE = "# device="
        const val K_KERNEL = "# kernel="
        const val K_PROFILE = "# profile="
        const val K_RESULT = "# result="
        const val K_EXIT = "# exit="
        const val K_END_MS = "# end_ms="
        const val K_DURATION = "# duration_ms="
        const val K_LINES = "# lines="
        const val TAIL_BYTES = 4096L
        const val HEAD_LINES = 8
        const val TAIL_LINES = 6
        const val MAX_RUNS = 20

        private val STAMP = SimpleDateFormat("yyyyMMdd-HHmmss", Locale.US)
        private val HMS = SimpleDateFormat("HH:mm:ss", Locale.getDefault())
        private val FULL = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault())
        private val NAME_ID = Regex("-([0-9]{4,})(?:-[0-9]+)?\\.log$")
    }
}
