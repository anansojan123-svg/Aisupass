// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_session_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatSessionDto _$ChatSessionDtoFromJson(Map<String, dynamic> json) =>
    _ChatSessionDto(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      turns:
          (json['turns'] as List<dynamic>?)
              ?.map((e) => ChatTurnDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ChatTurnDto>[],
    );

Map<String, dynamic> _$ChatSessionDtoToJson(_ChatSessionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'turns': instance.turns,
    };
