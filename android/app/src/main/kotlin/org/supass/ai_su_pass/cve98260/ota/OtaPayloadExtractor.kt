package org.supass.ai_su_pass.cve98260.ota

import android.util.Log
import java.io.ByteArrayInputStream
import java.io.File
import java.io.IOException
import java.io.RandomAccessFile
import java.util.Locale
import kotlin.math.min
import org.apache.commons.compress.compressors.bzip2.BZip2CompressorInputStream
import org.tukaani.xz.XZInputStream

/**
 * High-performance streaming OTA partition extractor in pure Kotlin.
 * Downloads only the payload metadata and the blocks needed for boot and xbl_config.
 */
object OtaPayloadExtractor {

    data class ExtractedPartitions(
        val bootFile: File, val xblConfigFile: File? = null
    )

    private const val TAG = "GhostKeyOta"
    private const val END_BYTES_SIZE = 65536
    private const val LOCAL_HEADER_PROBE_SIZE = 256
    private const val PREVIEW_SIZE = 512L

    /** 把响应体开头转成可读预览：可打印 ASCII 直出，否则给十六进制。 */
    private fun previewOf(bytes: ByteArray?): String {
        if (bytes == null || bytes.isEmpty()) return "<empty>"
        val printable = bytes.all { it in 0x20..0x7E || it == '\n'.code.toByte() || it == '\r'.code.toByte() || it == '\t'.code.toByte() }
        return if (printable) {
            bytes.decodeToString().replace("\n", "\\n").replace("\r", "\\r")
        } else {
            bytes.joinToString(" ") { "%02x".format(it) }
        }
    }

    /** 取前 n 字节的十六进制串，用于判断压缩流魔数。 */
    private fun hexOf(bytes: ByteArray, n: Int): String =
        bytes.take(n).joinToString(" ") { "%02x".format(it) }

    /**
     * 流式解压并直接写入目标 extents。
     *
     * 单个 op 的解压结果可达数百 MB（boot 分区总长就上百 MB），先整块解成
     * ByteArray 再写盘会让峰值内存翻倍。这里按 extent 顺序边解边写，只保留
     * 64 KiB 读缓冲；读满 extents 就停，末尾对齐填充不会被继续解码。
     */
    private fun writeExtentsStreamed(
        raf: RandomAccessFile,
        stream: java.io.InputStream,
        extents: List<PayloadBinUtils.Extent>,
        blockSize: Long,
    ): Long {
        val buffer = ByteArray(64 * 1024)
        var written = 0L
        for (extent in extents) {
            var remaining = extent.numBlocks * blockSize
            raf.seek(extent.startBlock * blockSize)
            while (remaining > 0L) {
                val n = stream.read(buffer, 0, min(buffer.size.toLong(), remaining).toInt())
                if (n <= 0) return written
                raf.write(buffer, 0, n)
                remaining -= n
                written += n
            }
        }
        return written
    }

    /** XZ 流魔数：FD 37 7A 58 5A 00。 */
    private fun isXzMagic(bytes: ByteArray): Boolean =
        bytes.size >= 6 &&
            bytes[0] == 0xFD.toByte() && bytes[1] == 0x37.toByte() &&
            bytes[2] == 0x7A.toByte() && bytes[3] == 0x58.toByte() &&
            bytes[4] == 0x5A.toByte() && bytes[5] == 0x00.toByte()

