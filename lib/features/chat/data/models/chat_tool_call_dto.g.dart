// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_tool_call_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatToolCallDto _$ChatToolCallDtoFromJson(Map<String, dynamic> json) =>
    _ChatToolCallDto(
      callId: json['callId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      argumentsJson: json['argumentsJson'] as String? ?? '',
      status: json['status'] as String? ?? '',
      result: json['result'] as String? ?? '',
      error: json['error'] as String? ?? '',
      durationMs: (json['durationMs'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ChatToolCallDtoToJson(_ChatToolCallDto instance) =>
    <String, dynamic>{
      'callId': instance.callId,
      'name': instance.name,
      'argumentsJson': instance.argumentsJson,
      'status': instance.status,
      'result': instance.result,
      'error': instance.error,
      'durationMs': instance.durationMs,
    };
