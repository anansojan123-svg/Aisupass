import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_attachment.freezed.dart';

/// 附件类型：图片走多模态协议，文本文件按正文拼进请求，
/// 镜像/压缩包等只把本地路径告诉模型。
enum ChatAttachmentKind { image, text, binary }

/// 对话附件，只记录应用私有目录里的副本，不保存文件内容本身。
///
/// [ChatAttachmentKind.binary] 例外：不复制文件，直接保留原始路径。
@freezed
abstract class ChatAttachment with _$ChatAttachment {
  const ChatAttachment._();

  const factory ChatAttachment({
    required String id,
    required String name,
    required String path,
    required String mimeType,
    required int size,
    required ChatAttachmentKind kind,
  }) = _ChatAttachment;

  bool get isImage => kind == ChatAttachmentKind.image;

  /// 是否只传递路径，由模型自行用 adb shell 读取。
  bool get isBinary => kind == ChatAttachmentKind.binary;
}
