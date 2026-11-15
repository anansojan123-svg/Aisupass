// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_prompt_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatPromptDto _$ChatPromptDtoFromJson(Map<String, dynamic> json) =>
    _ChatPromptDto(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );

Map<String, dynamic> _$ChatPromptDtoToJson(_ChatPromptDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'createdAt': instance.createdAt,
    };
