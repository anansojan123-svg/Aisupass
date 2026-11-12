// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ghost_lock_execution_field_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GhostLockExecutionFieldDto _$GhostLockExecutionFieldDtoFromJson(
  Map<String, dynamic> json,
) => _GhostLockExecutionFieldDto(
  path: json['path'] as String? ?? '',
  value: (json['value'] as num?)?.toInt() ?? 0,
  overridden: json['overridden'] as bool? ?? false,
);

Map<String, dynamic> _$GhostLockExecutionFieldDtoToJson(
  _GhostLockExecutionFieldDto instance,
) => <String, dynamic>{
  'path': instance.path,
  'value': instance.value,
  'overridden': instance.overridden,
};
