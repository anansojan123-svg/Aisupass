// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnnouncementDto _$AnnouncementDtoFromJson(Map<String, dynamic> json) =>
    _AnnouncementDto(
      msg: json['msg'] == null
          ? const AnnouncementMsgDto()
          : AnnouncementMsgDto.fromJson(json['msg'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AnnouncementDtoToJson(_AnnouncementDto instance) =>
    <String, dynamic>{'msg': instance.msg};

_AnnouncementMsgDto _$AnnouncementMsgDtoFromJson(Map<String, dynamic> json) =>
    _AnnouncementMsgDto(
      content: json['app_gg'] == null ? '' : _asString(json['app_gg']),
    );

Map<String, dynamic> _$AnnouncementMsgDtoToJson(_AnnouncementMsgDto instance) =>
    <String, dynamic>{'app_gg': instance.content};
