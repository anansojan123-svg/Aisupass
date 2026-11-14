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
     * 阻塞到提取结束，返回 `{"ok":true,...,"analysis":"..."}` 或
     * `{"ok":false,"error":...,"analysis":...}`。
     *
     * [workDir] 传缓存目录，Rust 会在其下建 `ghostlock-payload/` 放解包中间产物。
     * [xblPath] / [uefiPath] / [vendorBootPath] 是可选的附加镜像路径，空串表示
     * 没有；用于补齐 `kernel_phys_load`（vendor_boot 另给 `kernel_phys_offset`）。
     * [phys] 是用户手填的物理装载基址（`0x` 前缀或十进制），空串表示不指定。
     * [kallsymsPath] / [iomemPath] 是外部文本文件，空串表示自动获取。
     * [route] 强制路由，空串表示自动推荐。
     */
    external fun nativeDeriveProfile(
        input: String,
        workDir: String,
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
    ): String

    /**
     * 提取进度快照：`"<phase> <done> <total>"`。
     *
     * phase 0 = 下载（字节），1 = 解包与解析，2 = 完成；无总量的阶段 `total` 为 0。
     */
    external fun nativeProfileProgress(): String
}
