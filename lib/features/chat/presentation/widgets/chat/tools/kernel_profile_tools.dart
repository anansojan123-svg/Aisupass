import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/exploit_run_sessions.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/tool_helpers.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/tool_schema.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile_editor.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile_import_result.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile_import_state.dart';
import 'package:Aisupass/features/escalation/presentation/providers/kernel_profile_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/kernel_profile_query_provider.dart';

/// 本地导入的原生上限，与 Kotlin 侧 `MAX_INPUT` 保持一致（512 MiB）。
const int _maxImportBytes = 0x20000000;

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
        'Start importing a Kernel profile from a single local boot image path '
        'or an OTA URL, and return a session id immediately. Poll with '
        'kernel_profile_import_status. The local-path mode loads the whole file '
        'into memory and only accepts one boot image up to 512 MiB: for '
        'payload.bin, ZIP OTA packages or larger images call '
        'ghost_lock_probe_profile instead.',
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

      // 先做本地预检，把「文件不存在 / 超过内存上限」变成可行动的结论，
      // 避免模型反复重试同一条注定失败的调用。
      if (source == 'path') {
        final File file = File(value);
        if (!file.existsSync()) {
          return jsonEncode(<String, Object?>{
            'ok': false,
            'errorCode': 'notFound',
            'next':
                'The path does not exist. Ask the user to attach the image '
                'again; do not guess its content.',
          });
        }
        final int size = file.lengthSync();
        if (size > _maxImportBytes) {
          return jsonEncode(<String, Object?>{
            'ok': false,
            'errorCode': 'tooLarge',
            'size': size,
            'limit': _maxImportBytes,
            'next':
                'This importer loads the whole file into memory and is capped '
                'at 512 MiB. For payload.bin or an OTA package call '
                'ghost_lock_probe_profile instead; it streams and extracts '
                'boot.img for you.',
          });
        }
      }

      final KernelProfileActions actions = ref.read(
        kernelProfileActionsProvider,
      );
      final Stream<KernelProfileImportState> stream = source == 'path'
          ? actions.importBootImage(path: value)
          : actions.importBootImageFromUrl(url: value);

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
    execute: (Map<String, dynamic> arguments) async =>
        snapshotRunSession(ref, 'kernel_profile_import_start', arguments),
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
    execute: (Map<String, dynamic> arguments) =>
        cancelRunSession(ref, 'kernel_profile_import_start', arguments),
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
