import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/presentation/providers/tools/tool_schema.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile_editor.dart';
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
    name: 'kernel_profile_get_import_progress',
    description:
        'Read the current Kernel profile import progress as a '
        '"<phase> <done> <total>" string.',
    parameters: noArgsSchema,
    execute: (Map<String, dynamic> arguments) async {
      final String progress = await ref
          .read(kernelProfileQueryRepositoryProvider)
          .importProgress();
      return jsonEncode(<String, Object?>{'progress': progress});
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
];

Map<String, Object?> _profileJson(KernelProfile profile) => <String, Object?>{
  'name': profile.name,
  'release': profile.release,
  'detail': profile.detail,
  'isUserDocument': profile.isUserDocument,
};
