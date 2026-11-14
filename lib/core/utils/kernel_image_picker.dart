import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

/// 允许解析的镜像 / OTA 包扩展名。
const Set<String> kernelImageExtensions = <String>{'img', 'bin', 'zip'};

/// 允许导入的 profile 文本扩展名。
const Set<String> kernelProfileExtensions = <String>{
  'conf',
  'hocon',
  'json',
  'txt',
};

/// 单份 profile 文本上限；超过的多半是镜像或日志。
const int maxKernelProfileBytes = 4 << 20;

/// 扩展名是否在 [allowed] 内。
///
/// `FilePicker.allowedExtensions` 在 Android 上按 MIME 过滤，`.img` / `.conf`
/// 没有标准类型时会退化成任意文件，因此选中后必须按文件名再判一次。
bool hasAllowedExtension(String path, Set<String> allowed) {
  final String name = path.toLowerCase();
  final int dot = name.lastIndexOf('.');
  return dot >= 0 && allowed.contains(name.substring(dot + 1));
}

/// 文件存在且非空。
bool isReadableFile(String path) {
  final File file = File(path);
  return file.existsSync() && file.lengthSync() > 0;
}

/// 读成 UTF-8 文本；扩展名、大小、编码任一不合规返回 null。
String? readKernelProfileText(PlatformFile file) {
  final List<int>? bytes = file.bytes;
  if (bytes == null || bytes.isEmpty || bytes.length > maxKernelProfileBytes) {
    return null;
  }
  if (!hasAllowedExtension(file.name, kernelProfileExtensions)) return null;
  try {
    return utf8.decode(bytes);
  } on FormatException {
    return null;
  }
}
