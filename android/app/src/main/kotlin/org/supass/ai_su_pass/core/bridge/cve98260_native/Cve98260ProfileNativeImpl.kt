package org.supass.ai_su_pass.core.bridge.cve98260_native

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import java.io.File
import java.io.FileInputStream
import java.io.IOException
import java.net.URI
import java.util.concurrent.Executors
import org.supass.ai_su_pass.cve98260.AssetConfigLoader
import org.supass.ai_su_pass.cve98260.BuiltinProfileCatalog
import org.supass.ai_su_pass.cve98260.ProfileConversionException
import org.supass.ai_su_pass.cve98260.ota.BootImageParser
import org.supass.ai_su_pass.cve98260.ota.ImgToProfile
import org.supass.ai_su_pass.cve98260.ota.ImportedProfileStore
import org.supass.ai_su_pass.cve98260.ota.OtaPayloadExtractor

/**
 * Bridge for imported user profiles: parameter validation, thread dispatch and
 * result shipping only.
 *
 * Parsing, synthesis and persistence are delegated to the `cve98260.ota`
 * helpers and [ImportedProfileStore]; this class reimplements no algorithm.
 */
class Cve98260ProfileNativeImpl(private val context: Context) : Cve98260ProfileNative {

    private companion object {
        const val TAG = "GhostKeyProfile"
        const val PROGRESS_IDLE = "0 0 0"
        const val MAX_INPUT = 0x20000000L
        const val MAGIC = "ANDROID!"
        const val OTA_CACHE_DIR = "cve98260-ota"

        // 进度相位，与 Dart 侧 KernelProfileImportState.phase 一一对应。
        const val PHASE_LOCATE = 0 // 连接并定位 payload（无总量）
        const val PHASE_DOWNLOAD = 1 // 下载/读取镜像字节
        const val PHASE_PARSE = 2 // 解析内核
        const val PHASE_SAVE = 3 // 写入 profile
        const val PHASE_DONE = 4 // 结束
    }

    private val store = ImportedProfileStore(context)

    /** 内置表目录，只读 assets。 */
    private val builtinCatalog = BuiltinProfileCatalog(AssetConfigLoader(context.applicationContext))

    private val executor = Executors.newSingleThreadExecutor()

    private val mainHandler = Handler(Looper.getMainLooper())

    /** Progress triple snapshot; written on the worker, read on the Pigeon thread. */
    @Volatile
    private var progress = PROGRESS_IDLE

    override fun listImportedProfiles(callback: (Result<List<KernelProfile>>) -> Unit) {
        runAsync(callback) {
            store.list().map { KernelProfile(release = it.release, detail = it.detail) }
        }
    }

    override fun listBuiltinProfiles(callback: (Result<List<KernelProfile>>) -> Unit) {
        runAsync(callback) {
            // 内置表没有来源说明，detail 留空。
            builtinCatalog.all().map { KernelProfile(release = it.release, detail = "") }
        }
    }

    /** Progress reads bypass the executor so a running import cannot block them. */
    override fun importProgress(callback: (Result<String>) -> Unit) {
        mainHandler.post { callback(Result.success(progress)) }
    }

    override fun importBootImage(
        path: String,
        callback: (Result<KernelProfileImportResult>) -> Unit,
    ) {
        runAsync(callback) { importInternal(path) }
    }

    override fun importBootImageFromUrl(
        url: String,
        callback: (Result<KernelProfileImportResult>) -> Unit,
    ) {
        runAsync(callback) { importFromUrlInternal(url) }
    }

    override fun removeImportedProfile(
        release: String,
        callback: (Result<Boolean>) -> Unit,
    ) {
        runAsync(callback) { store.remove(release) }
    }

    override fun readImportedProfile(
        release: String,
        callback: (Result<String>) -> Unit,
    ) {
        // 用户导入优先；没有时回退到同名内置表，详情页对两者一视同仁。
        runAsync(callback) {
            store.readRaw(release).ifEmpty { builtinCatalog.readRaw(release) }
        }
    }

    fun dispose() {
        executor.shutdownNow()
    }

