// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ghost_lock_import_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GhostLockImportResultDto _$GhostLockImportResultDtoFromJson(
  Map<String, dynamic> json,
) => _GhostLockImportResultDto(
  ok: json['ok'] as bool? ?? false,
  release: json['release'] as String? ?? '',
  fileName: json['fileName'] as String? ?? '',
  reason: json['reason'] as String? ?? '',
  requiresOverwrite: json['requiresOverwrite'] as bool? ?? false,
);

Map<String, dynamic> _$GhostLockImportResultDtoToJson(
  _GhostLockImportResultDto instance,
) => <String, dynamic>{
  'ok': instance.ok,
  'release': instance.release,
  'fileName': instance.fileName,
  'reason': instance.reason,
  'requiresOverwrite': instance.requiresOverwrite,
};
