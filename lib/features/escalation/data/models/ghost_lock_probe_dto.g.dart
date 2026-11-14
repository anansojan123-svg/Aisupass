// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ghost_lock_probe_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GhostLockProbeDto _$GhostLockProbeDtoFromJson(Map<String, dynamic> json) =>
    _GhostLockProbeDto(
      ok: json['ok'] as bool? ?? false,
      release: json['release'] as String? ?? '',
      conf: json['conf'] as String? ?? '',
      warnings:
          (json['warnings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      bootPath: json['bootPath'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      kernelPhysLoad: json['kernelPhysLoad'] as String? ?? '',
      kernelPhysOffset: json['kernelPhysOffset'] as String? ?? '',
      physSource: json['physSource'] as String? ?? '',
      analysis: json['analysis'] as String? ?? '',
    );

Map<String, dynamic> _$GhostLockProbeDtoToJson(_GhostLockProbeDto instance) =>
    <String, dynamic>{
      'ok': instance.ok,
      'release': instance.release,
      'conf': instance.conf,
      'warnings': instance.warnings,
      'bootPath': instance.bootPath,
      'reason': instance.reason,
      'kernelPhysLoad': instance.kernelPhysLoad,
      'kernelPhysOffset': instance.kernelPhysOffset,
      'physSource': instance.physSource,
      'analysis': instance.analysis,
    };
