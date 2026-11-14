import 'package:Aisupass/features/ai/domain/models/ai_config.dart';
import 'package:Aisupass/features/chat/domain/models/chat_stream_event.dart';
import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/domain/models/chat_turn.dart';

/// 对话执行仓储：把完整历史与工具清单发给模型，返回统一的流式事件。
abstract interface class ChatActionRepository {
  /// 发起一轮流式对话；协议差异由数据源抹平，失败也以事件形式下发。
  Stream<ChatStreamEvent> streamChat({
    required AiConfig config,
    required List<ChatTurn> history,
    required List<ChatToolDefinition> tools,
  });
}
