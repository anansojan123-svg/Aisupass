import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/presentation/providers/tools/tool_schema.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_preflight.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';

/// GhostLock 只读工具。
List<ChatToolDefinition> ghostLockTools(Ref ref) => <ChatToolDefinition>[
  ChatToolDefinition(
    name: 'ghost_lock_preflight',
    description:
        'Run the GhostLock readiness preflight: ADB, shell uid, seccomp, '
        'kernel release, matched profile release and route, native binary, '
        'ksud path and profile encoding error.',
    parameters: noArgsSchema,
    execute: (Map<String, dynamic> arguments) async {
      final GhostLockPreflight preflight = await ref.read(
        ghostLockPreflightProvider.future,
      );
      return jsonEncode(<String, Object?>{
        'adbConnected': preflight.adbConnected,
        'shellUid': preflight.shellUid,
        'seccomp': preflight.seccomp,
        'release': preflight.release,
        'profileRelease': preflight.profileRelease,
        'profileMatched': preflight.profileMatched,
        'route': preflight.route,
        'binaryPresent': preflight.binaryPresent,
        'ksudPath': preflight.ksudPath,
        'profileError': preflight.profileError,
      });
    },
  ),
];
