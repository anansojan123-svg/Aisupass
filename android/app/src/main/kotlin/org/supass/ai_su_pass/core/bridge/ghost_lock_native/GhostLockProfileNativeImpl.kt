package org.supass.ai_su_pass.core.bridge.ghost_lock_native

import android.content.ContentValues
import android.content.Context
import android.os.Environment
import android.os.Handler
import android.os.Looper
import android.provider.MediaStore
import java.io.File
import java.util.concurrent.Executors
import org.supass.ai_su_pass.cve43499.GhostLockAssets
import org.supass.ai_su_pass.cve43499.GhostLockProfileController
import org.supass.ai_su_pass.cve43499.GhostLockProfileEditStore
import org.supass.ai_su_pass.cve43499.GhostLockProfileExtractor
import org.supass.ai_su_pass.cve43499.GhostLockProfileImporter
import org.supass.ai_su_pass.cve43499.GhostLockProfileStore
import org.supass.ai_su_pass.cve43499.LegacyProfileConverter
import org.supass.ai_su_pass.cve43499.profile.asValueMap
import org.supass.ai_su_pass.cve98260.HoconSupport

/**
 * profile 导入的原生桥：线程分发与结果翻译，不含提取逻辑。
 */
class GhostLockProfileNativeImpl(context: Context) : GhostLockProfileNative {

    private val appContext = context.applicationContext

    private val importer = GhostLockProfileImporter(appContext)

    private val store = GhostLockProfileStore(GhostLockProfileStore.directory(appContext))

    /** 内置表目录（assets/kernel_profiles/ghostlock），只读。 */
    private val controller = GhostLockProfileController(
        GhostLockAssets(appContext),
        store,
        GhostLockProfileEditStore(appContext),
    )

    /** 删除文档时要同步清掉「当前生效」的选择。 */
    private val editStore = GhostLockProfileEditStore(appContext)

    /** 提取会下载、解包、反汇编，必须离开通道线程。 */
    private val worker = Executors.newSingleThreadExecutor()

    private val mainHandler = Handler(Looper.getMainLooper())

    override fun probeProfile(
        input: String,
        insecure: Boolean,
        xblPath: String,
        uefiPath: String,
        vendorBootPath: String,
        phys: String,
        kallsymsPath: String,
        iomemPath: String,
        route: String,
        allowMissing: Boolean,
        noDisasm: Boolean,
        callback: (Result<GhostLockProbeResult>) -> Unit,
    ) {
        worker.execute {
            val outcome = importer.probe(
                input,
                insecure,
                xblPath,
                uefiPath,
                vendorBootPath,
                phys,
                kallsymsPath,
                iomemPath,
                route,
                allowMissing,
                noDisasm,
            )
            val probe = outcome.probe
            val result = GhostLockProbeResult(
                ok = probe != null,
                release = probe?.release.orEmpty(),
                conf = probe?.conf.orEmpty(),
                warnings = probe?.warnings.orEmpty(),
                bootPath = probe?.bootPath.orEmpty(),
                reason = outcome.reason,
                kernelPhysLoad = probe?.kernelPhysLoad.orEmpty(),
                kernelPhysOffset = probe?.kernelPhysOffset.orEmpty(),
                physSource = probe?.physSource.orEmpty(),
                analysis = probe?.analysis ?: outcome.analysis,
            )
            mainHandler.post { callback(Result.success(result)) }
        }
    }

    override fun profileProgress(callback: (Result<String>) -> Unit) {
        val text = try {
            Result.success(GhostLockProfileExtractor.nativeProfileProgress())
        } catch (e: Exception) {
            Result.failure<String>(e)
        }
        callback(text)
    }

