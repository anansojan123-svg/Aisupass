import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/presentation/providers/tools/tool_schema.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_preflight.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_run_defaults.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';

/// GhostKey（CVE-98260）只读工具。
List<ChatToolDefinition> ghostKeyTools(Ref ref) => <ChatToolDefinition>[
  ChatToolDefinition(
    name: 'ghost_key_preflight',
    description:
        'Run the GhostKey readiness preflight: ADB connection, shell uid, '
        'seccomp, kernel release, profile match and native binary presence.',
    parameters: noArgsSchema,
    execute: (Map<String, dynamic> arguments) async {
      final GhostKeyPreflight preflight = await ref.read(
        ghostKeyPreflightProvider.future,
      );
      return jsonEncode(<String, Object?>{
        'adbConnected': preflight.adbConnected,
        'shellUid': preflight.shellUid,
        'isShell': preflight.isShell,
        'isRoot': preflight.isRoot,
        'seccomp': preflight.seccomp,
        'seccompClean': preflight.seccompClean,
        'release': preflight.release,
        'profileMatched': preflight.profileMatched,
        'binaryPresent': preflight.binaryPresent,
      });
    },
  ),
  ChatToolDefinition(
    name: 'ghost_key_get_run_defaults',
    description:
        'Read persisted GhostKey preferences: whether to take over KernelSU '
        'and whether to accept the fallback page offset.',
    parameters: noArgsSchema,
    execute: (Map<String, dynamic> arguments) async {
      final GhostKeyRunDefaults defaults = await ref.read(
        ghostKeyRunDefaultsProvider.future,
      );
      return jsonEncode(<String, Object?>{
        'runKsu': defaults.runKsu,
        'acceptFallbackPageOffset': defaults.acceptFallbackPageOffset,
      });
    },
  ),
];