    /**
     * 解包 boot（以及存在的 xbl_config）。
     *
     * [onProgress] 的 phase：0 = 连接并定位 payload.bin（无总量），
     * 1 = 下载并解压分区数据（done/total 为字节），调用方据此渲染步骤。
     */
    fun extractPartitions(
        url: String, workDir: File, onLog: (String) -> Unit,
        onProgress: (phase: Int, downloaded: Long, total: Long) -> Unit = { _, _, _ -> },
    ): ExtractedPartitions {
        Log.i(TAG, "extract start url=$url workDir=${workDir.absolutePath}")
        onProgress(0, 0L, 0L)
        val reader = HttpRangeReader()
        val fileLength = reader.fileLength(url) ?: throw IOException("Failed to connect or determine file length from URL")
        if (fileLength <= 0L) {
            throw IOException("Remote file length is zero or invalid")
        }
        Log.i(TAG, "remote file length=$fileLength (${formatSize(fileLength)})")

        onLog("locating payload metadata (file size: ${formatSize(fileLength)})...")

        // 1. Determine payload.bin start offset within the file
        val payloadStart = locatePayloadStart(reader, url, fileLength, onLog)
        Log.i(TAG, "payload.bin offset=$payloadStart")

        // 2. Read payload header (24 bytes)
        val headerBytes =
            reader.read(url, payloadStart, PayloadBinUtils.HEADER_SIZE) ?: throw IOException("Failed to read payload.bin header at offset $payloadStart")
        val payloadHeader = PayloadBinUtils.parseHeader(headerBytes) ?: throw IOException("Invalid payload.bin header (missing CrAU magic)")
        Log.i(TAG, "payload header manifestSize=${payloadHeader.manifestSize} signatureSize=${payloadHeader.signatureSize}")

        // 3. Read manifest bytes
        val manifestStart = payloadStart + PayloadBinUtils.HEADER_SIZE
        if (payloadHeader.manifestSize > Int.MAX_VALUE) {
            throw IOException("Payload manifest size exceeds maximum supported memory (${payloadHeader.manifestSize} bytes)")
        }
        val manifest = reader.read(url, manifestStart, payloadHeader.manifestSize.toInt()) ?: throw IOException(
            "Failed to read payload manifest (${
                formatSize(payloadHeader.manifestSize)
            })"
        )

        // 4. Inspect available partitions
        val partitions = PayloadBinUtils.listPartitions(manifest)
        Log.i(TAG, "manifest partitions=$partitions")
        if ("boot" !in partitions) {
            throw IOException("Payload does not contain 'boot' partition (found: ${partitions.joinToString()})")
        }
        val want = mutableListOf("boot")
        if ("xbl_config" in partitions) {
            want.add("xbl_config")
        }
        onLog("analyzing partitions: ${want.joinToString(", ")}")

        val blockSize = PayloadBinUtils.blockSize(manifest)
        val dataBase = payloadStart + PayloadBinUtils.HEADER_SIZE + payloadHeader.manifestSize + payloadHeader.signatureSize
        Log.i(TAG, "blockSize=$blockSize dataBase=$dataBase")

        // 5. Gather operations for the partitions
        val partitionOps = want.associateWith { name ->
            val ops = PayloadBinUtils.partitionOperations(manifest, name)
            if (ops.isEmpty()) throw IOException("Partition '$name' has no operations in payload")
            ops
        }
        partitionOps.forEach { (name, ops) ->
            val types = ops.groupingBy { it.type }.eachCount()
            val bytes = ops.sumOf { it.dataLength }
            Log.i(TAG, "partition $name: ops=${ops.size} dataBytes=$bytes (${formatSize(bytes)}) types=$types")
        }

        val totalDownloadBytes = partitionOps.values.sumOf { ops -> ops.sumOf { it.dataLength } }
        Log.i(TAG, "total download bytes=$totalDownloadBytes (${formatSize(totalDownloadBytes)})")
        var currentDownloadedBytes = 0L
        var lastLogTime = 0L

        // 进度每完成一个 op 就上报（UI 轮询 200 ms）；文本日志仍限频 2 s。
        fun reportProgress(force: Boolean = false) {
            onProgress(1, currentDownloadedBytes, totalDownloadBytes)
            val now = System.currentTimeMillis()
            if (force || now - lastLogTime >= 2000) {
                lastLogTime = now
                val percent = if (totalDownloadBytes > 0) {
                    currentDownloadedBytes.toDouble() / totalDownloadBytes * 100.0
                } else 0.0
                onLog(
                    "download: ${formatSize(currentDownloadedBytes)} / ${
                        formatSize(
                            totalDownloadBytes
                        )
                    } (" + String.format(Locale.US, "%.1f", percent) + "%)"
                )
            }
        }

        reportProgress(force = true)

        // 6. Extract partitions
        val timestamp = System.currentTimeMillis()
        var bootFile: File? = null
        var xblConfigFile: File? = null

        try {
            for ((name, ops) in partitionOps) {
                val outFile = File(workDir, "ghostlock_ota_${name}_$timestamp.img")
                if (name == "boot") bootFile = outFile else xblConfigFile = outFile

                val totalSize = ops.flatMap { it.destExtents }.maxOfOrNull { (it.startBlock + it.numBlocks) * blockSize }
                    ?: throw IOException("Partition '$name' has zero length")
                Log.i(TAG, "extract $name -> ${outFile.name} totalSize=$totalSize")

                RandomAccessFile(outFile, "rw").use { raf ->
                    raf.setLength(totalSize)

                    for ((index, op) in ops.withIndex()) {
                        when (op.type) {
                            PayloadBinUtils.OP_ZERO, PayloadBinUtils.OP_DISCARD -> {
                                // Already zero-filled by setLength
                            }

                            PayloadBinUtils.OP_REPLACE -> {
                                Log.d(TAG, "$name op[$index] REPLACE dataOffset=${op.dataOffset} dataLength=${op.dataLength} extents=${op.destExtents.size}")
                                val data = reader.read(
                                    url, dataBase + op.dataOffset, op.dataLength.toInt()
                                ) ?: throw IOException("Failed to read REPLACE operation for $name at offset ${dataBase + op.dataOffset}")
                                writeExtents(raf, data, op.destExtents, blockSize)
                                currentDownloadedBytes += op.dataLength
                                reportProgress()
                            }

                            PayloadBinUtils.OP_REPLACE_XZ -> {
                                val compressed = reader.read(
                                    url, dataBase + op.dataOffset, op.dataLength.toInt()
                                ) ?: throw IOException("Failed to read REPLACE_XZ operation for $name at offset ${dataBase + op.dataOffset}")
                                val uncompressedSize = op.destExtents.sumOf { it.numBlocks } * blockSize
                                Log.d(TAG, "$name op[$index] REPLACE_XZ packed=${compressed.size} expected=$uncompressedSize extents=${op.destExtents.size} head=${hexOf(compressed, 6)}")
                                val written = try {
                                    ByteArrayInputStream(compressed).use { raw ->
                                        XZInputStream(raw).use { stream ->
                                            writeExtentsStreamed(raf, stream, op.destExtents, blockSize)
                                        }
                                    }
                                } catch (e: Exception) {
                                    throw IOException(
                                        "$name op[$index] xz decode failed (packed=${compressed.size}, " +
                                            "expected=$uncompressedSize, head=${hexOf(compressed, 6)}, " +
                                            "magicOk=${isXzMagic(compressed)}): ${e.message}",
                                        e,
                                    )
                                }
                                Log.d(TAG, "$name op[$index] xz decompressed ${compressed.size} -> $written (expected $uncompressedSize)")
                                if (written != uncompressedSize) {
                                    Log.w(TAG, "$name op[$index] xz size mismatch: got $written expected $uncompressedSize")
                                }
                                currentDownloadedBytes += op.dataLength
                                reportProgress()
                            }

                            PayloadBinUtils.OP_REPLACE_BZ -> {
                                val compressed = reader.read(
                                    url, dataBase + op.dataOffset, op.dataLength.toInt()
                                ) ?: throw IOException("Failed to read REPLACE_BZ operation for $name at offset ${dataBase + op.dataOffset}")
                                val uncompressedSize = op.destExtents.sumOf { it.numBlocks } * blockSize
                                Log.d(TAG, "$name op[$index] REPLACE_BZ packed=${compressed.size} expected=$uncompressedSize head=${hexOf(compressed, 4)}")
                                val written = try {
                                    BZip2CompressorInputStream(ByteArrayInputStream(compressed)).use { stream ->
                                        writeExtentsStreamed(raf, stream, op.destExtents, blockSize)
                                    }
                                } catch (e: IOException) {
                                    throw IOException(
                                        "$name op[$index] bzip2 decode failed (packed=${compressed.size}, " +
                                            "expected=$uncompressedSize, head=${hexOf(compressed, 4)}): ${e.message}",
                                        e,
                                    )
                                }
                                if (written != uncompressedSize) {
                                    Log.w(TAG, "$name op[$index] bzip2 size mismatch: got $written expected $uncompressedSize")
                                }
                                currentDownloadedBytes += op.dataLength
                                reportProgress()
                            }

                            else -> {
                                Log.e(TAG, "$name op[$index] unsupported type=${op.type}")
                                throw IOException("Unsupported payload operation type: ${op.type} in partition '$name'")
                            }
                        }
                    }
                }
                onLog("extracted $name=${outFile.name} (${formatSize(outFile.length())}) from payload")
                Log.i(TAG, "extracted $name=${outFile.absolutePath} len=${outFile.length()}")
            }
            reportProgress(force = true)
            return ExtractedPartitions(bootFile!!, xblConfigFile)
        } catch (e: Exception) {
            Log.w(TAG, "extract failed, cleaning partial files: ${e.javaClass.simpleName}: ${e.message}")
            bootFile?.delete()
            xblConfigFile?.delete()
            throw e
        }
    }

    private fun locatePayloadStart(
        reader: HttpRangeReader, url: String, fileLength: Long, onLog: (String) -> Unit
    ): Long {
        // Probe head first: is it already a raw payload.bin?
        val headBytes = reader.read(url, 0L, 4)
        if (headBytes != null && headBytes.size >= 4 && headBytes.contentEquals(PayloadBinUtils.PAYLOAD_MAGIC)) {
            Log.i(TAG, "source is a direct payload.bin")
            onLog("detected direct payload.bin")
            return 0L
        }
        Log.i(TAG, "source is not a raw payload.bin (head=${headBytes?.size} bytes), treating as OTA zip")

        // Range 探测：offset>0 若能读回，说明服务端认 Range，后续只下需要的块。
        val rangeProbe = reader.read(url, 1L, 1)
        Log.i(TAG, "range probe offset=1 -> ${if (rangeProbe == null) "unsupported" else "ok"} contentType=${reader.lastContentType}")
        if (rangeProbe == null) {
            // 手机端常见两种情形：服务端忽略 Range 回 200 全量、或中间设备劫持回 HTML。
            // 把状态码与响应体开头一起带上，才能区分「服务端不支持」和「请求被拦截」。
            val preview = previewOf(reader.read(url, 0L, min(fileLength, PREVIEW_SIZE).toInt()))
            throw IOException(
                "Server does not support HTTP Range (code=${reader.lastStatusCode}, " +
                    "contentType=${reader.lastContentType ?: "<none>"}, preview=$preview); " +
                    "cannot read only the boot partition",
            )
        }

        // Locate via ZIP Central Directory
        val tailSize = min(fileLength, END_BYTES_SIZE.toLong()).toInt()
        val tailBytes = reader.read(url, fileLength - tailSize, tailSize) ?: throw IOException("Failed to read ZIP tail from remote file")

        val cd = ZipFileUtils.locateCentralDirectory(tailBytes, fileLength)
        if (cd.offset < 0 || cd.size <= 0 || cd.offset + cd.size > fileLength) {
            Log.w(
                TAG,
                "no ZIP central directory; contentType=${reader.lastContentType} " +
                    "rangeSupported=${reader.lastPartialContent} preview=${previewOf(reader.read(url, 0L, min(fileLength, PREVIEW_SIZE).toInt()))}",
            )
            throw IOException(
                "Remote source is not an OTA zip or payload.bin " +
                    "(contentType=${reader.lastContentType ?: "<none>"}, " +
                    "rangeSupported=${reader.lastPartialContent}, size=$fileLength)",
            )
        }

        val cdBytes = reader.read(url, cd.offset, cd.size.toInt()) ?: throw IOException("Failed to read ZIP Central Directory (${cd.size} bytes)")

        val entry = ZipFileUtils.locateEntries(
            cdBytes, setOf(PayloadBinUtils.PAYLOAD_ENTRY)
        )[PayloadBinUtils.PAYLOAD_ENTRY] ?: throw IOException("Remote OTA ZIP does not contain '${PayloadBinUtils.PAYLOAD_ENTRY}'")

        if (entry.method != 0) {
            throw IOException("payload.bin in remote ZIP must be Stored (uncompressed), found compression method ${entry.method}")
        }

        val headerOffset = entry.localHeaderOffset
        if (headerOffset !in 0..<fileLength) {
            throw IOException("Invalid local header offset in ZIP: $headerOffset")
        }

        val probeSize = min(fileLength - headerOffset, LOCAL_HEADER_PROBE_SIZE.toLong()).toInt()
        val localHeaderBytes = reader.read(url, headerOffset, probeSize) ?: throw IOException("Failed to read local file header for payload.bin")

        val internalOffset = ZipFileUtils.locateLocalFileOffset(localHeaderBytes)
        if (internalOffset !in 0..probeSize.toLong()) {
            throw IOException("Failed to parse local file header offset for payload.bin")
        }

        val payloadStart = headerOffset + internalOffset
        onLog("located payload.bin in OTA zip at offset $payloadStart (${formatSize(entry.uncompressedSize)})")
        return payloadStart
    }

    private fun writeExtents(
        raf: RandomAccessFile, data: ByteArray, extents: List<PayloadBinUtils.Extent>, blockSize: Long
    ) {
        var dataOffset = 0
        for (extent in extents) {
            val extentBytes = (extent.numBlocks * blockSize).toInt()
            val end = min(dataOffset + extentBytes, data.size)
            if (dataOffset < end) {
                raf.seek(extent.startBlock * blockSize)
                raf.write(data, dataOffset, end - dataOffset)
                dataOffset = end
            }
        }
    }

    fun formatSize(bytes: Long): String {
        if (bytes < 0) return "0 B"
        val units = arrayOf("B", "KiB", "MiB", "GiB", "TiB")
        var value = bytes.toDouble()
        var unit = 0
        while (value >= 1024.0 && unit + 1 < units.size) {
            value /= 1024.0
            unit++
        }
        return String.format(Locale.US, "%.1f %s", value, units[unit])
    }
}
