// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ghost_lock_outcome_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GhostLockOutcomeDto _$GhostLockOutcomeDtoFromJson(Map<String, dynamic> json) =>
    _GhostLockOutcomeDto(
      sessionId: json['sessionId'] as String? ?? '',
      output: json['output'] as String? ?? '',
      exitCode: (json['exitCode'] as num?)?.toInt() ?? -1,
      durationMs: (json['durationMs'] as num?)?.toInt() ?? 0,
      timedOut: json['timedOut'] as bool? ?? false,
      failure: json['failure'] as String? ?? '',
      kind:
          $enumDecodeNullable(_$GhostLockKindEnumMap, json['kind']) ??
          GhostLockKind.running,
      log: json['log'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
    );

Map<String, dynamic> _$GhostLockOutcomeDtoToJson(
  _GhostLockOutcomeDto instance,
) => <String, dynamic>{
  'sessionId': instance.sessionId,
  'output': instance.output,
  'exitCode': instance.exitCode,
  'durationMs': instance.durationMs,
  'timedOut': instance.timedOut,
  'failure': instance.failure,
  'kind': _$GhostLockKindEnumMap[instance.kind]!,
  'log': instance.log,
  'reason': instance.reason,
};

const _$GhostLockKindEnumMap = {
  GhostLockKind.running: 'running',
  GhostLockKind.notStarted: 'notStarted',
  GhostLockKind.succeeded: 'succeeded',
  GhostLockKind.alreadyRooted: 'alreadyRooted',
  GhostLockKind.tempRootOnly: 'tempRootOnly',
  GhostLockKind.seccompBlocked: 'seccompBlocked',
  GhostLockKind.ksuFailed: 'ksuFailed',
  GhostLockKind.w1Failed: 'w1Failed',
  GhostLockKind.w2Failed: 'w2Failed',
  GhostLockKind.w3Failed: 'w3Failed',
  GhostLockKind.releaseMismatch: 'releaseMismatch',
  GhostLockKind.dirtyRace: 'dirtyRace',
  GhostLockKind.timedOut: 'timedOut',
  GhostLockKind.failed: 'failed',
};
