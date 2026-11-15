import 'package:Aisupass/features/chat/data/datasources/chat_prompt_query_datasource.dart';
import 'package:Aisupass/features/chat/data/models/chat_prompt_dto.dart';
import 'package:Aisupass/features/chat/domain/models/chat_prompt.dart';
import 'package:Aisupass/features/chat/domain/repositories/chat_prompt_query_repository.dart';

/// 常用提示词只读仓储实现：DTO → Entity 的唯一转换点。
class ChatPromptQueryRepositoryImpl implements ChatPromptQueryRepository {
  const ChatPromptQueryRepositoryImpl({required this._datasource});

  final ChatPromptQueryDatasource _datasource;

  @override
  Future<List<ChatPrompt>> loadAll() async {
    final List<ChatPromptDto> prompts = await _datasource.loadAll();
    return prompts
        .map((ChatPromptDto item) => item.toEntity())
        .toList(growable: false);
  }
}
