import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:Aisupass/core/storage/storage_providers.dart';
import 'package:Aisupass/features/chat/data/datasources/chat_session_query_datasource.dart';
import 'package:Aisupass/features/chat/data/repositories/chat_session_query_repository_impl.dart';
import 'package:Aisupass/features/chat/domain/models/chat_session.dart';
import 'package:Aisupass/features/chat/domain/repositories/chat_session_query_repository.dart';

part 'chat_query_provider.g.dart';

/// 会话只读数据源。
@riverpod
ChatSessionQueryDatasource chatSessionQueryDatasource(Ref ref) =>
    ChatSessionQueryDatasource(
      preferences: ref.watch(preferencesStoreProvider),
    );

/// 会话只读仓储。
@riverpod
ChatSessionQueryRepository chatSessionQueryRepository(Ref ref) =>
    ChatSessionQueryRepositoryImpl(
      datasource: ref.watch(chatSessionQueryDatasourceProvider),
    );

/// 磁盘上的全部会话。
@riverpod
Future<List<ChatSession>> storedChatSessions(Ref ref) =>
    ref.watch(chatSessionQueryRepositoryProvider).loadAll();

/// 上次选中的会话 id；无记录返回空串。
@riverpod
Future<String> storedChatSessionId(Ref ref) =>
    ref.watch(chatSessionQueryRepositoryProvider).readCurrentId();
