// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_attachment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatAttachmentDto _$ChatAttachmentDtoFromJson(Map<String, dynamic> json) =>
    _ChatAttachmentDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      path: json['path'] as String? ?? '',
      mimeType: json['mimeType'] as String? ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
      kind: json['kind'] as String? ?? '',
    );

Map<String, dynamic> _$ChatAttachmentDtoToJson(_ChatAttachmentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'path': instance.path,
      'mimeType': instance.mimeType,
      'size': instance.size,
      'kind': instance.kind,
    };
