// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ghost_lock_profile_config_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GhostLockProfileConfigDto _$GhostLockProfileConfigDtoFromJson(
  Map<String, dynamic> json,
) => _GhostLockProfileConfigDto(
  release: json['release'] as String? ?? '',
  hasProfile: json['hasProfile'] as bool? ?? false,
  roots:
      (json['roots'] as List<dynamic>?)
          ?.map(
            (e) => GhostLockProfileFieldNodeDto.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const <GhostLockProfileFieldNodeDto>[],
  general:
      (json['general'] as List<dynamic>?)
          ?.map(
            (e) =>
                GhostLockExecutionFieldDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <GhostLockExecutionFieldDto>[],
  route: json['route'] as String? ?? '',
  fallbackTo: json['fallbackTo'] as String? ?? '',
  invalidPaths:
      (json['invalidPaths'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  builtinReleases:
      (json['builtinReleases'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$GhostLockProfileConfigDtoToJson(
  _GhostLockProfileConfigDto instance,
) => <String, dynamic>{
  'release': instance.release,
  'hasProfile': instance.hasProfile,
  'roots': instance.roots,
  'general': instance.general,
  'route': instance.route,
  'fallbackTo': instance.fallbackTo,
  'invalidPaths': instance.invalidPaths,
  'builtinReleases': instance.builtinReleases,
};
