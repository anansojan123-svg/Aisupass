// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ghost_lock_probe_progress_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GhostLockProbeProgressDto _$GhostLockProbeProgressDtoFromJson(
  Map<String, dynamic> json,
) => _GhostLockProbeProgressDto(
  phase: (json['phase'] as num?)?.toInt() ?? 0,
  done: (json['done'] as num?)?.toInt() ?? 0,
  total: (json['total'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$GhostLockProbeProgressDtoToJson(
  _GhostLockProbeProgressDto instance,
) => <String, dynamic>{
  'phase': instance.phase,
  'done': instance.done,
  'total': instance.total,
};
