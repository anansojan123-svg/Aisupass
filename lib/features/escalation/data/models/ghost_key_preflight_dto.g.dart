// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ghost_key_preflight_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GhostKeyPreflightDto _$GhostKeyPreflightDtoFromJson(
  Map<String, dynamic> json,
) => _GhostKeyPreflightDto(
  adbConnected: json['adbConnected'] as bool? ?? false,
  shellUid: (json['shellUid'] as num?)?.toInt() ?? -1,
  seccomp: (json['seccomp'] as num?)?.toInt() ?? -1,
  release: json['release'] as String? ?? '',
  profileMatched: json['profileMatched'] as bool? ?? false,
  binaryPresent: json['binaryPresent'] as bool? ?? false,
);

Map<String, dynamic> _$GhostKeyPreflightDtoToJson(
  _GhostKeyPreflightDto instance,
) => <String, dynamic>{
  'adbConnected': instance.adbConnected,
  'shellUid': instance.shellUid,
  'seccomp': instance.seccomp,
  'release': instance.release,
  'profileMatched': instance.profileMatched,
  'binaryPresent': instance.binaryPresent,
};
