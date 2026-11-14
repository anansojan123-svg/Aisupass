import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/exploit_run_sessions.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/tool_schema.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile_editor.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile_import_result.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile_import_state.dart';
import 'package:Aisupass/features/escalation/domain/repositories/kernel_profile_action_repository.dart';
import 'package:Aisupass/features/escalation/presentation/providers/kernel_profile_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/kernel_profile_query_provider.dart';

/// Kernel profile（CVE-98260）只读工具。
List<ChatToolDefinition> kernelProfileTools(Ref ref) => <ChatToolDefinition>[
  ChatToolDefinition(
    name: 'kernel_profile_list_imported',
    description: 'List user-imported Kernel profile documents.',
    parameters: noArgsSchema,
    execute: (Map<String, dynamic> arguments) async {
      final List<KernelProfile> profiles = await ref.read(
        kernelProfileListProvider.future,
      );
      return jsonEncode(<String, Object?>{
        'items': <Map<String, Object?>>[
          for (final KernelProfile profile in profiles) _profileJson(profile),
        ],
      });
    },
  ),
  ChatToolDefinition(
    name: 'kernel_profile_list_builtin',
    description: 'List built-in Kernel profiles, excluding user documents.',
    parameters: noArgsSchema,
    execute: (Map<String, dynamic> arguments) async {
      final List<KernelProfile> profiles = await ref.read(
        kernelProfileBuiltinListProvider.future,
      );
      return jsonEncode(<String, Object?>{
        'items': <Map<String, Object?>>[
          for (final KernelProfile profile in profiles) _profileJson(profile),
        ],
      });
    },
  ),
  ChatToolDefinition(
    name: 'kernel_profile_read_content',
    description:
        'Read the raw HOCON text of a Kernel profile. Pass name for a user '
        'document, or release for a built-in profile.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'name': stringProperty(
          description: 'User document name including extension.',
        ),
        'release': stringProperty(
          description: 'Built-in profile release, used when name is empty.',
        ),
      },
    ),
    execute: (Map<String, dynamic> arguments) async {
      final String name = stringArg(arguments, 'name');
      final String release = stringArg(arguments, 'release');
      if (name.isEmpty && release.isEmpty) {
        throw ArgumentError('Either name or release is required');
      }
      final String text = await ref.read(
        kernelProfileContentProvider(name: name, release: release).future,
      );
      return jsonEncode(<String, Object?>{
        'name': name,
        'release': release,
        'text': text,
      });
    },
  ),
  ChatToolDefinition(
    name: 'kernel_profile_read_editor',
    description:
        'Read editable fields of a user Kernel profile document. An empty name '
        'returns an unavailable editor state.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'name': stringProperty(
          description: 'User document name including extension.',
        ),
      },
    ),
    execute: (Map<String, dynamic> arguments) async {
      final String name = stringArg(arguments, 'name');
      final KernelProfileEditorState state = await ref.read(
        kernelProfileEditorProvider(name: name).future,
      );
      return jsonEncode(<String, Object?>{
        'available': state.available,
        'name': state.name,
        'release': state.release,
        'vulnType': state.vulnType,
        'detail': state.detail,
        'fields': <Map<String, Object?>>[
          for (final KernelProfileEditorField field in state.fields)
            <String, Object?>{
              'path': field.path,
              'name': field.name,
              'value': field.value,
              'hex': field.hex,
              'advanced': field.advanced,
            },
        ],
      });
    },
  ),
  ChatToolDefinition(
    name: 'kernel_profile_get_active_selection',
    description:
        'Read the currently selected Kernel profile sources: active user '
        'document name and active built-in release.',
    parameters: noArgsSchema,
    execute: (Map<String, dynamic> arguments) async {
      final String name = await ref.read(
        kernelProfileActiveNameProvider.future,
      );
      final String builtin = await ref.read(
        kernelProfileActiveBuiltinProvider.future,
      );
      return jsonEncode(<String, Object?>{
        'activeUserProfile': name,
        'activeBuiltinRelease': builtin,
      });
    },
  ),
  ChatToolDefinition(
    name: 'kernel_profile_import_start',
    description:
        'Start importing a Kernel profile from a local boot.img path or an OTA '
        'URL, and return a session id immediately. Poll with '
        'kernel_profile_import_status.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'source': stringProperty(
          description: 'Where the image comes from.',
          allowedValues: <String>['path', 'url'],
        ),
        'value': stringProperty(
          description: 'boot.img path when source is path, OTA URL otherwise.',
        ),
      },
      required: <String>['source', 'value'],
    ),
    execute: (Map<String, dynamic> arguments) async {
      final String source = oneOfArg(
        arguments,
        'source',
        const <String>['path', 'url'],
      );
      final String value = requireString(arguments, 'value');
      final KernelProfileActionRepository repository = ref.read(
        kernelProfileActionRepositoryProvider,
      );
      final Stream<KernelProfileImportState> stream =
          source == 'path'
          ? repository.importBootImage(path: value)
          : repository.importBootImageFromUrl(url: value);

      final ExploitRunRegistry registry = ref.read(
        exploitRunRegistryProvider,
      );
      final ExploitRunSession session = registry.create(
        'kernel_profile_import_start',
      );

      void applyState(KernelProfileImportState state) {
        session.fraction = state.fraction;
        session.finished = state.finished;
        if (!state.finished) {
          session.status = 'running';
          return;
        }
        session.status = state.result.ok ? 'succeeded' : 'failed';
        session.failure = state.result.error;
        session.extra = _importStateJson(state);
      }

      session.subscription = stream.listen(
        applyState,
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
    name: 'kernel_profile_import_status',
    description:
        'Read the latest snapshot of one Kernel profile import session. Omit '
        'sessionId to read the most recent import.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'sessionId': stringProperty(
          description: 'Session id returned by kernel_profile_import_start.',
        ),
      },
    ),
    execute: (Map<String, dynamic> arguments) async {
      final ExploitRunRegistry registry = ref.read(
        exploitRunRegistryProvider,
      );
      final String id = stringArg(arguments, 'sessionId');
      final ExploitRunSession? session = id.isEmpty
          ? registry.latest('kernel_profile_import_start')
          : registry.find(id);
      if (session == null) {
        return jsonEncode(<String, Object?>{'found': false});
      }
      return jsonEncode(<String, Object?>{'found': true, ...session.toJson()});
    },
  ),
  ChatToolDefinition(
    name: 'kernel_profile_import_cancel',
    description:
        'Stop reading the current Kernel profile import. The native import is '
        'not signalled and may still finish in the background.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'sessionId': stringProperty(
          description: 'Session id returned by kernel_profile_import_start.',
        ),
      },
    ),
    execute: (Map<String, dynamic> arguments) async {
      final ExploitRunRegistry registry = ref.read(
        exploitRunRegistryProvider,
      );
      final String id = stringArg(arguments, 'sessionId');
      final ExploitRunSession? session = id.isEmpty
          ? registry.latest('kernel_profile_import_start')
          : registry.find(id);
      if (session == null) {
        return jsonEncode(<String, Object?>{'found': false});
      }
      await session.subscription?.cancel();
      session.subscription = null;
      await session.cancel?.call();
      session.onCancel?.call();
      session.status = 'cancelled';
      session.finished = true;
      return jsonEncode(<String, Object?>{'found': true, ...session.toJson()});
    },
  ),
  ChatToolDefinition(
    name: 'kernel_profile_remove',
    description: 'Delete a user Kernel profile document.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'name': stringProperty(description: 'Document name.'),
      },
      required: <String>['name'],
    ),
    execute: (Map<String, dynamic> arguments) async {
      final bool removed = await ref
          .read(kernelProfileActionsProvider)
          .remove(requireString(arguments, 'name'));
      return jsonEncode(<String, Object?>{'removed': removed});
    },
  ),
  ChatToolDefinition(
    name: 'kernel_profile_save_editor',
    description:
        'Write editor values (dotted path to decimal string) back into the '
        'same document. Validated before saving.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'name': stringProperty(description: 'Document name.'),
        'values': stringMapProperty(
          description: 'Dotted path to value, for example {"offset.x":"12"}.',
        ),
      },
      required: <String>['name', 'values'],
    ),
    execute: (Map<String, dynamic> arguments) async {
      final result = await ref
          .read(kernelProfileActionsProvider)
          .saveEditor(
            name: requireString(arguments, 'name'),
            values: stringMapArg(arguments, 'values'),
          );
      return jsonEncode(_importResultJson(result));
    },
  ),
  ChatToolDefinition(
    name: 'kernel_profile_save_editor_as',
    description:
        'Save editor values as a new user document. Returns the new name, '
        'empty when it failed.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'name': stringProperty(description: 'Source document name.'),
        'documentName': stringProperty(description: 'New document name.'),
        'values': stringMapProperty(description: 'Dotted path to value.'),
      },
      required: <String>['name', 'documentName', 'values'],
    ),
    execute: (Map<String, dynamic> arguments) async {
      final String saved = await ref
          .read(kernelProfileActionsProvider)
          .saveEditorAs(
            name: requireString(arguments, 'name'),
            documentName: requireString(arguments, 'documentName'),
            values: stringMapArg(arguments, 'values'),
          );
      return jsonEncode(<String, Object?>{'newName': saved});
    },
  ),
  ChatToolDefinition(
    name: 'kernel_profile_render_editor',
    description: 'Render edited values as HOCON text without saving.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'name': stringProperty(description: 'Document name.'),
        'values': stringMapProperty(description: 'Dotted path to value.'),
      },
      required: <String>['name', 'values'],
    ),
    execute: (Map<String, dynamic> arguments) async {
      final String text = await ref
          .read(kernelProfileActionsProvider)
          .renderEditor(
            name: requireString(arguments, 'name'),
            values: stringMapArg(arguments, 'values'),
          );
      return jsonEncode(<String, Object?>{'text': text});
    },
  ),
  ChatToolDefinition(
    name: 'kernel_profile_select_user_profile',
    description:
        'Select the effective user document. An empty name clears the '
        'selection.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'name': stringProperty(description: 'Document name; empty clears.'),
      },
      required: <String>['name'],
    ),
    execute: (Map<String, dynamic> arguments) async {
      final bool ok = await ref
          .read(kernelProfileActionsProvider)
          .select(stringArg(arguments, 'name'));
      return jsonEncode(<String, Object?>{'ok': ok});
    },
  ),
  ChatToolDefinition(
    name: 'kernel_profile_select_builtin_release',
    description:
        'Select the effective built-in profile release. An empty string '
        'clears the selection.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'release': stringProperty(description: 'Built-in release; empty clears.'),
      },
      required: <String>['release'],
    ),
    execute: (Map<String, dynamic> arguments) async {
      final bool ok = await ref
          .read(kernelProfileActionsProvider)
          .selectBuiltin(stringArg(arguments, 'release'));
      return jsonEncode(<String, Object?>{'ok': ok});
    },
  ),
];

Map<String, Object?> _importResultJson(KernelProfileImportResult result) =>
    <String, Object?>{
      'ok': result.ok,
      'release': result.release,
      'missing': result.missing,
      'errorCode': result.errorCode,
      'error': result.error,
    };

Map<String, Object?> _importStateJson(KernelProfileImportState state) =>
    <String, Object?>{
      'phase': state.phase,
      'done': state.done,
      'total': state.total,
      'fraction': state.fraction,
      'finished': state.finished,
      'failed': state.failed,
      'result': _importResultJson(state.result),
    };

Map<String, Object?> _profileJson(KernelProfile profile) => <String, Object?>{
  'name': profile.name,
  'release': profile.release,
  'detail': profile.detail,
  'isUserDocument': profile.isUserDocument,
};
