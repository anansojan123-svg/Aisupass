package org.supass.ai_su_pass.cve43499

import android.content.Context
import org.supass.ai_su_pass.cve43499.profile.ValueMap
import org.supass.ai_su_pass.cve43499.profile.asValueMap
import org.supass.ai_su_pass.cve43499.profile.valueMapOf
import org.supass.ai_su_pass.cve98260.HoconSupport

/**
 * sparse override 的持久化：每个 release 一份，整体以 HOCON 存进偏好。
 *
 * 用 HOCON 而不是 JSON：取值模型本来就是 [ValueMap]，渲染与解析都复用
 * [HoconSupport]，不引入第二种序列化。
 */
internal class GhostLockProfileEditStore(context: Context) {

    private val prefs = context.applicationContext
        .getSharedPreferences(PREF_FILE, Context.MODE_PRIVATE)

    fun read(release: String): ValueMap = readAll()[release].asValueMap() ?: valueMapOf()

    fun write(release: String, override: ValueMap) {
        val all = readAll()
        if (override.isEmpty()) all.remove(release) else all[release] = override
        prefs.edit().putString(KEY_OVERRIDES, HoconSupport.render(all)).apply()
    }

    fun activeUserProfile(): String? =
        prefs.getString(KEY_ACTIVE_USER, null)?.takeIf { it.isNotEmpty() }

    fun setActiveUserProfile(name: String?) {
        prefs.edit().apply {
            if (name.isNullOrBlank()) remove(KEY_ACTIVE_USER) else putString(KEY_ACTIVE_USER, name)
        }.apply()
    }

    /** 删除文档后清掉选择；被删的不是当前选中时不动。 */
    fun clearActiveUserProfileIf(name: String) {
        if (activeUserProfile() == name) setActiveUserProfile(null)
    }

    fun activeBuiltinRelease(): String? =
        prefs.getString(KEY_ACTIVE_BUILTIN, null)?.takeIf { it.isNotEmpty() }

    fun setActiveBuiltinRelease(release: String?) {
        prefs.edit().apply {
            if (release.isNullOrBlank()) remove(KEY_ACTIVE_BUILTIN)
            else putString(KEY_ACTIVE_BUILTIN, release)
        }.apply()
    }

    private fun readAll(): ValueMap {
        val raw = prefs.getString(KEY_OVERRIDES, null) ?: return valueMapOf()
        return runCatching { HoconSupport.parseValue(raw).asValueMap() ?: valueMapOf() }
            .getOrDefault(valueMapOf())
    }

    private companion object {
        const val PREF_FILE = "ghostlock_profile_edit"
        const val KEY_OVERRIDES = "profile_overrides"
        const val KEY_ACTIVE_USER = "active_user_profile"
        const val KEY_ACTIVE_BUILTIN = "active_builtin_release"
    }
}
