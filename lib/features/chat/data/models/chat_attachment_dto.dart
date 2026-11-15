import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:Aisupass/features/chat/domain/models/chat_attachment.dart';

part 'chat_attachment_dto.freezed.dart';
part 'chat_attachment_dto.g.dart';

/// 对话附件的数据传输对象，只在 data 层内流转。
@freezed
abstract class ChatAttachmentDto with _$ChatAttachmentDto {
  const ChatAttachmentDto._();

  const factory ChatAttachmentDto({
    @Default('') String id,
    @Default('') String name,
    @Default('') String path,
    @Default('') String mimeType,
    @Default(0) int size,
    @Default('') String kind,
  }) = _ChatAttachmentDto;

  factory ChatAttachmentDto.fromJson(Map<String, dynamic> json) =>
      _$ChatAttachmentDtoFromJson(json);

  factory ChatAttachmentDto.fromEntity(ChatAttachment entity) =>
      ChatAttachmentDto(
        id: entity.id,
        name: entity.name,
        path: entity.path,
        mimeType: entity.mimeType,
        size: entity.size,
        kind: entity.kind.name,
      );

  ChatAttachment toEntity() => ChatAttachment(
    id: id,
    name: name,
    path: path,
    mimeType: mimeType,
    size: size,
    kind: ChatAttachmentKind.values.firstWhere(
      (ChatAttachmentKind item) => item.name == kind,
      orElse: () => ChatAttachmentKind.text,
    ),
  );
}
