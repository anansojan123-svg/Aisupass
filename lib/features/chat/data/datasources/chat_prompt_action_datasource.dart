import 'dart:convert';

import 'package:Aisupass/core/storage/preferences_store.dart';
import 'package:Aisupass/features/chat/data/datasources/chat_prompt_query_datasource.dart';
import 'package:Aisupass/features/chat/data/models/chat_prompt_dto.dart';

/// 常用提示词写数据源：数量级很小，整表覆盖写即可。
class ChatPromptActionDatasource {
  const ChatPromptActionDatasource({required this._preferences});

  final PreferencesStore _preferences;

  Future<void> writeAll(List<ChatPromptDto> prompts) {
    final String raw = jsonEncode(
      prompts.map((ChatPromptDto item) => item.toJson()).toList(
        growable: false,
      ),
    );
    return _preferences.write<String>(
      ChatPromptQueryDatasource.listKey,
      raw,
    );
  }
}
