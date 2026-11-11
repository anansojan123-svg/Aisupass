package org.supass.ai_su_pass.cve98260.ota

import android.util.Log
import java.io.IOException
import java.net.HttpURLConnection
import java.net.URL

/**
 * Reads byte ranges of a remote file over HTTP Range requests using standard HttpURLConnection.
 */
class HttpRangeReader(
    private val connectTimeoutMs: Int = 15000,
    private val readTimeoutMs: Int = 30000,
    private val userAgent: String = "Dalvik/2.1.0 (Linux; W; Android 17; Android Build/CP2A.260605.016)"
) {

    /** 最近一次响应的 Content-Type，仅用于排障日志。 */
    var lastContentType: String? = null
        private set

    /** 最近一次响应是否回 206（说明服务端认了 Range）。 */
    var lastPartialContent: Boolean = false
        private set

    /** 最近一次响应的 HTTP 状态码，仅用于排障日志。 */
    var lastStatusCode: Int = 0
        private set

    private fun openConnectionWithRedirects(
        urlStr: String, headers: Map<String, String>
    ): HttpURLConnection {
        var currentUrl = urlStr
        var redirects = 0
        Log.d(TAG, "open url=$currentUrl headers=$headers")
        while (redirects < 6) {
            val url = URL(currentUrl)
            val conn = url.openConnection() as HttpURLConnection
            conn.connectTimeout = connectTimeoutMs
            conn.readTimeout = readTimeoutMs
            conn.instanceFollowRedirects = true
            conn.setRequestProperty("User-Agent", userAgent)
            for ((k, v) in headers) {
                conn.setRequestProperty(k, v)
            }
            applyVendorHeaders(conn, currentUrl)
            conn.connect()
            val code = conn.responseCode
            lastStatusCode = code
            lastContentType = conn.contentType
            lastPartialContent = code == HttpURLConnection.HTTP_PARTIAL
            Log.d(TAG, "response code=$code contentType=$lastContentType url=$currentUrl")
            if (code in 301..303 || code in 307..308) {
                val location = conn.getHeaderField("Location")
                conn.disconnect()
                Log.d(TAG, "redirect -> $location")
                if (!location.isNullOrBlank()) {
                    currentUrl = if (location.startsWith(
                            "http://", ignoreCase = true
                        ) || location.startsWith("https://", ignoreCase = true)
                    ) {
                        location
                    } else {
                        URL(url, location).toString()
                    }
                    redirects++
                    continue
                }
            }
            return conn
        }
        throw IOException("Too many redirects: $urlStr")
    }

    fun fileLength(url: String): Long? {
        return try {
            val conn = openConnectionWithRedirects(url, mapOf("Range" to "bytes=0-0"))
            try {
                val contentRange = conn.getHeaderField("Content-Range")
                Log.d(TAG, "content-range=$contentRange content-length=${conn.contentLengthLong}")
                if (contentRange != null) {
                    val slash = contentRange.lastIndexOf('/')
                    if (slash != -1) {
                        contentRange.substring(slash + 1).trim().toLongOrNull()?.let {
                            if (it > 0) {
                                Log.d(TAG, "file length (from Content-Range)=$it")
                                return it
                            }
                        }
                    }
                }
                val length = conn.contentLengthLong
                if (length > 0) {
                    Log.d(TAG, "file length (from Content-Length)=$length")
                    return length
                }
                Log.w(TAG, "cannot determine file length: no Content-Range and no Content-Length")
                null
            } finally {
                conn.disconnect()
            }
        } catch (e: Exception) {
            Log.w(TAG, "fileLength failed url=$url: ${e.javaClass.simpleName}: ${e.message}")
            null
        }
    }

    fun read(url: String, start: Long, size: Int): ByteArray? {
        if (size == 0) return ByteArray(0)
        if (size < 0 || start < 0) {
            Log.w(TAG, "read rejected: start=$start size=$size")
            return null
        }

        val end = start + size - 1
        return try {
            Log.d(TAG, "read bytes=$start-$end ($size B)")
            val conn = openConnectionWithRedirects(url, mapOf("Range" to "bytes=$start-$end"))
            try {
                val code = conn.responseCode
                if (code == 200 && start > 0) {
                    // Server ignored the Range header and sent from offset 0
                    Log.w(TAG, "server ignored Range header (200 for start=$start), giving up")
                    return null
                }
                if (code !in 200..299) {
                    Log.w(TAG, "read failed: http code=$code for range $start-$end")
                    return null
                }
                val stream = conn.inputStream
                val buffer = ByteArray(size)
                var totalRead = 0
                while (totalRead < size) {
                    val count = stream.read(buffer, totalRead, size - totalRead)
                    if (count == -1) break
                    totalRead += count
                }
                if (totalRead != size) {
                    Log.w(TAG, "short read: expected=$size actual=$totalRead start=$start")
                }
                if (totalRead == size) buffer else buffer.copyOf(totalRead)
            } finally {
                conn.disconnect()
            }
        } catch (e: Exception) {
            Log.w(TAG, "read failed range=$start-$end: ${e.javaClass.simpleName}: ${e.message}")
            null
        }
    }

    /**
     * OPPO/一加的 `downloadCheck` 是鉴权中转：不带这两个头会直接返回 92 字节的
     * JSON 错误体而不是 302 跳转到真实 CDN，表现为「不是 OTA zip」。
     */
    private fun applyVendorHeaders(conn: HttpURLConnection, url: String) {
        if (url.contains("/downloadCheck", ignoreCase = true)) {
            conn.setRequestProperty("userId", "oplus-ota|16002018")
            conn.setRequestProperty("User-Agent", "okhttp/3.12.12")
        }
    }

    private companion object {
        const val TAG = "GhostKeyOtaHttp"
    }
}
