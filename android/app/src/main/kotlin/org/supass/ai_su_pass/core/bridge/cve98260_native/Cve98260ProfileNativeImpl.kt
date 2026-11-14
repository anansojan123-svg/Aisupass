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
import org.supass.ai_su_pass.cve98260.KernelProfileEditor
import org.supass.ai_su_pass.cve98260.ProfileConversionException
import org.supass.ai_su_pass.cve98260.ProfileDocument
import org.supass.ai_su_pass.cve98260.ota.BootImageParser
import org.supass.ai_su_pass.cve98260.ota.ImgToProfile
import org.supass.ai_su_pass.cve98260.ota.ImportedProfileSelection
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

    /** 生效选择：存文档名，与同一 release 的多份文档区分。 */
    private val selection = ImportedProfileSelection(context)

    /** 内置表目录，只读 assets；匹配时结合用户文档与选择。 */
    private val builtinCatalog = BuiltinProfileCatalog(
        AssetConfigLoader(context.applicationContext),
        store,
        selection,
    )

    private val executor = Executors.newSingleThreadExecutor()

    private val mainHandler = Handler(Looper.getMainLooper())

    /** Progress triple snapshot; written on the worker, read on the Pigeon thread. */
    @Volatile
    private var progress = PROGRESS_IDLE

    override fun listImportedProfiles(callback: (Result<List<KernelProfile>>) -> Unit) {
        runAsync(callback) {
            store.list().map {
                KernelProfile(name = it.name, release = it.release, detail = it.detail)
            }
        }
    }

    override fun listBuiltinProfiles(callback: (Result<List<KernelProfile>>) -> Unit) {
        runAsync(callback) {
            // 内置表没有文档名与来源说明。
            builtinCatalog.all().map {
                KernelProfile(name = "", release = it.release, detail = "")
            }
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
        name: String,
        callback: (Result<Boolean>) -> Unit,
    ) {
        runAsync(callback) {
            val removed = store.remove(name)
            if (removed) {
                selection.clearIfActive(name)
                Log.i(TAG, "removed profile $name")
            }
            removed
        }
    }

    override fun readImportedProfile(
        name: String,
        release: String,
        callback: (Result<String>) -> Unit,
    ) {
        // 有文档名读用户文档；否则按 release 读内置表，详情页对两者一视同仁。
        runAsync(callback) {
            if (name.isNotEmpty()) {
                store.readRaw(name)
            } else {
                builtinCatalog.readRaw(release)
            }
        }
    }

    override fun activeImportedProfile(callback: (Result<String>) -> Unit) {
        runAsync(callback) { selection.activeName().orEmpty() }
    }

    override fun selectImportedProfile(name: String, callback: (Result<Boolean>) -> Unit) {
        runAsync(callback) {
            /* 生效来源二选一，与 GhostLock 的 selectUserProfile 一致。 */
            if (name.isNotEmpty()) selection.setActiveBuiltin(null)
            selection.setActiveName(name)
            Log.i(TAG, "selected profile ${name.ifEmpty { "<none>" }}")
            true
        }
    }

    override fun activeBuiltinRelease(callback: (Result<String>) -> Unit) {
        runAsync(callback) { selection.activeBuiltin().orEmpty() }
    }

    override fun selectBuiltinRelease(release: String, callback: (Result<Boolean>) -> Unit) {
        runAsync(callback) {
            if (release.isNotEmpty()) selection.setActiveName(null)
            selection.setActiveBuiltin(release)
            Log.i(TAG, "selected builtin ${release.ifEmpty { "<none>" }}")
            true
        }
    }

    fun dispose() {
        executor.shutdownNow()
    }

    /** 读可编辑字段；只有用户文档可编辑，找不到文档时 name 为空串。 */
    override fun readProfileEditor(
        name: String,
        callback: (Result<KernelProfileEditorState>) -> Unit,
    ) {
        runAsync(callback) {
            val doc = store.readDocument(name)
            if (doc == null) {
                Log.w(TAG, "readProfileEditor: no user profile for $name")
                return@runAsync KernelProfileEditorState(
                    name = "",
                    release = "",
                    vulnType = "",
                    detail = "",
                    fields = emptyList(),
                )
            }
            val values = KernelProfileEditor.read(doc)
            KernelProfileEditorState(
                name = name,
                release = doc.release,
                vulnType = doc.getString("vuln_type") ?: "cve-2026-98260",
                detail = doc.getString("_source").orEmpty(),
                fields = KernelProfileEditor.FIELDS.map { spec ->
                    KernelProfileFieldValue(
                        path = spec.path,
                        value = values[spec.path]?.toString().orEmpty(),
                        hex = spec.hex,
                        advanced = spec.advanced,
                    )
                },
            )
        }
    }

    /** 把编辑值写回同一份文档；校验完整后才落盘。 */
    override fun saveProfileEditor(
        name: String,
        values: Map<String, String>,
        callback: (Result<KernelProfileImportResult>) -> Unit,
    ) {
        runAsync(callback) {
            val edited = try {
                applyEditor(name, values)
            } catch (e: ProfileConversionException) {
                Log.w(TAG, "editor field rejected: ${e.message}")
                return@runAsync KernelProfileImportResult(
                    ok = false,
                    release = "",
                    missing = emptyList(),
                    errorCode = "invalidField",
                    error = e.message.orEmpty(),
                )
            } ?: return@runAsync editorNotFound()
            if (!store.save(name, edited)) return@runAsync editorIoFailure(edited.release)
            Log.i(TAG, "editor saved $name")
            KernelProfileImportResult(true, edited.release, emptyList(), "", "")
        }
    }

    /** 另存为新文档，原文档保留；返回新文档名。 */
    override fun saveProfileEditorAs(
        name: String,
        documentName: String,
        values: Map<String, String>,
        callback: (Result<String>) -> Unit,
    ) {
        runAsync(callback) {
            val edited = runCatching { applyEditor(name, values) }.getOrElse {
                Log.w(TAG, "editor saveAs rejected: ${it.message}")
                return@runAsync ""
            } ?: return@runAsync ""
            val saved = store.saveAs(edited, documentName)
            Log.i(TAG, "editor saved as $saved (from $name)")
            saved
        }
    }

    /** 渲染编辑后的 HOCON 文本；无法解析时返回空串。 */
    override fun renderProfileEditor(
        name: String,
        values: Map<String, String>,
        callback: (Result<String>) -> Unit,
    ) {
        runAsync(callback) {
            val doc = store.readDocument(name) ?: return@runAsync ""
            runCatching { KernelProfileEditor.apply(doc, values).toHocon() }
                .getOrDefault("")
        }
    }

    /**
     * 合并编辑值并校验完整性；不落盘。
     *
     * 返回 null 表示文档不存在；字段非法直接抛 [ProfileConversionException]，
     * 由调用方转错误码。
     */
    private fun applyEditor(name: String, values: Map<String, String>): ProfileDocument? {
        val doc = store.readDocument(name) ?: return null
        val next = KernelProfileEditor.apply(doc, values)
        val missing = next.missingRequiredFields()
        if (missing.isNotEmpty()) {
            throw ProfileConversionException("缺少必填字段: ${missing.joinToString()}")
        }
        return next
    }

    private fun editorNotFound(): KernelProfileImportResult =
        KernelProfileImportResult(false, "", emptyList(), "notFound", "")

    private fun editorIoFailure(release: String): KernelProfileImportResult =
        KernelProfileImportResult(false, release, emptyList(), "io", "")

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
            val name = store.saveImported(doc)
            if (name.isEmpty()) {
                Log.w(TAG, "profile save failed release=${doc.release}")
                return failed("io")
            }
            progress = "$PHASE_DONE 1 1"
            val saved = File(File(context.filesDir, ImportedProfileStore.DIR), name)
            Log.i(TAG, "profile saved name=$name path=${saved.absolutePath} size=${saved.length()}")
            KernelProfileImportResult(
                ok = true,
                release = doc.release,
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
