// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'run_log_diagnosis_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RunLogDiagnosisDto _$RunLogDiagnosisDtoFromJson(Map<String, dynamic> json) =>
    _RunLogDiagnosisDto(
      ruleId: json['ruleId'] as String? ?? '',
      stage: json['stage'] as String? ?? '',
      evidence:
          (json['evidence'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      exitCode: (json['exitCode'] as num?)?.toInt() ?? -1,
    );

Map<String, dynamic> _$RunLogDiagnosisDtoToJson(_RunLogDiagnosisDto instance) =>
    <String, dynamic>{
      'ruleId': instance.ruleId,
      'stage': instance.stage,
      'evidence': instance.evidence,
      'exitCode': instance.exitCode,
    };
