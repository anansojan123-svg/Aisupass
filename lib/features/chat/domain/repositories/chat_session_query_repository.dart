import 'package:Aisupass/features/chat/domain/models/chat_session.dart';

/// 对话会话只读仓储。
abstract class ChatSessionQueryRepository {
  /// 读取全部会话。
  Future<List<ChatSession>> loadAll();

  /// 读取上次选中的会话 id；无记录返回空串。
  Future<String> readCurrentId();
}
