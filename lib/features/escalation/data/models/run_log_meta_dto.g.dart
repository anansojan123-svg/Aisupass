// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'run_log_meta_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RunLogMetaDto _$RunLogMetaDtoFromJson(Map<String, dynamic> json) =>
    _RunLogMetaDto(
      fileName: json['fileName'] as String? ?? '',
      runId: (json['runId'] as num?)?.toInt() ?? 0,
      startedAt: (json['startedAt'] as num?)?.toInt() ?? 0,
      result: json['result'] as String? ?? '',
      exitCode: (json['exitCode'] as num?)?.toInt() ?? -1,
      durationMs: (json['durationMs'] as num?)?.toInt() ?? 0,
      lineCount: (json['lineCount'] as num?)?.toInt() ?? -1,
      device: json['device'] as String? ?? '',
      kernel: json['kernel'] as String? ?? '',
      profile: json['profile'] as String? ?? '',
    );

Map<String, dynamic> _$RunLogMetaDtoToJson(_RunLogMetaDto instance) =>
    <String, dynamic>{
      'fileName': instance.fileName,
      'runId': instance.runId,
      'startedAt': instance.startedAt,
      'result': instance.result,
      'exitCode': instance.exitCode,
      'durationMs': instance.durationMs,
      'lineCount': instance.lineCount,
      'device': instance.device,
      'kernel': instance.kernel,
      'profile': instance.profile,
    };
