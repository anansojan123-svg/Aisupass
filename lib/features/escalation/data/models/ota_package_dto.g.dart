// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ota_package_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OtaPackageDto _$OtaPackageDtoFromJson(Map<String, dynamic> json) =>
    _OtaPackageDto(
      device: json['device'] as String? ?? '',
      model: json['model'] as String? ?? '',
      version: json['version'] as String? ?? '',
      build: json['build'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );

Map<String, dynamic> _$OtaPackageDtoToJson(_OtaPackageDto instance) =>
    <String, dynamic>{
      'device': instance.device,
      'model': instance.model,
      'version': instance.version,
      'build': instance.build,
      'url': instance.url,
    };
