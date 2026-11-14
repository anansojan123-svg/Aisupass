package org.supass.ai_su_pass.cve98260

import android.util.Log
import org.supass.ai_su_pass.cve98260.ota.ImportedProfileSelection
import org.supass.ai_su_pass.cve98260.ota.ImportedProfileStore

/**
 * 内置内核表目录。
 *
 * 从 assets/kernel_profiles 下各 conf 加载所有 profile（HOCON 子集），
 * 按 uname -r **精确匹配**：内置 profile 的 release 与设备实际 release 完全一致才命中。
 *
 * 不做 KMI（android15-8）前缀回退——同 KMI 的不同内核构建
 * （如 6.6.118 vs 6.6.127，或 9bc34d5b0c79 vs gc4127a25dcf3 这类不同厂商/分支构建）
 * 的 do_timer_create / prepare_creds 等符号地址并不稳定，回退会套用错误的
 * timer_link / cred_link 偏移，导致 calib_a 解 KASLR 失败（日志中 exit=2）。
 * 没有精确匹配的机型应导入对应 boot.img 生成 profile，而不是复用其它机型的。
 *
 * 用户文档与 GhostLock 一致：文件名即文档名，同 release 可以有多份；
 * 选中的那份优先，未选中时取最近修改的一份。
 *
 * 生效来源二选一（用户文档 / 内置表），都未指定时才自动匹配。
 */
class BuiltinProfileCatalog(
    private val loader: AssetConfigLoader,
    private val userStore: ImportedProfileStore? = null,
    private val selection: ImportedProfileSelection? = null,
) {

    private val profiles: List<KernelProfile> by lazy { loadAll() }

    fun all(): List<KernelProfile> = profiles

    /** 按 release 读内置 profile 的原始 HOCON 文本；不存在返回空串。 */
    fun readRaw(release: String): String {
        val file = loadIndex()[release] ?: return ""
        return loader.read("$DIR/$file").orEmpty()
    }

    /** 当前选中的用户文档名；未选择返回空串。 */
    fun activeUserName(): String = selection?.activeName().orEmpty()

    /**
     * 来源优先级：选中的用户文档 → 选中的内置表 → 最近修改的同 release 文档 → 内置表。
     *
     * 选中的用户文档与设备 release 不符时如实返回 null（不回退内置表）；
     * 选中的内置表按所选 release 取用，与 GhostLock 的 profileRelease 一致。
     */
    fun match(release: String): KernelProfile? {
        reconcileActiveSource()
        val store = userStore
        if (store != null) {
            val active = selection?.activeName()
            if (!active.isNullOrEmpty()) {
                val chosen = store.loadByName(active)
                if (chosen != null) {
                    return chosen.takeIf { it.release == release }
                }
                /* 选中的文档已被删除或损坏：清掉选择，回到自动匹配。 */
                Log.w(TAG, "选中的文档不可用，清除选择: $active")
                selection?.setActiveName(null)
            }
        }
        val builtin = selection?.activeBuiltin()
        if (!builtin.isNullOrEmpty()) {
            return profiles.firstOrNull { it.release == builtin }
        }
        if (store != null) {
            store.list()
                .firstOrNull { it.release == release && !it.parseError }
                ?.let { store.loadByName(it.name) }
                ?.let { return it }
        }
        return profiles.firstOrNull { it.release == release }
    }

    /**
     * 收敛历史遗留的生效来源，与 GhostLock 的 `reconcileActiveSource` 一致：
     * 双来源并存时保留用户文档，内置表选择只在用户层为空时才起作用。
     */
    private fun reconcileActiveSource() {
        val active = selection ?: return
        if (active.activeName() == null) return
        if (active.activeBuiltin() == null) return
        active.setActiveBuiltin(null)
    }

    private fun loadAll(): List<KernelProfile> {
        val index = loadIndex()
        return index.mapNotNull { (release, file) ->
            val text = loader.read("$DIR/$file") ?: run {
                Log.w(TAG, "读取 $file 失败")
                null
            } ?: return@mapNotNull null
            runCatching { ProfileDocument.parse(text).toKernelProfile() }
                .onFailure { Log.w(TAG, "解析 $file 失败: ${it.message}") }
                .getOrNull()
        }
    }

    /** index.conf 行格式：`release  file  [recommendShizuku]`，`#` 注释。 */
    private fun loadIndex(): Map<String, String> {
        val text = loader.read("$DIR/index.conf") ?: return emptyMap()
        val map = linkedMapOf<String, String>()
        text.lineSequence().forEach { raw ->
            val line = raw.substringBefore('#').trim()
            if (line.isEmpty()) return@forEach
            val parts = line.split(Regex("\\s+"))
            if (parts.size >= 2) map[parts[0]] = parts[1]
        }
        return map
    }

    companion object {
        private const val TAG = "BuiltinProfileCatalog"
        const val DIR = "kernel_profiles"
    }
}
