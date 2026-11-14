import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/presentation/providers/tools/tool_schema.dart';
import 'package:Aisupass/features/escalation/domain/models/dirty_frag_run_defaults.dart';
import 'package:Aisupass/features/escalation/domain/models/vr_derive_progress.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';

/// DirtyFrag 只读工具。
List<ChatToolDefinition> dirtyFragTools(Ref ref) => <ChatToolDefinition>[
  ChatToolDefinition(
    name: 'dirty_frag_is_armed',
    description:
        'Check whether DirtyFrag has already been injected during the current '
        'boot session.',
    parameters: noArgsSchema,
    execute: (Map<String, dynamic> arguments) async {
      final bool armed = await ref.read(dirtyFragArmedProvider.future);
      return jsonEncode(<String, Object?>{'armed': armed});
    },
  ),
  ChatToolDefinition(
    name: 'dirty_frag_get_run_defaults',
    description:
        'Read persisted DirtyFrag run defaults: VR disarm, VR auto offset '
        'resolution, manual offset and soft reboot after success.',
    parameters: noArgsSchema,
    execute: (Map<String, dynamic> arguments) async {
      final DirtyFragRunDefaults defaults = await ref.read(
        dirtyFragRunDefaultsProvider.future,
      );
      return jsonEncode(<String, Object?>{
        'vrDisarm': defaults.vrDisarm,
        'vrAuto': defaults.vrAuto,
        'vrOffset': defaults.vrOffset,
        'softReboot': defaults.softReboot,
        'hasManualOffset': defaults.hasManualOffset,
        'needsManualOffset': defaults.needsManualOffset,
      });
    },
  ),
  ChatToolDefinition(
    name: 'dirty_frag_get_expert_mode',
    description:
        'Check whether DirtyFrag expert mode is currently enabled.',
    parameters: noArgsSchema,
    execute: (Map<String, dynamic> arguments) async {
      final bool enabled = await ref.read(dirtyFragExpertModeProvider.future);
      return jsonEncode(<String, Object?>{'enabled': enabled});
    },
  ),
  ChatToolDefinition(
    name: 'dirty_frag_get_boot_autostart',
    description:
        'Check whether DirtyFrag boot autostart is enabled. The source of '
        'truth is the component enabled state.',
    parameters: noArgsSchema,
    execute: (Map<String, dynamic> arguments) async {
      final bool enabled = await ref.read(
        dirtyFragBootAutostartProvider.future,
      );
      return jsonEncode(<String, Object?>{'enabled': enabled});
    },
  ),
  ChatToolDefinition(
    name: 'dirty_frag_get_vr_progress',
    description:
        'Read the latest offline VR offset extraction progress snapshot.',
    parameters: noArgsSchema,
    execute: (Map<String, dynamic> arguments) async {
      final VrDeriveProgress progress = await ref
          .read(dirtyFragActionRepositoryProvider)
          .vrDeriveProgress();
      return jsonEncode(<String, Object?>{
        'phase': progress.phase,
        'downloading': progress.downloading,
        'done': progress.done,
        'total': progress.total,
        'fraction': progress.fraction,
      });
    },
  ),
];
