import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:Aisupass/features/chat/domain/models/chat_attachment.dart';

/// 单张图片上限，超过的多半是原图或压缩包。
const int maxChatImageBytes = 8 << 20;

/// 单个文本文件上限，避免把超大日志整段塞进上下文。
const int maxChatTextBytes = 1 << 20;

/// 单条消息的附件数量上限。
const int maxChatAttachments = 6;

/// 允许作为附件发送的文本文件扩展名。
const Set<String> chatTextExtensions = <String>{
  'txt',
  'md',
  'json',
  'log',
  'yaml',
  'yml',
  'xml',
  'csv',
  'conf',
  'ini',
};

/// 只传路径的文件扩展名：镜像、压缩包与安装包，体积大且由模型自行读取。
const Set<String> chatBinaryExtensions = <String>{
  'bin',
  'img',
  'zip',
  'tar',
  'gz',
  'xz',
  '7z',
  'apk',
  'super',
  'payload',
};

/// 是否属于允许的文本附件。
///
/// `FilePicker.allowedExtensions` 在 Android 上按 MIME 过滤，
/// 部分扩展名会退化成任意文件，因此选中后必须按文件名再判一次。
bool hasChatTextExtension(String name) => _hasExtension(name, chatTextExtensions);

/// 是否属于只传路径的附件。
bool hasChatBinaryExtension(String name) =>
    _hasExtension(name, chatBinaryExtensions);

bool _hasExtension(String name, Set<String> allowed) {
  final String lower = name.toLowerCase();
  final int dot = lower.lastIndexOf('.');
  return dot >= 0 && allowed.contains(lower.substring(dot + 1));
}

/// 附件落盘：把用户选中的文件复制到应用私有目录，会话只保存副本路径。
///
/// [ChatAttachmentKind.binary] 不复制：镜像和压缩包动辄上 GB，
/// 只保留原始路径，由模型用 adb shell 自行读取。
class ChatAttachmentStore {
  const ChatAttachmentStore();

  Future<ChatAttachment?> save(
    PlatformFile file,
    ChatAttachmentKind kind,
  ) async {
    final String name = file.name.trim();
    if (name.isEmpty) return null;

    if (kind == ChatAttachmentKind.binary) {
      final String path = file.path?.trim() ?? '';
      if (path.isEmpty) return null;
      return ChatAttachment(
        id: const Uuid().v4(),
        name: name,
        path: path,
        mimeType: 'application/octet-stream',
        size: file.size,
        kind: kind,
      );
    }

    try {
      final Directory root = await getApplicationSupportDirectory();
      final Directory target = Directory(
        '${root.path}${Platform.pathSeparator}chat_attachments',
      );
      if (!await target.exists()) {
        await target.create(recursive: true);
      }

      final String id = const Uuid().v4();
      final File copy = File(
        '${target.path}${Platform.pathSeparator}'
        '${id}_${_sanitize(name)}',
      );
      final String? path = file.path;
      if (path != null && path.isNotEmpty) {
        await File(path).copy(copy.path);
      } else {
        final List<int>? bytes = file.bytes;
        if (bytes == null || bytes.isEmpty) return null;
        await copy.writeAsBytes(bytes, flush: true);
      }

      return ChatAttachment(
        id: id,
        name: name,
        path: copy.path,
        mimeType: _mimeType(name, kind),
        size: file.size,
        kind: kind,
      );
    } on FileSystemException {
      return null;
    }
  }

  /// 文件名里不能出现路径分隔符，统一替换成下划线。
  String _sanitize(String name) =>
      name.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');

  String _mimeType(String name, ChatAttachmentKind kind) {
    if (kind == ChatAttachmentKind.text) return 'text/plain';
    if (kind == ChatAttachmentKind.binary) return 'application/octet-stream';
    final String lower = name.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.gif')) return 'image/gif';
    if (lower.endsWith('.bmp')) return 'image/bmp';
    return 'image/jpeg';
  }
}
