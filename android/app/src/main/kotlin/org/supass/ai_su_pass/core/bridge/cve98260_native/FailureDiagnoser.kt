package org.supass.ai_su_pass.core.bridge.cve98260_native

/**
 * Terminal failure attributor, ported from upstream FailureDiagnoser.kt.
 *
 * The 14 rule entries, their order, the stage gate, the reversed scan and the
 * `error|failed` pre-filter are kept verbatim. Only the payload changed: instead
 * of localised title/causes/suggestions we return a stable [Diagnosis.ruleId]
 * plus the matched raw log lines. Localisation lives in the Flutter ARB files.
 */
object FailureDiagnoser {

    /**
     * One attribution result.
     *
     * @param ruleId stable key, mapped to l10n strings on the Dart side
     * @param stage  failing stage label, null when unknown / host level
     * @param evidence matched raw log lines, oldest first, at most [MAX_EVIDENCE]
     */
    data class Diagnosis(
        val ruleId: String,
        val stage: String?,
        val evidence: List<String>,
    )

    /** One rule entry: (optional stage gate, keyword regex, result ruleId). */
    private class Rule(
        val id: String,
        val stage: String?,
        val keyword: Regex,
    )

    private const val MAX_EVIDENCE = 3

    private val STAGE_TAG = Regex("\\[([a-z_]+)]")

    // Order is the match priority, exactly as upstream.
    private val RULES = listOf(
        // calib_a: KASLR slide
        Rule("calib_a_no_slide_candidate", "calib_a", Regex("no plausible slide candidate|no k_itimer records found")),
        Rule("calib_a_no_kitimer_records", "calib_a", Regex("no k_itimer records found")),
        Rule("calib_a_tracefs_unusable", "calib_a", Regex("tracefs not writable|cannot attach|trace_pipe_raw|cannot read")),
        // calib_b: page offset
        Rule("calib_b_no_matching_records", "calib_b", Regex("no matching k_itimer records|slide may be wrong")),
        Rule("calib_b_insufficient_samples", "calib_b", Regex("insufficient samples|no candidate base hits")),
        // inject
        Rule("inject_residual_process", null, Regex("previous round left native process")),
        Rule("inject_rootd_not_ready", "inject", Regex("rootd not ready in time")),
        Rule("inject_offset_table_missing", "inject", Regex("kernel offset table not loaded|profile")),
        // task_struct leak
        Rule("inject_task_leak_failed", "task", Regex("leak failed")),
        // verify
        Rule("verify_failed", "verify", Regex("verify failed")),
        // ksu takeover
        Rule("ksu_already_live", "ksu", Regex("already live")),
        Rule("ksu_module_absent", "ksu", Regex("no kernelsu|/proc/modules")),
        Rule("ksu_ksud_missing", "ksu", Regex("ksud not found")),
        // host layer
        Rule("host_shizuku_unavailable", null, Regex("Shizuku not running|Shizuku.*permission")),
    )

    /**
     * Attributing one run. Scans backwards: failures usually sit at the tail.
     *
     * @return null when nothing matches, caller then uses [fallback]
     */
    fun diagnose(logLines: List<String>): Diagnosis? {
        // Match on error/failure lines only, so progress lines like "profile loaded" never hit.
        val errorLines = logLines.filter {
            it.contains("error", ignoreCase = true) || it.contains("failed", ignoreCase = true)
        }
        for (line in errorLines.asReversed()) {
            val stage = STAGE_TAG.find(line)?.groupValues?.get(1)
            for (rule in RULES) {
                if (rule.stage != null && rule.stage != stage) continue
                if (!rule.keyword.containsMatchIn(line)) continue
                return Diagnosis(rule.id, stageOf(rule.id), collectEvidence(errorLines, rule, line))
            }
        }
        return null
    }

    /** Generic fallback when no dedicated rule hits. exit=2 gets a KASLR specific one. */
    fun fallback(exitCode: Int): Diagnosis =
        if (exitCode == 2) {
            Diagnosis("fallback_exit_2", null, emptyList())
        } else {
            Diagnosis("fallback_generic", null, listOf("exit=$exitCode"))
        }

    /** Same rule, up to [MAX_EVIDENCE] matched lines, oldest first. */
    private fun collectEvidence(errorLines: List<String>, rule: Rule, lastHit: String): List<String> {
        val hits = ArrayList<String>(MAX_EVIDENCE)
        hits.add(lastHit)
        // Walk the older lines, keep only same-rule hits.
        val index = errorLines.lastIndexOf(lastHit)
        var i = index - 1
        while (i >= 0 && hits.size < MAX_EVIDENCE) {
            val line = errorLines[i]
            val stage = STAGE_TAG.find(line)?.groupValues?.get(1)
            if ((rule.stage == null || rule.stage == stage) && rule.keyword.containsMatchIn(line)) {
                hits.add(0, line)
            }
            i--
        }
        return hits
    }

    private fun stageOf(ruleId: String): String? = when (ruleId) {
        "calib_a_no_slide_candidate", "calib_a_no_kitimer_records", "calib_a_tracefs_unusable" -> "calib_a"
        "calib_b_no_matching_records", "calib_b_insufficient_samples" -> "calib_b"
        "inject_residual_process", "inject_rootd_not_ready",
        "inject_offset_table_missing", "inject_task_leak_failed" -> "inject"
        "verify_failed" -> "verify"
        "ksu_already_live", "ksu_module_absent", "ksu_ksud_missing" -> "ksu"
        else -> null
    }
}
