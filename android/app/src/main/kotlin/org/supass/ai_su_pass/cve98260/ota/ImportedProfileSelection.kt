package org.supass.ai_su_pass.cve98260.ota

import android.content.Context

/**
 * GhostKey 内核表的生效选择，与 GhostLock 一致分为两个互斥来源：
 * 用户文档（存文档名，同一 release 可以有多份）与内置表（存 release）。
 *
 * 两者都为空时由 [ImportedProfileStore] 的最近修改顺序 / 内置表精确匹配决定。
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

    fun activeBuiltin(): String? =
        prefs.getString(KEY_ACTIVE_BUILTIN, null)?.takeIf { it.isNotEmpty() }

    fun setActiveBuiltin(release: String?) {
        prefs.edit().apply {
            if (release.isNullOrBlank()) remove(KEY_ACTIVE_BUILTIN)
            else putString(KEY_ACTIVE_BUILTIN, release)
        }.apply()
    }

    private companion object {
        const val PREF_FILE = "ghostkey_profile_selection"
        const val KEY_ACTIVE = "active_profile_name"
        const val KEY_ACTIVE_BUILTIN = "active_builtin_release"
    }
}
