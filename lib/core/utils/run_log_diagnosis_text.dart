import 'package:Aisupass/core/utils/terminal_text_writer.dart';
import 'package:Aisupass/features/escalation/domain/models/run_log_diagnosis.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// 把 [RunLogDiagnosis] 渲染成终端行。
///
/// 与上游 `FailureDiagnoser.format()` 逐字对齐：
///   `<d> 诊断: {title}`
///   `<d>   可能原因: {cause}`
///   `<d>   建议: {suggestion}`
/// 上游的 `<d>` 即 [TerminalTextWriter.dim]。三段中文前缀走 l10n，
/// 代码内只保留 ASCII 空格缩进与样式常量。
extension RunLogDiagnosisText on RunLogDiagnosis {
  List<String> lines(AppLocalizations l10n) {
    final _DiagText text = _textOf(l10n);
    const String dim = TerminalTextWriter.dim;
    const String reset = TerminalTextWriter.reset;
    return <String>[
      '$dim ${l10n.ghostKeyRunLogDiagTitlePrefix(text.title)}$reset',
      for (final String cause in text.causes)
        '$dim   ${l10n.ghostKeyRunLogDiagCausePrefix(cause)}$reset',
      for (final String suggestion in text.suggestions)
        '$dim   ${l10n.ghostKeyRunLogDiagSuggestionPrefix(suggestion)}$reset',
    ];
  }

