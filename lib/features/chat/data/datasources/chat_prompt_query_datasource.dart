import 'dart:convert';

import 'package:Aisupass/core/storage/preferences_store.dart';
import 'package:Aisupass/features/chat/data/models/chat_prompt_dto.dart';

/// 常用提示词只读数据源：整表以 JSON 字符串存一个键。
class ChatPromptQueryDatasource {
  const ChatPromptQueryDatasource({required this._preferences});

  /// 提示词列表的存储键，值为 JSON 数组字符串。
  static const String listKey = 'chat_prompts';

  final PreferencesStore _preferences;

  Future<List<ChatPromptDto>> loadAll() async {
    final String raw = await _preferences.read<String>(
      listKey,
      defaultValue: '',
    );
    if (raw.trim().isEmpty) return const <ChatPromptDto>[];

    final Object? decoded = jsonDecode(raw);
    if (decoded is! List) return const <ChatPromptDto>[];

    final List<ChatPromptDto> prompts = <ChatPromptDto>[];
    for (final Object? item in decoded) {
      if (item is! Map) continue;
      final Map<String, dynamic> map = item.map(
        (Object? key, Object? value) => MapEntry(key.toString(), value),
      );
      final ChatPromptDto prompt = ChatPromptDto.fromJson(map);
      if (prompt.id.isEmpty || prompt.content.trim().isEmpty) continue;
      prompts.add(prompt);
    }
    return prompts;
  }
}
