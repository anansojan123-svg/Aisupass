import 'package:Aisupass/features/chat/domain/models/chat_prompt.dart';

/// 常用提示词写仓储。
abstract class ChatPromptActionRepository {
  /// 整表覆盖写入。
  Future<void> writeAll(List<ChatPrompt> prompts);
}