    private fun importInternal(path: String): KernelProfileImportResult {
        Log.i(TAG, "importBootImage path=$path")
        if (path.isBlank()) {
            Log.w(TAG, "importBootImage rejected: blank path")
            return failed("emptyPath")
        }
        val file = File(path)
        if (!file.isFile) {
            Log.w(TAG, "importBootImage rejected: not a file: $path")
            return failed("notFound")
        }
        if (file.length() > MAX_INPUT) {
            Log.w(TAG, "importBootImage rejected: too large ${file.length()} > $MAX_INPUT")
            return failed("tooLarge")
        }
        Log.i(TAG, "importBootImage local file name=${file.name} size=${file.length()}")

        progress = "1 0 ${file.length()}"
        val bytes = try {
            readWithProgress(file)
        } catch (e: IOException) {
            Log.w(TAG, "importBootImage read failed: ${e.javaClass.simpleName}: ${e.message}")
            return failed("io", e)
        } catch (e: OutOfMemoryError) {
            Log.w(TAG, "importBootImage OOM while reading, size=${file.length()}")
            return failed("oom", e)
        }

        Log.d(TAG, "importBootImage read ${bytes.size} bytes, checking boot magic")
        if (!hasBootMagic(bytes)) {
            Log.w(TAG, "importBootImage rejected: missing ANDROID! magic")
            return failed("notBootImage")
        }
        progress = "$PHASE_PARSE 0 1"
        return parseAndStore(bytes, file.name)
    }

    /**
     * 远端 OTA 导入：按 Range 只取 payload.bin 与 boot 分区，写入缓存后再走
     * 与本地导入相同的解析与落盘。
     */
    private fun importFromUrlInternal(rawUrl: String): KernelProfileImportResult {
        Log.i(TAG, "importBootImageFromUrl raw=$rawUrl")
        val url = rawUrl.trim()
        if (url.isEmpty()) {
            Log.w(TAG, "url import rejected: empty url")
            return failed("badUrl")
        }
        val scheme = runCatching { URI(url).scheme?.lowercase() }.getOrNull()
        Log.d(TAG, "url import scheme=$scheme")
        if (scheme != "http" && scheme != "https") {
            Log.w(TAG, "url import rejected: unsupported scheme=$scheme")
            return failed("badUrl")
        }

        val workDir = File(context.cacheDir, OTA_CACHE_DIR)
        Log.i(TAG, "url import workDir=${workDir.absolutePath} exists=${workDir.exists()}")
        progress = PROGRESS_IDLE
        var boot: File? = null
        return try {
            val extracted = OtaPayloadExtractor.extractPartitions(
                url = url,
                workDir = workDir.apply { mkdirs() },
                onLog = { Log.d(TAG, "ota: $it") },
                onProgress = { phase, done, total ->
                    Log.d(TAG, "ota progress phase=$phase $done/$total")
                    progress = "$phase $done $total"
                },
            )
            boot = extracted.bootFile
            Log.i(TAG, "url import extracted boot=${extracted.bootFile.absolutePath} size=${extracted.bootFile.length()} xbl=${extracted.xblConfigFile?.name}")
            extracted.xblConfigFile?.delete()
            val file = extracted.bootFile
            progress = "$PHASE_DOWNLOAD ${file.length()} ${file.length()}"
            val bytes = readWithProgress(file, report = false)
            Log.d(TAG, "url import read ${bytes.size} bytes from extracted boot")
            if (!hasBootMagic(bytes)) {
                Log.w(TAG, "url import rejected: extracted image missing ANDROID! magic")
                return failed("notBootImage")
            }
            progress = "$PHASE_PARSE 0 1"
            parseAndStore(bytes, file.name)
        } catch (e: IOException) {
            Log.w(TAG, "url import failed: ${e.javaClass.simpleName}: ${e.message}")
            failed("download", e)
        } catch (e: OutOfMemoryError) {
            Log.w(TAG, "url import OOM")
            failed("oom", e)
        } catch (t: Throwable) {
            Log.w(TAG, "url import unknown failure: ${t.javaClass.simpleName}: ${t.message}")
            failed("unknown", t)
        } finally {
            Log.d(TAG, "url import cleanup boot=${boot?.absolutePath} deleted=${boot?.let { !it.exists() }}")
            boot?.delete()
        }
    }

