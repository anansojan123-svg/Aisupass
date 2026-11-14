import 'dart:convert';

import 'package:Aisupass/core/storage/preferences_store.dart';
import 'package:Aisupass/features/chat/data/models/chat_session_dto.dart';

/// 对话会话只读数据源：整表以 JSON 字符串存一个键，当前会话 id 单独存一个键。
class ChatSessionQueryDatasource {
  const ChatSessionQueryDatasource({required this._preferences});

  /// 会话列表的存储键，值为 JSON 数组字符串。
  static const String listKey = 'chat_sessions';

  /// 当前选中会话 id 的存储键。
  static const String currentIdKey = 'chat_current_session';

  final PreferencesStore _preferences;

  Future<List<ChatSessionDto>> loadAll() async {
    final String raw = await _preferences.read<String>(
      listKey,
      defaultValue: '',
    );
    if (raw.trim().isEmpty) return const <ChatSessionDto>[];

    final Object? decoded = jsonDecode(raw);
    if (decoded is! List) return const <ChatSessionDto>[];

    final List<ChatSessionDto> sessions = <ChatSessionDto>[];
    for (final Object? item in decoded) {
      if (item is! Map) continue;
      final Map<String, dynamic> map = item.map(
        (Object? key, Object? value) => MapEntry(key.toString(), value),
      );
      final ChatSessionDto session = ChatSessionDto.fromJson(map);
      if (session.id.isEmpty) continue;
      sessions.add(session);
    }
    return sessions;
  }

  Future<String> readCurrentId() =>
      _preferences.read<String>(currentIdKey, defaultValue: '');
}
