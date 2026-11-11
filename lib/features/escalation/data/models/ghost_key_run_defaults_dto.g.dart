// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ghost_key_run_defaults_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GhostKeyRunDefaultsDto _$GhostKeyRunDefaultsDtoFromJson(
  Map<String, dynamic> json,
) => _GhostKeyRunDefaultsDto(
  runKsu: json['runKsu'] as bool? ?? true,
  acceptFallbackPageOffset: json['acceptFallbackPageOffset'] as bool? ?? true,
);

Map<String, dynamic> _$GhostKeyRunDefaultsDtoToJson(
  _GhostKeyRunDefaultsDto instance,
) => <String, dynamic>{
  'runKsu': instance.runKsu,
  'acceptFallbackPageOffset': instance.acceptFallbackPageOffset,
};