    override fun saveProfile(
        release: String,
        conf: String,
        overwrite: Boolean,
        callback: (Result<GhostLockImportResult>) -> Unit,
    ) {
        worker.execute {
            val outcome = importer.save(release, conf, overwrite)
            val result = GhostLockImportResult(
                ok = outcome.imported != null,
                release = outcome.imported?.release.orEmpty(),
                fileName = outcome.imported?.fileName.orEmpty(),
                reason = outcome.reason,
                requiresOverwrite = outcome.requiresOverwrite,
            )
            mainHandler.post { callback(Result.success(result)) }
        }
    }

    override fun importProfile(
        input: String,
        insecure: Boolean,
        overwrite: Boolean,
        callback: (Result<GhostLockImportResult>) -> Unit,
    ) {
        worker.execute {
            val outcome = importer.import(input, insecure, overwrite)
            val result = GhostLockImportResult(
                ok = outcome.imported != null,
                release = outcome.imported?.release.orEmpty(),
                fileName = outcome.imported?.fileName.orEmpty(),
                reason = outcome.reason,
                requiresOverwrite = outcome.requiresOverwrite,
            )
            mainHandler.post { callback(Result.success(result)) }
        }
    }

    override fun listImportedProfiles(
        callback: (Result<List<GhostLockUserProfile>>) -> Unit,
    ) {
        worker.execute {
            val profiles = store.list().map { item ->
                GhostLockUserProfile(
                    name = item.name,
                    release = item.release.orEmpty(),
                    sizeBytes = item.sizeBytes,
                    importedAtMs = item.importedAt,
                    parseError = item.parseError,
                )
            }
            mainHandler.post { callback(Result.success(profiles)) }
        }
    }

    override fun listBuiltinReleases(callback: (Result<List<String>>) -> Unit) {
        worker.execute {
            val releases = runCatching { controller.builtinReleases() }
            mainHandler.post { callback(Result.success(releases.getOrDefault(emptyList()))) }
        }
    }

    override fun readImportedProfile(
        name: String,
        callback: (Result<String>) -> Unit,
    ) {
        worker.execute {
            // 用户导入优先；name 可传内置 release，未命中时回退内置表。
            val text = store.rawText(name).orEmpty()
                .ifEmpty { runCatching { controller.builtinRawText(name) }.getOrDefault("") }
            mainHandler.post { callback(Result.success(text)) }
        }
    }

    override fun removeImportedProfile(
        name: String,
        callback: (Result<Boolean>) -> Unit,
    ) {
        worker.execute {
            val removed = store.delete(name)
            if (removed) editStore.clearActiveUserProfileIf(name)
            mainHandler.post { callback(Result.success(removed)) }
        }
    }

    override fun importProfileText(
        text: String,
        fileName: String,
        overwrite: Boolean,
        callback: (Result<GhostLockImportResult>) -> Unit,
    ) {
        worker.execute {
            val outcome = importer.importText(text, fileName, overwrite)
            val result = GhostLockImportResult(
                ok = outcome.imported != null,
                release = outcome.imported?.release.orEmpty(),
                fileName = outcome.imported?.fileName.orEmpty(),
                reason = outcome.reason,
                requiresOverwrite = outcome.requiresOverwrite,
            )
            mainHandler.post { callback(Result.success(result)) }
        }
    }

    override fun renameImportedProfile(
        name: String,
        newName: String,
        callback: (Result<String>) -> Unit,
    ) {
        worker.execute {
            val renamed = store.rename(name, newName).orEmpty()
            // 「当前生效」若指向被改名的文档，跟着改名，否则选择会失效。
            if (renamed.isNotEmpty() && editStore.activeUserProfile() == name) {
                editStore.setActiveUserProfile(renamed)
            }
            mainHandler.post { callback(Result.success(renamed)) }
        }
    }

    override fun exportImportedProfile(
        name: String,
        callback: (Result<String>) -> Unit,
    ) {
        worker.execute {
            val text = store.rawText(name).orEmpty()
            val rendered = if (text.isBlank()) {
                ""
            } else {
                runCatching {
                    when (val value = HoconSupport.parseValue(text)) {
                        is Map<*, *> -> HoconSupport.render(
                            value.asValueMap() ?: return@runCatching text,
                        )
                        else -> text
                    }
                }.getOrDefault(text)
            }
            mainHandler.post { callback(Result.success(rendered)) }
        }
    }

