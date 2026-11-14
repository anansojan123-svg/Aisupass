import 'package:Aisupass/features/chat/domain/models/chat_session.dart';

/// 对话会话写仓储。
abstract class ChatSessionActionRepository {
  /// 整表覆盖写全部会话。
  Future<void> writeAll(List<ChatSession> sessions);

  /// 记录当前选中的会话 id。
  Future<void> writeCurrentId(String id);
}
