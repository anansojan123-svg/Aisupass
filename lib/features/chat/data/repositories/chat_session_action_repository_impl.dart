import 'package:Aisupass/features/chat/data/datasources/chat_session_action_datasource.dart';
import 'package:Aisupass/features/chat/data/models/chat_session_dto.dart';
import 'package:Aisupass/features/chat/domain/models/chat_session.dart';
import 'package:Aisupass/features/chat/domain/repositories/chat_session_action_repository.dart';

/// 对话会话写仓储实现：Entity → DTO 的唯一转换点。
class ChatSessionActionRepositoryImpl implements ChatSessionActionRepository {
  const ChatSessionActionRepositoryImpl({required this._datasource});

  final ChatSessionActionDatasource _datasource;

  @override
  Future<void> writeAll(List<ChatSession> sessions) => _datasource.writeAll(
    sessions.map(ChatSessionDto.fromEntity).toList(growable: false),
  );

  @override
  Future<void> writeCurrentId(String id) => _datasource.writeCurrentId(id);
}
