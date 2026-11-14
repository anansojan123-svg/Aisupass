import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:Aisupass/features/chat/domain/enums/chat_tool_status.dart';

part 'chat_tool_call.freezed.dart';

/// 一次工具调用及其执行结果。
@freezed
abstract class ChatToolCall with _$ChatToolCall {
  const ChatToolCall._();

  const factory ChatToolCall({
    required String callId,
    required String name,
    required String argumentsJson,
    required ChatToolStatus status,
    required String result,
    required String error,
    required Duration duration,
  }) = _ChatToolCall;

  /// 是否带失败原因。
  bool get hasError => error.isNotEmpty;

  /// 是否已记录耗时。
  bool get hasDuration => duration > Duration.zero;
}
