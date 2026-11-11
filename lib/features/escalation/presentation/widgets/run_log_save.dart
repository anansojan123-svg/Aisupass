import 'dart:convert';
import 'dart:io';

import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

/// 把日志正文另存为用户选定的文件。
///
Future<void> saveRunLogAs(
  BuildContext context,
  AppLocalizations l10n,
  String text,
  String fileName,
) async {
  final String? path = await FilePicker.saveFile(
    dialogTitle: l10n.ghostKeyRunLogSaveAs,
    fileName: fileName,
    type: FileType.any,
    bytes: utf8.encode(text),
  );
  if (path == null) return;
  // 桌面端带 bytes 时插件不一定代写，落点到真实文件路径时补一次。
  final File file = File(path);
  if (!Platform.isAndroid && !Platform.isIOS && !file.existsSync()) {
    await file.writeAsString(text);
  }
  if (!context.mounted) return;
  ToastMessage.success(l10n.ghostKeyRunLogSaved);
}
