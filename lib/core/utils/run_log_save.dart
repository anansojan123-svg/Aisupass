import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

/// 把日志正文另存为用户选定的文件。
///
/// 返回 `true` 表示已写入；用户在选点弹窗里取消返回 `false`。
/// 文案由调用方传入，本函数不持有 `BuildContext`。
Future<bool> saveRunLogToFile({
  required String text,
  required String fileName,
  required String dialogTitle,
}) async {
  final String? path = await FilePicker.saveFile(
    dialogTitle: dialogTitle,
    fileName: fileName,
    type: FileType.any,
    bytes: utf8.encode(text),
  );
  if (path == null) return false;
  // 桌面端带 bytes 时插件不一定代写，落点到真实文件路径时补一次。
  final File file = File(path);
  if (!Platform.isAndroid && !Platform.isIOS && !file.existsSync()) {
    await file.writeAsString(text);
  }
  return true;
}
