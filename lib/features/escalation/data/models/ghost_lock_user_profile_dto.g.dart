// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ghost_lock_user_profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GhostLockUserProfileDto _$GhostLockUserProfileDtoFromJson(
  Map<String, dynamic> json,
) => _GhostLockUserProfileDto(
  name: json['name'] as String? ?? '',
  release: json['release'] as String? ?? '',
  sizeBytes: (json['sizeBytes'] as num?)?.toInt() ?? 0,
  importedAtMs: (json['importedAtMs'] as num?)?.toInt() ?? 0,
  parseError: json['parseError'] as bool? ?? false,
);

Map<String, dynamic> _$GhostLockUserProfileDtoToJson(
  _GhostLockUserProfileDto instance,
) => <String, dynamic>{
  'name': instance.name,
  'release': instance.release,
  'sizeBytes': instance.sizeBytes,
  'importedAtMs': instance.importedAtMs,
  'parseError': instance.parseError,
};
