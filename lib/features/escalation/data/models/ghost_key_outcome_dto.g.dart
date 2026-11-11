// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ghost_key_outcome_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GhostKeyOutcomeDto _$GhostKeyOutcomeDtoFromJson(Map<String, dynamic> json) =>
    _GhostKeyOutcomeDto(
      sessionId: json['sessionId'] as String? ?? '',
      output: json['output'] as String? ?? '',
      exitCode: (json['exitCode'] as num?)?.toInt() ?? -1,
      timedOut: json['timedOut'] as bool? ?? false,
      durationMs: (json['durationMs'] as num?)?.toInt() ?? 0,
      failure: json['failure'] as String? ?? '',
      kind:
          $enumDecodeNullable(_$GhostKeyKindEnumMap, json['kind']) ??
          GhostKeyKind.running,
      log: json['log'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      fraction: (json['fraction'] as num?)?.toDouble() ?? 0.0,
      stageStatuses:
          (json['stageStatuses'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$GhostKeyStageStatusEnumMap, e))
              .toList() ??
          const <GhostKeyStageStatus>[],
      stageDurations:
          (json['stageDurations'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
    );

Map<String, dynamic> _$GhostKeyOutcomeDtoToJson(_GhostKeyOutcomeDto instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'output': instance.output,
      'exitCode': instance.exitCode,
      'timedOut': instance.timedOut,
      'durationMs': instance.durationMs,
      'failure': instance.failure,
      'kind': _$GhostKeyKindEnumMap[instance.kind]!,
      'log': instance.log,
      'reason': instance.reason,
      'fraction': instance.fraction,
      'stageStatuses': instance.stageStatuses
          .map((e) => _$GhostKeyStageStatusEnumMap[e]!)
          .toList(),
      'stageDurations': instance.stageDurations,
    };

const _$GhostKeyKindEnumMap = {
  GhostKeyKind.running: 'running',
  GhostKeyKind.notStarted: 'notStarted',
  GhostKeyKind.succeeded: 'succeeded',
  GhostKeyKind.degraded: 'degraded',
  GhostKeyKind.calibFailed: 'calibFailed',
  GhostKeyKind.pageOffsetFailed: 'pageOffsetFailed',
  GhostKeyKind.injectFailed: 'injectFailed',
  GhostKeyKind.verifyFailed: 'verifyFailed',
  GhostKeyKind.ksuFailed: 'ksuFailed',
  GhostKeyKind.timedOut: 'timedOut',
  GhostKeyKind.failed: 'failed',
};

const _$GhostKeyStageStatusEnumMap = {
  GhostKeyStageStatus.pending: 'pending',
  GhostKeyStageStatus.running: 'running',
  GhostKeyStageStatus.success: 'success',
  GhostKeyStageStatus.degraded: 'degraded',
  GhostKeyStageStatus.failed: 'failed',
  GhostKeyStageStatus.skipped: 'skipped',
};
