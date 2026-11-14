package org.supass.ai_su_pass.cve43499

import org.supass.ai_su_pass.cve43499.profile.NativeProfileDocument

/**
 * GhostLock 内核表：`uname -r` → GLK1 blob。
 *
 * 命中判定仍在本类（内置索引 + 用户导入文档）；合并、校验与编码统一交给
 * [GhostLockProfileController]，避免两套逻辑漂移。
 *
 * 不做 KMI 前缀回退：同 KMI 不同构建的 `task_struct` / `cred` 偏移不同，
 * 回退会套错偏移（上游 79 份表就是逐构建收录的）。
 */
internal class GhostLockCatalog(private val controller: GhostLockProfileController) {

    /** 命中结果：release、route token、可直接送 native 的 GLK1 字节。 */
    class Match(val release: String, val route: String, val blob: ByteArray)

    /** 内置表里所有 release，供 UI 展示「表内条数」。 */
    fun releases(): List<String> = controller.builtinReleases()

    /**
     * 解析并编码。
     *
     * 命中判定交给 [GhostLockProfileController.load]：选了哪份表就用哪份，
     * 不在运行侧另做 release 拦截。解析不出来时才把具体原因透出去。
     *
     * [safeMode] 为 true 时把 `meta.safe_mode` 改写为 1：v2 没有固定槽位，
     * 编码后按节扫描重写。
     */
    fun match(release: String, safeMode: Boolean): Result<Match> = runCatching {
        val view = controller.load(release)
        /* 解析失败的具体原因（文档缺失、include 解析失败等）优先透出。 */
        require(view.hasProfile) { controller.resolveError() ?: "noProfile" }
        require(view.route.isNotEmpty()) { "missingRoute" }
        val encoded = controller.nativeDocument(view) ?: error("encodeFailed")
        val blob = if (safeMode) {
            NativeProfileDocument.patchSafeMode(encoded) ?: error("safeModePatchFailed")
        } else {
            encoded
        }
        Match(release = release, route = view.route, blob = blob)
    }
}
