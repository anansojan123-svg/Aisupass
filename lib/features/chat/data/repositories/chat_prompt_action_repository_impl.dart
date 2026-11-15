import 'package:Aisupass/features/chat/data/datasources/chat_prompt_action_datasource.dart';
import 'package:Aisupass/features/chat/data/models/chat_prompt_dto.dart';
import 'package:Aisupass/features/chat/domain/models/chat_prompt.dart';
import 'package:Aisupass/features/chat/domain/repositories/chat_prompt_action_repository.dart';

/// 常用提示词写仓储实现：Entity → DTO 的唯一转换点。
class ChatPromptActionRepositoryImpl implements ChatPromptActionRepository {
  const ChatPromptActionRepositoryImpl({required this._datasource});

  final ChatPromptActionDatasource _datasource;

  @override
  Future<void> writeAll(List<ChatPrompt> prompts) => _datasource.writeAll(
    prompts.map(ChatPromptDto.fromEntity).toList(growable: false),
  );
}
