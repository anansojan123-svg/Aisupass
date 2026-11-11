// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kernel_profile_import_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KernelProfileImportResultDto _$KernelProfileImportResultDtoFromJson(
  Map<String, dynamic> json,
) => _KernelProfileImportResultDto(
  ok: json['ok'] as bool? ?? false,
  release: json['release'] as String? ?? '',
  missing:
      (json['missing'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  errorCode: json['errorCode'] as String? ?? '',
  error: json['error'] as String? ?? '',
);

Map<String, dynamic> _$KernelProfileImportResultDtoToJson(
  _KernelProfileImportResultDto instance,
) => <String, dynamic>{
  'ok': instance.ok,
  'release': instance.release,
  'missing': instance.missing,
  'errorCode': instance.errorCode,
  'error': instance.error,
};
