// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_update_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUpdateDto _$AppUpdateDtoFromJson(Map<String, dynamic> json) =>
    _AppUpdateDto(
      msg: json['msg'] == null
          ? const AppUpdateMsgDto()
          : AppUpdateMsgDto.fromJson(json['msg'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppUpdateDtoToJson(_AppUpdateDto instance) =>
    <String, dynamic>{'msg': instance.msg};

_AppUpdateMsgDto _$AppUpdateMsgDtoFromJson(Map<String, dynamic> json) =>
    _AppUpdateMsgDto(
      version: json['version'] == null ? '' : _asString(json['version']),
      appUpdateUrl: json['app_update_url'] == null
          ? ''
          : _asString(json['app_update_url']),
      appUpdateShow: json['app_update_show'] == null
          ? ''
          : _asString(json['app_update_show']),
      appUpdateMust: json['app_update_must'] == null
          ? ''
          : _asString(json['app_update_must']),
    );

Map<String, dynamic> _$AppUpdateMsgDtoToJson(_AppUpdateMsgDto instance) =>
    <String, dynamic>{
      'version': instance.version,
      'app_update_url': instance.appUpdateUrl,
      'app_update_show': instance.appUpdateShow,
      'app_update_must': instance.appUpdateMust,
    };