    /** 解析镜像并落盘；解析与保存共用同一段，URL 与本地两条入口都走这里。 */
    private fun parseAndStore(
        bytes: ByteArray,
        imageName: String,
    ): KernelProfileImportResult = try {
        Log.i(TAG, "parse $imageName bytes=${bytes.size}")
        val info = BootImageParser().parse(bytes)
        Log.i(
            TAG,
            "parse done release=${info.release} imageBytes=${info.imageBytes} sha256=${info.imageSha256} " +
                "hasBtf=${info.hasBtf} symbols=${info.symbolCount} imageBase=${info.imageBase} notes=${info.notes}",
        )
        val (doc, missing) = ImgToProfile.toProfileDocument(info, imageName)
        Log.i(TAG, "profile release=${doc.release} missing=$missing")
        if (missing.isNotEmpty()) {
            Log.w(TAG, "profile incomplete, not saved: missing=$missing notes=${info.notes}")
            KernelProfileImportResult(
                ok = false,
                release = doc.release,
                missing = missing,
                // 无 BTF 单独成码：这是 ROM 编译配置所致，用户换包即可，与其它缺字段可区分。
                errorCode = if (!info.hasBtf) "noBtf" else "incomplete",
                // 解析侧诊断（无 BTF / kallsyms 缺符号等）直接带到 UI，省去查日志。
                error = info.notes.joinToString("; "),
            )
        } else {
            runCatching { doc.toKernelProfile() }.getOrElse {
                if (it is ProfileConversionException) {
                    Log.w(TAG, "profile conversion failed: ${it.message}")
                    return KernelProfileImportResult(
                        ok = false,
                        release = doc.release,
                        missing = emptyList(),
                        errorCode = "incomplete",
                        error = detailOf(it),
                    )
                }
                throw it
            }
            progress = "$PHASE_SAVE 0 1"
            val release = store.save(doc)
            progress = "$PHASE_DONE 1 1"
            val saved = File(File(context.filesDir, ImportedProfileStore.DIR), "${ImportedProfileStore.fileNameOf(release)}.conf")
            Log.i(TAG, "profile saved release=$release path=${saved.absolutePath} size=${saved.length()}")
            KernelProfileImportResult(
                ok = true,
                release = release,
                missing = emptyList(),
                errorCode = "",
                error = "",
            )
        }
    } catch (e: BootImageParser.ImgExtractError) {
        Log.w(TAG, "parse failed (decode): ${e.message}")
        failed("decode", e)
    } catch (e: IOException) {
        Log.w(TAG, "parse failed (io): ${e.javaClass.simpleName}: ${e.message}")
        failed("io", e)
    } catch (e: OutOfMemoryError) {
        Log.w(TAG, "parse failed (oom)")
        failed("oom", e)
    } catch (t: Throwable) {
        Log.w(TAG, "parse failed (unknown): ${t.javaClass.simpleName}: ${t.message}", t)
        failed("unknown", t)
    }

    /**
     * 按文件真实长度一次性分配并读入。
     *
     * boot.img 常有上百 MB，`ByteArrayOutputStream` 的翻倍扩容会额外占用一份
     * 等大缓冲（再叠加 `toByteArray()` 的拷贝），在低内存设备上直接 OOM。
     */
    private fun readWithProgress(file: File, report: Boolean = true): ByteArray {
        val total = file.length()
        if (total > Int.MAX_VALUE) throw IOException("File too large: $total")
        if (report) progress = "$PHASE_DOWNLOAD 0 $total"
        val data = ByteArray(total.toInt())
        var readTotal = 0
        FileInputStream(file).use { input ->
            while (readTotal < data.size) {
                val n = input.read(data, readTotal, data.size - readTotal)
                if (n <= 0) break
                readTotal += n
                if (report) progress = "$PHASE_DOWNLOAD $readTotal $total"
            }
        }
        Log.d(TAG, "read file=${file.name} total=$readTotal")
        return if (readTotal == data.size) data else data.copyOf(readTotal)
    }

    private fun hasBootMagic(bytes: ByteArray): Boolean {
        if (bytes.size < MAGIC.length) return false
        for (i in MAGIC.indices) {
            if (bytes[i] != MAGIC[i].code.toByte()) return false
        }
        return true
    }

    private fun failed(code: String, error: Throwable? = null): KernelProfileImportResult {
        Log.i(TAG, "import result errorCode=$code detail=${error?.let { detailOf(it) }.orEmpty()}")
        return KernelProfileImportResult(
            ok = false,
            release = "",
            missing = emptyList(),
            errorCode = code,
            error = error?.let { detailOf(it) } ?: "",
        )
    }

    private fun detailOf(error: Throwable): String =
        (error::class.simpleName ?: "Throwable") + ": " + (error.message ?: "")

    private fun <T> runAsync(callback: (Result<T>) -> Unit, block: () -> T) {
        executor.execute {
            val result = runCatching(block)
            mainHandler.post { callback(result) }
        }
    }
}
