import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:Aisupass/features/chat/domain/models/chat_turn.dart';

part 'chat_session.freezed.dart';

/// 一个独立的多轮对话会话。
@freezed
abstract class ChatSession with _$ChatSession {
  const ChatSession._();

  const factory ChatSession({
    required String id,
    required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<ChatTurn> turns,
  }) = _ChatSession;

  /// 是否还没有任何轮次。
  bool get isEmpty => turns.isEmpty;
}
