import 'package:Aisupass/features/chat/domain/models/chat_prompt.dart';

/// 常用提示词只读仓储。
abstract class ChatPromptQueryRepository {
  /// 读取全部提示词。
  Future<List<ChatPrompt>> loadAll();
}
