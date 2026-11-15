import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_prompt.freezed.dart';

/// 常用提示词，全局共享一份，保存在本地。
@freezed
abstract class ChatPrompt with _$ChatPrompt {
  const ChatPrompt._();

  const factory ChatPrompt({
    required String id,
    required String title,
    required String content,
    required DateTime createdAt,
  }) = _ChatPrompt;

  /// 未填标题时取正文首行，保证列表里始终有可读名称。
  String get displayTitle {
    final String name = title.trim();
    if (name.isNotEmpty) return name;
    final String firstLine = content
        .split(RegExp(r'[\r\n]'))
        .firstWhere((String line) => line.trim().isNotEmpty, orElse: () => '')
        .trim();
    return firstLine;
  }
}
