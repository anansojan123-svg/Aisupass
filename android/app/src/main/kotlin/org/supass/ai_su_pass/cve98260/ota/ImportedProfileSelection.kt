package org.supass.ai_su_pass.cve98260.ota

import android.content.Context

/**
 * GhostKey 用户文档的生效选择。
 *
 * 存储的是**文档名**而不是 release：同一 release 可以有多份文档，
 * 运行侧按这里选中的那份取用；未选择时由 [ImportedProfileStore] 的最近修改顺序决定。
 */
class ImportedProfileSelection(
    context: Context,
    prefsName: String = PREF_FILE,
) {

    private val prefs = context.applicationContext
        .getSharedPreferences(prefsName, Context.MODE_PRIVATE)

    fun activeName(): String? =
        prefs.getString(KEY_ACTIVE, null)?.takeIf { it.isNotEmpty() }

    fun setActiveName(name: String?) {
        prefs.edit().apply {
            if (name.isNullOrBlank()) remove(KEY_ACTIVE) else putString(KEY_ACTIVE, name)
        }.apply()
    }

    /** 删除文档后清掉选择；被删的不是当前选中时不动。 */
    fun clearIfActive(name: String) {
        if (activeName() == name) setActiveName(null)
    }

    fun clearIfActiveRenamed(from: String, to: String) {
        if (activeName() == from) setActiveName(to)
    }

    private companion object {
        const val PREF_FILE = "ghostkey_profile_selection"
        const val KEY_ACTIVE = "active_profile_name"
    }
}
