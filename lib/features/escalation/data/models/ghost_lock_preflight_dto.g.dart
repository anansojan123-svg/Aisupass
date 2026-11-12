// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ghost_lock_preflight_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GhostLockPreflightDto _$GhostLockPreflightDtoFromJson(
  Map<String, dynamic> json,
) => _GhostLockPreflightDto(
  adbConnected: json['adbConnected'] as bool? ?? false,
  shellUid: (json['shellUid'] as num?)?.toInt() ?? -1,
  seccomp: (json['seccomp'] as num?)?.toInt() ?? -1,
  release: json['release'] as String? ?? '',
  profileRelease: json['profileRelease'] as String? ?? '',
  route: json['route'] as String? ?? '',
  binaryPresent: json['binaryPresent'] as bool? ?? false,
  ksudPath: json['ksudPath'] as String? ?? '',
  profileError: json['profileError'] as String? ?? '',
);

Map<String, dynamic> _$GhostLockPreflightDtoToJson(
  _GhostLockPreflightDto instance,
) => <String, dynamic>{
  'adbConnected': instance.adbConnected,
  'shellUid': instance.shellUid,
  'seccomp': instance.seccomp,
  'release': instance.release,
  'profileRelease': instance.profileRelease,
  'route': instance.route,
  'binaryPresent': instance.binaryPresent,
  'ksudPath': instance.ksudPath,
  'profileError': instance.profileError,
};
