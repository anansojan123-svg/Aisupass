import 'package:Aisupass/features/chat/data/datasources/chat_session_query_datasource.dart';
import 'package:Aisupass/features/chat/data/models/chat_session_dto.dart';
import 'package:Aisupass/features/chat/domain/models/chat_session.dart';
import 'package:Aisupass/features/chat/domain/repositories/chat_session_query_repository.dart';

/// 对话会话只读仓储实现：DTO → Entity 的唯一转换点。
class ChatSessionQueryRepositoryImpl implements ChatSessionQueryRepository {
  const ChatSessionQueryRepositoryImpl({required this._datasource});

  final ChatSessionQueryDatasource _datasource;

  @override
  Future<List<ChatSession>> loadAll() async {
    final List<ChatSessionDto> items = await _datasource.loadAll();
    return items
        .map((ChatSessionDto item) => item.toEntity())
        .toList(growable: false);
  }

  @override
  Future<String> readCurrentId() => _datasource.readCurrentId();
}
