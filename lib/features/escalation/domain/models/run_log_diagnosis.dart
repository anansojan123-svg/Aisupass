import 'package:freezed_annotation/freezed_annotation.dart';

part 'run_log_diagnosis.freezed.dart';

/// 一次失败归因的结果。
///
/// 只带规则码与原始证据行，**不含任何可读文案**——文案由
/// `run_log_diagnosis_text.dart` 按 l10n 渲染。
@freezed
abstract class RunLogDiagnosis with _$RunLogDiagnosis {
  const RunLogDiagnosis._();

  const factory RunLogDiagnosis({
    required String ruleId,
    required String stage,
    required List<String> evidence,
    required int exitCode,
  }) = _RunLogDiagnosis;

  /// 原生 `ruleId` 为空表示「连规则都没跑到」，理论上不会出现。
  bool get isEmpty => ruleId.isEmpty;

  /// `stage` 为空串表示「该规则不限阶段」（原生侧 `stage == null` 落到这里）。
  bool get anyStage => stage.isEmpty;

  /// 14 条专用规则之外的两条兜底。
  bool get isFallback => ruleId.startsWith('fallback_');
}
