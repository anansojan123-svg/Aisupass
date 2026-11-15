import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/tool_schema.dart';

/// 本地附件自检工具。
///
/// 用户选择的镜像/压缩包落在应用沙箱里，adb shell（uid 2000）无权读取，
/// 因此在应用进程内直接探测格式，避免模型白白尝试 shell 命令。
List<ChatToolDefinition> localFileTools(Ref ref) => <ChatToolDefinition>[
  ChatToolDefinition(
    name: 'local_file_inspect',
    description:
        'Inspect a local file the user attached: existence, size and container '
        'format detected from the header bytes. Runs inside the app process, so '
        'it works for sandbox paths that adb_shell_exec cannot read. Call this '
        'before choosing a parser.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'path': stringProperty(
          description: 'Absolute path of the attached file.',
        ),
      },
      required: <String>['path'],
    ),
    execute: (Map<String, dynamic> arguments) async {
      final String path = requireString(arguments, 'path');
      final File file = File(path);
      if (!file.existsSync()) {
        return jsonEncode(<String, Object?>{
          'path': path,
          'exists': false,
          'sandboxOnly': true,
          'next':
              'The file is gone. Ask the user to attach it again; do not guess '
              'its content.',
        });
      }

      final int size = file.lengthSync();
      final List<int> head = <int>[];
      if (size > 0) {
        final RandomAccessFile reader = await file.open();
        try {
          head.addAll(await reader.read(16));
        } finally {
          await reader.close();
        }
      }

      final _ContainerProbe probe = _detect(head);
      return jsonEncode(<String, Object?>{
        'path': path,
        'exists': true,
        'size': size,
        'sizeText': _formatSize(size),
        'container': probe.kind,
        'headerHex': head
            .map((int byte) => byte.toRadixString(16).padLeft(2, '0'))
            .join(' '),
        'sandboxOnly': true,
        'adbReadable': false,
        'recommendedTools': probe.tools,
        'notes': probe.note,
      });
    },
  ),
];

/// 单次探测结果。
class _ContainerProbe {
  const _ContainerProbe({
    required this.kind,
    this.tools = const <String>[],
    this.note = '',
  });

  /// payload / boot / zip / sparse / gzip / xz / 7z / unknown。
  final String kind;
  final List<String> tools;
  final String note;
}

_ContainerProbe _detect(List<int> head) {
  // payload.bin：开头是 CrAU。
  if (_startsWith(head, <int>[0x43, 0x72, 0x41, 0x55])) {
    return const _ContainerProbe(
      kind: 'payload',
      tools: <String>['ghost_lock_probe_profile'],
      note:
          'Android payload.bin. Parse it with ghost_lock_probe_profile, which '
          'streams and extracts boot.img; do not pass it to '
          'kernel_profile_import_start.',
    );
  }
  // boot.img / vendor_boot.img / init_boot.img 共用 ANDROID! 头。
  if (_startsWith(head, <int>[0x41, 0x4e, 0x44, 0x52, 0x4f, 0x49, 0x44, 0x21])) {
    return const _ContainerProbe(
      kind: 'boot',
      tools: <String>['ghost_lock_probe_profile', 'kernel_profile_import_start'],
      note:
          'Android boot image. kernel_profile_import_start accepts a single '
          'image up to 512 MiB; otherwise use ghost_lock_probe_profile.',
    );
  }
  if (_startsWith(head, <int>[0x50, 0x4b, 0x03, 0x04]) ||
      _startsWith(head, <int>[0x50, 0x4b, 0x05, 0x06]) ||
      _startsWith(head, <int>[0x50, 0x4b, 0x07, 0x08])) {
    return const _ContainerProbe(
      kind: 'zip',
      tools: <String>['ghost_lock_probe_profile'],
      note:
          'ZIP archive, typical for an OTA package. ghost_lock_probe_profile '
          'reads it directly, or pass an OTA URL instead.',
    );
  }
  if (_startsWith(head, <int>[0x3a, 0xff, 0x26, 0xed])) {
    return const _ContainerProbe(
      kind: 'sparse',
      tools: <String>['ghost_lock_probe_profile'],
      note: 'Android sparse image; ghost_lock_probe_profile handles it.',
    );
  }
  if (_startsWith(head, <int>[0x1f, 0x8b])) {
    return const _ContainerProbe(
      kind: 'gzip',
      note: 'Gzip stream; ask the user for the uncompressed image.',
    );
  }
  if (_startsWith(head, <int>[0xfd, 0x37, 0x7a, 0x58, 0x5a, 0x00])) {
    return const _ContainerProbe(
      kind: 'xz',
      note: 'XZ archive; ask the user for the uncompressed image.',
    );
  }
  if (_startsWith(head, <int>[0x37, 0x7a, 0xbc, 0xaf, 0x27, 0x1c])) {
    return const _ContainerProbe(
      kind: '7z',
      note: '7z archive; ask the user for the uncompressed image.',
    );
  }
  return const _ContainerProbe(
    kind: 'unknown',
    note:
        'Header is not a known Android container. Report the hex header to the '
        'user instead of guessing a parser.',
  );
}

bool _startsWith(List<int> head, List<int> magic) {
  if (head.length < magic.length) return false;
  for (int i = 0; i < magic.length; i++) {
    if (head[i] != magic[i]) return false;
  }
  return true;
}

String _formatSize(int bytes) {
  if (bytes >= 1 << 30) return '${(bytes / (1 << 30)).toStringAsFixed(2)} GB';
  if (bytes >= 1 << 20) return '${(bytes / (1 << 20)).toStringAsFixed(1)} MB';
  if (bytes >= 1 << 10) return '${(bytes / (1 << 10)).toStringAsFixed(1)} KB';
  return '$bytes B';
}
