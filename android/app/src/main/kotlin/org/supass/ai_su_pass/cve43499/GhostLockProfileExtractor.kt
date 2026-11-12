package org.supass.ai_su_pass.cve43499

/**
 * GhostLock profile 提取的 JNI 入口。
 *
 * 与 DirtyFrag 共用 `libvrext.so`（同一个 Rust crate 提供两套入口），但本类
 * 只承载 GhostLock 的方法，不引用 `dirtyfrag` 包下的任何类型。
 *
 * 符号名由 Rust 侧 `#[no_mangle]` 决定，必须是
 * `Java_org_supass_ai_1su_1pass_cve43499_GhostLockProfileExtractor_nativeDeriveProfile`。
 */
internal object GhostLockProfileExtractor {

    init {
        System.loadLibrary("vrext")
    }

    /**
     * 阻塞到提取结束，返回 `{"ok":true,"release":...,"conf":...,"warnings":[...]}`
     * 或 `{"ok":false,"error":...}`。
     *
     * [workDir] 传缓存目录，Rust 会在其下建 `ghostlock-payload/` 放解包中间产物。
     */
    external fun nativeDeriveProfile(
        input: String,
        workDir: String,
        insecure: Boolean,
    ): String

    /**
     * 提取进度快照：`"<phase> <done> <total>"`。
     *
     * phase 0 = 下载（字节），1 = 解包与解析，2 = 完成；无总量的阶段 `total` 为 0。
     */
    external fun nativeProfileProgress(): String
}