    override fun convertImportedProfile(
        name: String,
        callback: (Result<GhostLockImportResult>) -> Unit,
    ) {
        worker.execute {
            val text = store.rawText(name).orEmpty()
            val result = if (text.isBlank()) {
                GhostLockImportResult(
                    ok = false,
                    release = "",
                    fileName = "",
                    reason = "missing",
                    requiresOverwrite = false,
                )
            } else {
                runCatching {
                    val entry = HoconSupport.parseValue(text).asValueMap()
                        ?: error("not an object")
                    LegacyProfileConverter.convertValue(entry)
                    entry["schema_version"] = 1
                    val fileName = "${name.substringBeforeLast('.')}-converted.conf"
                    val stored = store.save(fileName, HoconSupport.render(entry))
                    GhostLockImportResult(
                        ok = stored,
                        release = (entry["release"] as? String).orEmpty(),
                        fileName = fileName.takeIf { stored }.orEmpty(),
                        reason = if (stored) "" else "writeFailed",
                        requiresOverwrite = false,
                    )
                }.getOrElse {
                    GhostLockImportResult(
                        ok = false,
                        release = "",
                        fileName = "",
                        reason = it.message ?: "convertFailed",
                        requiresOverwrite = false,
                    )
                }
            }
            mainHandler.post { callback(Result.success(result)) }
        }
    }

    override fun exportLocalFile(
        sourcePath: String,
        fileName: String,
        callback: (Result<String>) -> Unit,
    ) {
        worker.execute {
            val saved = runCatching { copyToDownloads(sourcePath, fileName) }
                .getOrDefault("")
            mainHandler.post { callback(Result.success(saved)) }
        }
    }

    override fun listExtractedImages(callback: (Result<List<String>>) -> Unit) {
        worker.execute {
            val dir = File(appContext.cacheDir, "ghostlock-payload")
            val images = dir.listFiles()
                .orEmpty()
                .filter { it.isFile && it.length() > 0 }
                .filter { it.extension.lowercase() in setOf("img", "bin") }
                .sortedBy { it.name }
                .map { it.absolutePath }
            mainHandler.post { callback(Result.success(images)) }
        }
    }

    /**
     * 把缓存里的镜像复制到「下载」目录（MediaStore）。
     *
     * 只允许本 App 缓存目录内的源文件，避免被当作任意文件搬运通道。
     * 成功返回落点显示名，失败返回空串。
     */
    private fun copyToDownloads(sourcePath: String, fileName: String): String {
        if (sourcePath.isBlank()) return ""
        val source = File(sourcePath)
        val cacheRoot = appContext.cacheDir.canonicalFile
        val canonical = source.canonicalFile
        if (!canonical.path.startsWith(cacheRoot.path + File.separator)) return ""
        if (!canonical.isFile || canonical.length() == 0L) return ""
        val display = fileName.ifBlank { canonical.name }
        val resolver = appContext.contentResolver
        val values = ContentValues().apply {
            put(MediaStore.MediaColumns.DISPLAY_NAME, display)
            put(MediaStore.MediaColumns.MIME_TYPE, "application/octet-stream")
            put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
        }
        val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
            ?: return ""
        val copied = runCatching {
            resolver.openOutputStream(uri)?.use { output ->
                canonical.inputStream().use { input -> input.copyTo(output) }
            } ?: error("openOutput failed")
        }.isSuccess
        if (!copied) {
            runCatching { resolver.delete(uri, null, null) }
            return ""
        }
        return display
    }

    /** 由 [org.supass.ai_su_pass.NativeProvider] 在重建或销毁时调用。 */
    fun dispose() {
        worker.shutdownNow()
    }
}
