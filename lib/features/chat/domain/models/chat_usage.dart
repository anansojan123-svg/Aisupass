import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_usage.freezed.dart';

/// 一次模型调用的 token 用量。
///
/// 工具续跑会产生多次调用，展示时按段累加。
@freezed
abstract class ChatUsage with _$ChatUsage {
  const ChatUsage._();

  const factory ChatUsage({
    required int promptTokens,
    required int completionTokens,
  }) = _ChatUsage;

  /// 空用量，作为未统计时的默认值。
  static const ChatUsage empty = ChatUsage(
    promptTokens: 0,
    completionTokens: 0,
  );

  /// 总 token 数。
  int get totalTokens => promptTokens + completionTokens;

  /// 是否没有任何用量。
  bool get isEmpty => totalTokens <= 0;

  /// 累加两次调用的用量。
  ChatUsage operator +(ChatUsage other) => ChatUsage(
    promptTokens: promptTokens + other.promptTokens,
    completionTokens: completionTokens + other.completionTokens,
  );
}
