import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/exploit_run_sessions.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/tool_helpers.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/tool_schema.dart';
import 'package:Aisupass/features/escalation/domain/models/dirty_frag_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/dirty_frag_run_defaults.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';
import 'package:Aisupass/features/escalation/domain/models/vr_derive_progress.dart';
import 'package:Aisupass/features/escalation/domain/models/vr_offset_result.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';

/// DirtyFrag 工具：状态、偏好、运行会话与 VR 偏移提取。
List<ChatToolDefinition> dirtyFragTools(Ref ref) {
  return <ChatToolDefinition>[
    ChatToolDefinition(
      name: 'dirty_frag_is_armed',
      description:
          'Check whether DirtyFrag has already been injected during the '
          'current boot session.',
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
        return jsonEncode(_defaultsJson(defaults));
      },
    ),
    ChatToolDefinition(
      name: 'dirty_frag_get_expert_mode',
      description: 'Check whether DirtyFrag expert mode is currently enabled.',
      parameters: noArgsSchema,
      execute: (Map<String, dynamic> arguments) async {
        final bool enabled = await ref.read(
          dirtyFragExpertModeProvider.future,
        );
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
        final VrDeriveProgress progress = await ref.read(
          vrDeriveProgressSnapshotProvider.future,
        );
        return jsonEncode(_vrProgressJson(progress));
      },
    ),
    ChatToolDefinition(
      name: 'dirty_frag_save_run_defaults',
      description:
          'Persist DirtyFrag run defaults. Omitted fields keep current values. '
          'Only changes preferences, no run.',
      parameters: objectSchema(
        properties: <String, dynamic>{
          'vrDisarm': boolProperty(description: 'Enable VR countermeasure.'),
          'vrAuto': boolProperty(description: 'Resolve offset automatically.'),
          'vrOffset': intProperty(
            description: 'Manual offset, 1..256; ignored when vrAuto is on.',
            minimum: 0,
            maximum: 256,
          ),
          'softReboot': boolProperty(
            description: 'Soft reboot the manager after success.',
          ),
        },
      ),
      execute: (Map<String, dynamic> arguments) async {
        final DirtyFragRunDefaults current = await ref.read(
          dirtyFragRunDefaultsProvider.future,
        );
        final DirtyFragRunDefaults defaults = current.copyWith(
          vrDisarm: boolArg(arguments, 'vrDisarm', fallback: current.vrDisarm),
          vrAuto: boolArg(arguments, 'vrAuto', fallback: current.vrAuto),
          vrOffset:
              intArg(arguments, 'vrOffset', fallback: current.vrOffset) ??
              current.vrOffset,
          softReboot: boolArg(
            arguments,
            'softReboot',
            fallback: current.softReboot,
          ),
        );
        await ref.read(dirtyFragActionsProvider).saveRunDefaults(defaults);
        return jsonEncode(_defaultsJson(defaults));
      },
    ),
    ChatToolDefinition(
      name: 'dirty_frag_set_expert_mode',
      description: 'Enable or disable DirtyFrag expert mode.',
      parameters: objectSchema(
        properties: <String, dynamic>{
          'enabled': boolProperty(description: 'Target state.'),
        },
        required: <String>['enabled'],
      ),
      execute: (Map<String, dynamic> arguments) async {
        final bool enabled = boolArg(
          arguments,
          'enabled',
          fallback: false,
        );
        await ref.read(dirtyFragActionsProvider).setExpertMode(enabled: enabled);
        return jsonEncode(<String, Object?>{'enabled': enabled});
      },
    ),
    ChatToolDefinition(
      name: 'dirty_frag_set_boot_autostart',
      description:
          'Enable or disable DirtyFrag boot autostart. Changes the component '
          'enabled state.',
      parameters: objectSchema(
        properties: <String, dynamic>{
          'enabled': boolProperty(description: 'Target state.'),
        },
        required: <String>['enabled'],
      ),
      execute: (Map<String, dynamic> arguments) async {
        final bool enabled = boolArg(
          arguments,
          'enabled',
          fallback: false,
        );
        await ref
            .read(dirtyFragActionsProvider)
            .setBootAutostart(enabled: enabled);
        return jsonEncode(<String, Object?>{'enabled': enabled});
      },
    ),
    ChatToolDefinition(
      name: 'dirty_frag_start',
      description:
          'Start one DirtyFrag run and return a session id immediately. Poll '
          'with dirty_frag_status and stop with dirty_frag_cancel. Requires '
          'explicit user confirmation.',
      parameters: objectSchema(
        properties: <String, dynamic>{
          'managerPackage': stringProperty(
            description: 'Manager package; omit to use the selected manager.',
          ),
          'vrOffsetOverride': intProperty(
            description:
                'Temporary manual VR offset for this run only; 1..256.',
            minimum: 1,
            maximum: 256,
          ),
        },
        required: <String>['managerPackage'],
      ),
      execute: (Map<String, dynamic> arguments) async {
        final String packageName = requireString(arguments, 'managerPackage');
        final RootManager? manager = await resolveRootManager(
          ref,
          packageName,
        );
        if (manager == null) {
          throw ArgumentError('Manager not installed: $packageName');
        }

        final ExploitRunRegistry registry = ref.read(
          exploitRunRegistryProvider,
        );
        final ExploitRunSession session = registry.create('dirty_frag_start');
        session.cancel = ref.read(dirtyFragActionsProvider).cancel;
        session.subscription = ref
            .read(dirtyFragActionsProvider)
            .run(
              manager: manager,
              vrOffsetOverride: intArg(arguments, 'vrOffsetOverride'),
            )
            .listen(
              (DirtyFragOutcome outcome) {
                session.appendOutput(outcome.output);
                session.status = outcome.kind.name;
                session.finished = outcome.isFinal;
                session.exitCode = outcome.exitCode;
                session.durationMs = outcome.durationMs;
                session.timedOut = outcome.timedOut;
                session.reason = outcome.reason;
                session.resolvedVrOffset = outcome.resolvedVrOffset;
                session.log = outcome.log;
              },
              onError: (Object error, StackTrace stackTrace) {
                session.status = 'failed';
                session.failure = '$error';
                session.finished = true;
              },
            );
        await Future<void>.delayed(const Duration(milliseconds: 300));
        return jsonEncode(session.toJson());
      },
    ),
    ChatToolDefinition(
      name: 'dirty_frag_status',
      description:
          'Read the latest snapshot of one DirtyFrag run session. Omit '
          'sessionId to read the most recent run.',
      parameters: objectSchema(
        properties: <String, dynamic>{
          'sessionId': stringProperty(
            description: 'Session id returned by dirty_frag_start.',
          ),
        },
      ),
      execute: (Map<String, dynamic> arguments) async =>
          snapshotRunSession(ref, 'dirty_frag_start', arguments),
    ),
    ChatToolDefinition(
      name: 'dirty_frag_cancel',
      description: 'Abort the running DirtyFrag session.',
      parameters: objectSchema(
        properties: <String, dynamic>{
          'sessionId': stringProperty(
            description: 'Session id returned by dirty_frag_start.',
          ),
        },
      ),
      execute: (Map<String, dynamic> arguments) =>
          cancelRunSession(ref, 'dirty_frag_start', arguments),
    ),
    ChatToolDefinition(
      name: 'dirty_frag_derive_vr_offset',
      description:
          'Start an offline VR offset extraction from a boot image, '
          'payload.bin or OTA URL. Returns a session id immediately; poll with '
          'dirty_frag_status.',
      parameters: objectSchema(
        properties: <String, dynamic>{
          'input': stringProperty(
            description: 'Image path, payload.bin path or OTA URL.',
          ),
          'insecure': boolProperty(
            description: 'Allow insecure TLS for the download.',
          ),
        },
        required: <String>['input'],
      ),
      execute: (Map<String, dynamic> arguments) async {
        final String input = requireString(arguments, 'input');
        final bool insecure = boolArg(arguments, 'insecure', fallback: false);

        final ExploitRunRegistry registry = ref.read(
          exploitRunRegistryProvider,
        );
        final ExploitRunSession session = registry.create(
          'dirty_frag_derive_vr_offset',
        );

        Timer? poller;
        unawaited(() async {
          poller = Timer.periodic(const Duration(milliseconds: 400), (_) async {
            final VrDeriveProgress progress = await ref.read(
              vrDeriveProgressSnapshotProvider.future,
            );
            session.fraction = progress.fraction;
            session.durationMs = progress.phase;
          });
          try {
            final VrOffsetResult result = await ref.read(
              deriveVrOffsetProvider(input: input, insecure: insecure).future,
            );
            session.status = result.ok ? 'succeeded' : 'failed';
            session.resolvedVrOffset = result.member > 0 ? '${result.member}' : '';
            session.failure = result.error;
            session.appendOutput(
              'release=${result.release} member=${result.member}',
            );
          } catch (error) {
            session.status = 'failed';
            session.failure = '$error';
          } finally {
            session.finished = true;
            poller?.cancel();
          }
        }());
        session.onCancel = () => poller?.cancel();
        await Future<void>.delayed(const Duration(milliseconds: 300));
        return jsonEncode(session.toJson());
      },
    ),
  ];
}

Map<String, Object?> _defaultsJson(DirtyFragRunDefaults defaults) =>
    <String, Object?>{
      'vrDisarm': defaults.vrDisarm,
      'vrAuto': defaults.vrAuto,
      'vrOffset': defaults.vrOffset,
      'softReboot': defaults.softReboot,
      'hasManualOffset': defaults.hasManualOffset,
      'needsManualOffset': defaults.needsManualOffset,
    };

Map<String, Object?> _vrProgressJson(VrDeriveProgress progress) =>
    <String, Object?>{
      'phase': progress.phase,
      'downloading': progress.downloading,
      'done': progress.done,
      'total': progress.total,
      'fraction': progress.fraction,
    };
