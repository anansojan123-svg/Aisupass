// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handoff_outcome_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HandoffOutcomeDto _$HandoffOutcomeDtoFromJson(Map<String, dynamic> json) =>
    _HandoffOutcomeDto(
      kind:
          $enumDecodeNullable(_$HandoffKindEnumMap, json['kind']) ??
          HandoffKind.failed,
      managerPackage: json['managerPackage'] as String? ?? '',
      managerDisplayName: json['managerDisplayName'] as String? ?? '',
      managerIcon:
          (json['managerIcon'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
      ksudPath: json['ksudPath'] as String? ?? '',
      exitCode: (json['exitCode'] as num?)?.toInt() ?? -1,
      output: json['output'] as String? ?? '',
      durationMs: (json['durationMs'] as num?)?.toInt() ?? 0,
      timedOut: json['timedOut'] as bool? ?? false,
    );

Map<String, dynamic> _$HandoffOutcomeDtoToJson(_HandoffOutcomeDto instance) =>
    <String, dynamic>{
      'kind': _$HandoffKindEnumMap[instance.kind]!,
      'managerPackage': instance.managerPackage,
      'managerDisplayName': instance.managerDisplayName,
      'managerIcon': instance.managerIcon,
      'ksudPath': instance.ksudPath,
      'exitCode': instance.exitCode,
      'output': instance.output,
      'durationMs': instance.durationMs,
      'timedOut': instance.timedOut,
    };

const _$HandoffKindEnumMap = {
  HandoffKind.success: 'success',
  HandoffKind.managerMissing: 'managerMissing',
  HandoffKind.noSu: 'noSu',
  HandoffKind.failed: 'failed',
};