  _DiagText _textOf(AppLocalizations l10n) => switch (ruleId) {
    'calib_a_no_slide_candidate' => _DiagText(
      l10n.ghostKeyDiagCalibANoSlideCandidateTitle,
      <String>[
        l10n.ghostKeyDiagCalibANoSlideCandidateCause1,
        l10n.ghostKeyDiagCalibANoSlideCandidateCause2,
        l10n.ghostKeyDiagCalibANoSlideCandidateCause3,
        l10n.ghostKeyDiagCalibANoSlideCandidateCause4,
      ],
      <String>[
        l10n.ghostKeyDiagCalibANoSlideCandidateSuggestion1,
        l10n.ghostKeyDiagCalibANoSlideCandidateSuggestion2,
        l10n.ghostKeyDiagCalibANoSlideCandidateSuggestion3,
      ],
    ),
    'calib_a_no_kitimer_records' => _DiagText(
      l10n.ghostKeyDiagCalibANoKitimerRecordsTitle,
      <String>[
        l10n.ghostKeyDiagCalibANoKitimerRecordsCause1,
        l10n.ghostKeyDiagCalibANoKitimerRecordsCause2,
        l10n.ghostKeyDiagCalibANoKitimerRecordsCause3,
      ],
      <String>[
        l10n.ghostKeyDiagCalibANoKitimerRecordsSuggestion1,
        l10n.ghostKeyDiagCalibANoKitimerRecordsSuggestion2,
        l10n.ghostKeyDiagCalibANoKitimerRecordsSuggestion3,
      ],
    ),
    'calib_a_tracefs_unusable' => _DiagText(
      l10n.ghostKeyDiagCalibATracefsUnusableTitle,
      <String>[
        l10n.ghostKeyDiagCalibATracefsUnusableCause1,
        l10n.ghostKeyDiagCalibATracefsUnusableCause2,
        l10n.ghostKeyDiagCalibATracefsUnusableCause3,
      ],
      <String>[
        l10n.ghostKeyDiagCalibATracefsUnusableSuggestion1,
        l10n.ghostKeyDiagCalibATracefsUnusableSuggestion2,
        l10n.ghostKeyDiagCalibATracefsUnusableSuggestion3,
      ],
    ),
    'calib_b_no_matching_records' => _DiagText(
      l10n.ghostKeyDiagCalibBNoMatchingRecordsTitle,
      <String>[
        l10n.ghostKeyDiagCalibBNoMatchingRecordsCause1,
        l10n.ghostKeyDiagCalibBNoMatchingRecordsCause2,
      ],
      <String>[
        l10n.ghostKeyDiagCalibBNoMatchingRecordsSuggestion1,
        l10n.ghostKeyDiagCalibBNoMatchingRecordsSuggestion2,
      ],
    ),
    'calib_b_insufficient_samples' => _DiagText(
      l10n.ghostKeyDiagCalibBInsufficientSamplesTitle,
      <String>[
        l10n.ghostKeyDiagCalibBInsufficientSamplesCause1,
        l10n.ghostKeyDiagCalibBInsufficientSamplesCause2,
      ],
      <String>[
        l10n.ghostKeyDiagCalibBInsufficientSamplesSuggestion1,
        l10n.ghostKeyDiagCalibBInsufficientSamplesSuggestion2,
      ],
    ),
    'inject_residual_process' => _DiagText(
      l10n.ghostKeyDiagInjectResidualProcessTitle,
      <String>[l10n.ghostKeyDiagInjectResidualProcessCause1],
      <String>[l10n.ghostKeyDiagInjectResidualProcessSuggestion1],
    ),
    'inject_rootd_not_ready' => _DiagText(
      l10n.ghostKeyDiagInjectRootdNotReadyTitle,
      <String>[
        l10n.ghostKeyDiagInjectRootdNotReadyCause1,
        l10n.ghostKeyDiagInjectRootdNotReadyCause2,
      ],
      <String>[
        l10n.ghostKeyDiagInjectRootdNotReadySuggestion1,
        l10n.ghostKeyDiagInjectRootdNotReadySuggestion2,
      ],
    ),
    'inject_offset_table_missing' => _DiagText(
      l10n.ghostKeyDiagInjectOffsetTableMissingTitle,
      <String>[
        l10n.ghostKeyDiagInjectOffsetTableMissingCause1,
        l10n.ghostKeyDiagInjectOffsetTableMissingCause2,
      ],
      <String>[l10n.ghostKeyDiagInjectOffsetTableMissingSuggestion1],
    ),
    'inject_task_leak_failed' => _DiagText(
      l10n.ghostKeyDiagInjectTaskLeakFailedTitle,
      <String>[
        l10n.ghostKeyDiagInjectTaskLeakFailedCause1,
        l10n.ghostKeyDiagInjectTaskLeakFailedCause2,
        l10n.ghostKeyDiagInjectTaskLeakFailedCause3,
      ],
      <String>[
        l10n.ghostKeyDiagInjectTaskLeakFailedSuggestion1,
        l10n.ghostKeyDiagInjectTaskLeakFailedSuggestion2,
      ],
    ),
    'verify_failed' => _DiagText(
      l10n.ghostKeyDiagVerifyFailedTitle,
      <String>[
        l10n.ghostKeyDiagVerifyFailedCause1,
        l10n.ghostKeyDiagVerifyFailedCause2,
      ],
      <String>[
        l10n.ghostKeyDiagVerifyFailedSuggestion1,
        l10n.ghostKeyDiagVerifyFailedSuggestion2,
      ],
    ),
    'ksu_already_live' => _DiagText(
      l10n.ghostKeyDiagKsuAlreadyLiveTitle,
      <String>[l10n.ghostKeyDiagKsuAlreadyLiveCause1],
      <String>[
        l10n.ghostKeyDiagKsuAlreadyLiveSuggestion1,
        l10n.ghostKeyDiagKsuAlreadyLiveSuggestion2,
      ],
    ),
    'ksu_module_absent' => _DiagText(
      l10n.ghostKeyDiagKsuModuleAbsentTitle,
      <String>[
        l10n.ghostKeyDiagKsuModuleAbsentCause1,
        l10n.ghostKeyDiagKsuModuleAbsentCause2,
      ],
      <String>[
        l10n.ghostKeyDiagKsuModuleAbsentSuggestion1,
        l10n.ghostKeyDiagKsuModuleAbsentSuggestion2,
      ],
    ),
    'ksu_ksud_missing' => _DiagText(
      l10n.ghostKeyDiagKsuKsudMissingTitle,
      <String>[
        l10n.ghostKeyDiagKsuKsudMissingCause1,
        l10n.ghostKeyDiagKsuKsudMissingCause2,
      ],
      <String>[l10n.ghostKeyDiagKsuKsudMissingSuggestion1],
    ),
    'host_shizuku_unavailable' => _DiagText(
      l10n.ghostKeyDiagHostShizukuUnavailableTitle,
      <String>[
        l10n.ghostKeyDiagHostShizukuUnavailableCause1,
        l10n.ghostKeyDiagHostShizukuUnavailableCause2,
      ],
      <String>[
        l10n.ghostKeyDiagHostShizukuUnavailableSuggestion1,
        l10n.ghostKeyDiagHostShizukuUnavailableSuggestion2,
      ],
    ),
    'fallback_exit_2' => _DiagText(
      l10n.ghostKeyDiagFallbackExit2Title,
      <String>[
        l10n.ghostKeyDiagFallbackExit2Cause1,
        l10n.ghostKeyDiagFallbackExit2Cause2,
        l10n.ghostKeyDiagFallbackExit2Cause3,
        l10n.ghostKeyDiagFallbackExit2Cause4,
      ],
      <String>[
        l10n.ghostKeyDiagFallbackExit2Suggestion1,
        l10n.ghostKeyDiagFallbackExit2Suggestion2,
        l10n.ghostKeyDiagFallbackExit2Suggestion3,
      ],
    ),
    // `fallback_generic` 与任何未知 ruleId 都落到这里（兜底，不抛异常）。
    _ => _DiagText(
      l10n.ghostKeyDiagFallbackGenericTitle(exitCode),
      <String>[l10n.ghostKeyDiagFallbackGenericCause1],
      <String>[
        l10n.ghostKeyDiagFallbackGenericSuggestion1,
        l10n.ghostKeyDiagFallbackGenericSuggestion2,
      ],
    ),
  };
}

class _DiagText {
  const _DiagText(this.title, this.causes, this.suggestions);

  final String title;
  final List<String> causes;
  final List<String> suggestions;
}
