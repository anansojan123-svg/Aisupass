import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/core/providers/adb_shell_provider.dart';
import 'package:Aisupass/core/utils/su_shell.dart';
import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/tool_schema.dart';
import 'package:Aisupass/generated/adb_shell.g.dart';

/// 回传给模型的单路输出上限，超出即截断，避免一次 `dumpsys` 塞爆上下文。
const int _maxOutputChars = 8000;

/// 默认超时与上限；模型给的超时统一夹在这个区间内。
const int _defaultTimeoutMs = 30000;
const int _maxTimeoutMs = 120000;

/// uid=2000 的 adb shell 通道：执行命令与请求无线调试配对。
///
/// 执行走原生一次性 `exec`，退出码与 stdout/stderr 由 adb 协议给出；
/// 通道未连通时不报错，而是返回 `connected=false`，让模型去请求配对面板，
/// 由用户点按钮完成连接，模型不能代替用户配对。
List<ChatToolDefinition> adbTools(Ref ref) => <ChatToolDefinition>[
  ChatToolDefinition(
    name: 'adb_shell_exec',
    description:
        'Run one shell command on the connected adb shell channel '
        '(uid 2000) and return exit code, stdout and stderr. Use this to '
        'actually inspect or operate the device. If it returns '
        'connected=false, call adb_pairing_request so the user can pair.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'command': stringProperty(
          description:
              'Shell command to run, e.g. "id", "ls -l /data/local/tmp".',
        ),
        'timeoutMs': intProperty(
          description: 'Timeout in milliseconds. Defaults to $_defaultTimeoutMs.',
          minimum: 1000,
          maximum: _maxTimeoutMs,
        ),
      },
      required: <String>['command'],
    ),
    execute: (Map<String, dynamic> arguments) async {
      final String command = requireString(arguments, 'command');
      final int timeoutMs = _clampTimeout(
        intArg(arguments, 'timeoutMs', fallback: _defaultTimeoutMs)!,
      );

      final ShellConnection link = await _readConnection(ref);
      if (!link.connected) {
        return jsonEncode(<String, Object?>{
          'connected': false,
          'uid': link.uid,
          'exitCode': -1,
          'stdout': '',
          'stderr': '',
          'timedOut': false,
          'next':
              'No adb shell channel yet. Call adb_pairing_request now and let '
              'the user finish pairing; then retry this command.',
          'forbidden':
              'Do not report a permission problem, do not simulate output, '
              'and do not suggest other rooting methods. connected=false only '
              'means the pairing step is missing.',
        });
      }

      final ShellExec exec = ref.read(adbShellExecProvider);
      final ShellExecResult result = await exec(command, timeoutMs);
      return jsonEncode(<String, Object?>{
        'connected': true,
        'uid': link.uid,
        'exitCode': result.exitCode,
        'stdout': _truncate(result.stdout),
        'stderr': _truncate(result.stderr),
        'durationMs': result.durationMs,
        'timedOut': result.timedOut,
      });
    },
  ),
  ChatToolDefinition(
    name: 'adb_pairing_request',
    description:
        'Open the wireless debugging pairing flow for the user. Call this '
        'whenever the user asks to connect ADB, enable wireless debugging, '
        'pair the adb shell, or asks why shell commands do not work; also '
        'call it right after adb_shell_exec returns connected=false. It '
        'renders an interactive panel with a pairing button in the chat. The '
        'user must tap that button and enter the pairing code in the system '
        'notification, which you cannot do for them.',
    parameters: noArgsSchema,
    execute: (Map<String, dynamic> arguments) async {
      final ShellConnection link = await _readConnection(ref);
      return jsonEncode(<String, Object?>{
        'panel': 'adbPairing',
        // 已连上就不必等用户：否则续跑后再次调用又会挂起，永远出不来。
        'awaitsUser': !link.connected,
        'connected': link.connected,
        'uid': link.uid,
        'next': link.connected
            ? 'Shell is already connected; call adb_shell_exec instead.'
            : 'Wait for the user to finish pairing on the rendered panel.',
      });
    },
  ),
];

/// 连接态不是推送式的，先失效再读，拿到的是当下原生快照。
Future<ShellConnection> _readConnection(Ref ref) {
  ref.invalidate(shellConnectionProvider);
  return ref.read(shellConnectionProvider.future);
}

int _clampTimeout(int value) {
  if (value < 1000) return 1000;
  return value > _maxTimeoutMs ? _maxTimeoutMs : value;
}

/// 超长输出保留尾部：命令失败的线索通常落在最后几行。
String _truncate(String text) {
  if (text.length <= _maxOutputChars) return text;
  final int cut = text.length - _maxOutputChars;
  return '[truncated $cut chars]\n${text.substring(cut)}';
}
