// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ghost_lock_profile_field_node_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GhostLockProfileFieldNodeDto _$GhostLockProfileFieldNodeDtoFromJson(
  Map<String, dynamic> json,
) => _GhostLockProfileFieldNodeDto(
  path: json['path'] as String? ?? '',
  name: json['name'] as String? ?? '',
  depth: (json['depth'] as num?)?.toInt() ?? 0,
  value: (json['value'] as num?)?.toInt() ?? 0,
  provided: json['provided'] as bool? ?? false,
  overridden: json['overridden'] as bool? ?? false,
);

Map<String, dynamic> _$GhostLockProfileFieldNodeDtoToJson(
  _GhostLockProfileFieldNodeDto instance,
) => <String, dynamic>{
  'path': instance.path,
  'name': instance.name,
  'depth': instance.depth,
  'value': instance.value,
  'provided': instance.provided,
  'overridden': instance.overridden,
};
