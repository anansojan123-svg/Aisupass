import 'dart:convert';

import 'package:Aisupass/core/storage/preferences_store.dart';
import 'package:Aisupass/features/chat/data/datasources/chat_session_query_datasource.dart';
import 'package:Aisupass/features/chat/data/models/chat_session_dto.dart';

/// 对话会话写数据源：会话数量级在几十条以内，整表覆盖写足够，无需分片。
class ChatSessionActionDatasource {
  const ChatSessionActionDatasource({required this._preferences});

  final PreferencesStore _preferences;

  Future<void> writeAll(List<ChatSessionDto> sessions) {
    final String raw = jsonEncode(
      sessions.map((ChatSessionDto item) => item.toJson()).toList(
        growable: false,
      ),
    );
    return _preferences.write<String>(
      ChatSessionQueryDatasource.listKey,
      raw,
    );
  }

  Future<void> writeCurrentId(String id) => _preferences.write<String>(
    ChatSessionQueryDatasource.currentIdKey,
    id,
  );
}
