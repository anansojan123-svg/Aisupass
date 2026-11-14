// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kernel_profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KernelProfileDto _$KernelProfileDtoFromJson(Map<String, dynamic> json) =>
    _KernelProfileDto(
      name: json['name'] as String? ?? '',
      release: json['release'] as String? ?? '',
      detail: json['detail'] as String? ?? '',
    );

Map<String, dynamic> _$KernelProfileDtoToJson(_KernelProfileDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'release': instance.release,
      'detail': instance.detail,
    };
