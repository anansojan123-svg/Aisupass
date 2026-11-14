import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:Aisupass/features/chat/data/models/chat_turn_dto.dart';
import 'package:Aisupass/features/chat/domain/models/chat_session.dart';

part 'chat_session_dto.freezed.dart';
part 'chat_session_dto.g.dart';

/// 会话的数据传输对象，只在 data 层内流转。
@freezed
abstract class ChatSessionDto with _$ChatSessionDto {
  const ChatSessionDto._();

  const factory ChatSessionDto({
    @Default('') String id,
    @Default('') String title,
    @Default('') String createdAt,
    @Default('') String updatedAt,
    @Default(<ChatTurnDto>[]) List<ChatTurnDto> turns,
  }) = _ChatSessionDto;

  factory ChatSessionDto.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionDtoFromJson(json);

  factory ChatSessionDto.fromEntity(ChatSession entity) => ChatSessionDto(
    id: entity.id,
    title: entity.title,
    createdAt: entity.createdAt.toIso8601String(),
    updatedAt: entity.updatedAt.toIso8601String(),
    turns: entity.turns.map(ChatTurnDto.fromEntity).toList(growable: false),
  );

  ChatSession toEntity() {
    final DateTime now = DateTime.now();
    return ChatSession(
      id: id,
      title: title,
      createdAt: DateTime.tryParse(createdAt) ?? now,
      updatedAt: DateTime.tryParse(updatedAt) ?? now,
      turns: turns
          .map((ChatTurnDto item) => item.toEntity())
          .toList(growable: false),
    );
  }
}
