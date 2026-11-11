import 'package:Aisupass/features/escalation/domain/models/run_log_diagnosis.dart';
import 'package:Aisupass/generated/cve98260.g.dart' as pigeon;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'run_log_diagnosis_dto.freezed.dart';
part 'run_log_diagnosis_dto.g.dart';

/// 归因结果传输对象。`exitCode` 原生不回（它在入参里），由 Impl 回填。
@freezed
abstract class RunLogDiagnosisDto with _$RunLogDiagnosisDto {
  const RunLogDiagnosisDto._();

  const factory RunLogDiagnosisDto({
    @Default('') String ruleId,
    @Default('') String stage,
    @Default(<String>[]) List<String> evidence,
    @Default(-1) int exitCode,
  }) = _RunLogDiagnosisDto;

  factory RunLogDiagnosisDto.fromJson(Map<String, dynamic> json) =>
      _$RunLogDiagnosisDtoFromJson(json);

  /// Pigeon 传输对象 -> DTO。原生 `stage` 为 null（不限阶段）时落 `''`。
  factory RunLogDiagnosisDto.fromNative(
    pigeon.RunLogDiagnosisDto dto, {
    required int exitCode,
  }) => RunLogDiagnosisDto(
    ruleId: dto.ruleId,
    stage: dto.stage ?? '',
    evidence: dto.evidence,
    exitCode: exitCode,
  );

  RunLogDiagnosis toEntity() => RunLogDiagnosis(
    ruleId: ruleId,
    stage: stage,
    evidence: evidence,
    exitCode: exitCode,
  );
}
