import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:Aisupass/features/chat/domain/models/chat_prompt.dart';

part 'chat_prompt_dto.freezed.dart';
part 'chat_prompt_dto.g.dart';

/// 常用提示词的数据传输对象，只在 data 层内流转。
@freezed
abstract class ChatPromptDto with _$ChatPromptDto {
  const ChatPromptDto._();

  const factory ChatPromptDto({
    @Default('') String id,
    @Default('') String title,
    @Default('') String content,
    @Default('') String createdAt,
  }) = _ChatPromptDto;

  factory ChatPromptDto.fromJson(Map<String, dynamic> json) =>
      _$ChatPromptDtoFromJson(json);

  factory ChatPromptDto.fromEntity(ChatPrompt entity) => ChatPromptDto(
    id: entity.id,
    title: entity.title,
    content: entity.content,
    createdAt: entity.createdAt.toIso8601String(),
  );

  ChatPrompt toEntity() => ChatPrompt(
    id: id,
    title: title,
    content: content,
    createdAt: DateTime.tryParse(createdAt) ??
        DateTime.fromMillisecondsSinceEpoch(0),
  );
}
