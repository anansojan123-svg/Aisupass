package org.supass.ai_su_pass.core.bridge.cve98260_native

import android.content.Context
import android.os.Handler
import android.os.Looper
import org.supass.ai_su_pass.data.runlog.RunLogStore
import java.io.File
import java.util.concurrent.Executors
import java.util.concurrent.atomic.AtomicReference

/**
 * Bridge for run logs and failure attribution.
 *
 * All work runs on one dedicated thread: file IO never touches the platform
 * thread, and per-run writes stay ordered. Every entry point is wrapped in
 * runCatching, nothing is thrown across the channel.
 */
class Cve98260RunLogNativeImpl(context: Context) : Cve98260RunLogNative {

    private val store = RunLogStore(File(context.filesDir, RunLogStore.DIR))
    private val executor = Executors.newSingleThreadExecutor()
    private val mainHandler = Handler(Looper.getMainLooper())

    /** The session currently being written, keyed by file name. */
    private val activeSession = AtomicReference<RunLogStore.Session?>(null)

    override fun beginRun(
        request: RunLogBeginRequest,
        callback: (Result<RunLogMetaDto>) -> Unit,
    ) {
        runAsync(callback) {
            // A previous run that never finished must not stay RUNNING forever.
            activeSession.getAndSet(null)?.finish(RunLogStore.RunResult.INTERRUPTED, null, 0L)
            val session = store.begin(request.device, request.kernel, request.profile)
            activeSession.set(session)
            RunLogMetaDto(
                fileName = session.file.name,
                runId = session.runId.toLong(),
                startedAt = session.startedAt,
                result = RunLogStore.RunResult.RUNNING.name,
                exitCode = null,
                durationMs = 0L,
                lineCount = 0L,
                device = request.device,
                kernel = request.kernel,
                profile = request.profile,
            )
        }
    }

    override fun appendLines(
        fileName: String,
        lines: List<String>,
        callback: (Result<Unit>) -> Unit,
    ) {
        runAsync(callback) {
            val session = activeSession.get()
            if (session != null && session.file.name == fileName) {
                session.appendLines(lines)
            }
        }
    }

    override fun finishRun(request: RunLogFinishRequest, callback: (Result<Unit>) -> Unit) {
        runAsync(callback) {
            val session = activeSession.get()
            if (session != null && session.file.name == request.fileName) {
                val result = RunLogStore.RunResult.values()
                    .firstOrNull { it.name == request.result }
                    ?: RunLogStore.RunResult.INTERRUPTED
                session.finish(result, request.exitCode?.toInt(), request.durationMs)
                activeSession.compareAndSet(session, null)
            }
        }
    }

    override fun listRuns(callback: (Result<List<RunLogMetaDto>>) -> Unit) {
        runAsync(callback) {
            store.listRuns().map { meta ->
                RunLogMetaDto(
                    fileName = meta.file.name,
                    runId = meta.runId.toLong(),
                    startedAt = meta.startedAt,
                    result = meta.result.name,
                    exitCode = meta.exitCode?.toLong(),
                    durationMs = meta.durationMs,
                    lineCount = (meta.lineCount ?: -1).toLong(),
                    device = meta.device,
                    kernel = meta.kernel,
                    profile = meta.profile,
                )
            }
        }
    }

    override fun readBody(fileName: String, callback: (Result<List<String>>) -> Unit) {
        runAsync(callback) { store.readBody(fileName) }
    }

    override fun exportAllText(callback: (Result<String>) -> Unit) {
        runAsync(callback) { store.exportAllText() }
    }

    override fun deleteRun(fileName: String, callback: (Result<Unit>) -> Unit) {
        runAsync(callback) { store.delete(fileName) }
    }

    override fun clearRuns(callback: (Result<Unit>) -> Unit) {
        runAsync(callback) { store.clear() }
    }

    override fun diagnose(
        request: RunLogDiagnoseRequest,
        callback: (Result<RunLogDiagnosisDto>) -> Unit,
    ) {
        runAsync(callback) {
            val diagnosis = FailureDiagnoser.diagnose(request.lines)
                ?: FailureDiagnoser.fallback(request.exitCode.toInt())
            RunLogDiagnosisDto(
                ruleId = diagnosis.ruleId,
                stage = diagnosis.stage,
                evidence = diagnosis.evidence,
            )
        }
    }

    fun dispose() {
        runCatching { activeSession.getAndSet(null)?.finish(RunLogStore.RunResult.INTERRUPTED, null, 0L) }
        runCatching { executor.shutdownNow() }
    }

    private fun <T> runAsync(callback: (Result<T>) -> Unit, block: () -> T) {
        executor.execute {
            val result = runCatching(block)
            mainHandler.post { callback(result) }
        }
    }
}
