import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:Aisupass/features/chat/domain/enums/chat_tool_status.dart';
import 'package:Aisupass/features/chat/domain/models/chat_tool_call.dart';

part 'chat_tool_call_dto.freezed.dart';
part 'chat_tool_call_dto.g.dart';

/// 工具调用的数据传输对象，只在 data 层内流转。
@freezed
abstract class ChatToolCallDto with _$ChatToolCallDto {
  const ChatToolCallDto._();

  const factory ChatToolCallDto({
    @Default('') String callId,
    @Default('') String name,
    @Default('') String argumentsJson,
    @Default('') String status,
    @Default('') String result,
    @Default('') String error,
    @Default(0) int durationMs,
  }) = _ChatToolCallDto;

  factory ChatToolCallDto.fromJson(Map<String, dynamic> json) =>
      _$ChatToolCallDtoFromJson(json);

  factory ChatToolCallDto.fromEntity(ChatToolCall entity) => ChatToolCallDto(
    callId: entity.callId,
    name: entity.name,
    argumentsJson: entity.argumentsJson,
    status: entity.status.name,
    result: entity.result,
    error: entity.error,
    durationMs: entity.duration.inMilliseconds,
  );

  ChatToolCall toEntity() => ChatToolCall(
    callId: callId,
    name: name,
    argumentsJson: argumentsJson,
    status: ChatToolStatus.fromName(status),
    result: result,
    error: error,
    duration: Duration(milliseconds: durationMs),
  );
}
