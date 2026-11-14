import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/presentation/providers/tools/tool_schema.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_active_source.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_execution_field.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_probe_progress.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_profile_config.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_profile_field_node.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_user_profile.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';

/// GhostLock profile 文档与配置只读工具。
List<ChatToolDefinition> ghostLockProfileTools(Ref ref) =>
    <ChatToolDefinition>[
      ChatToolDefinition(
        name: 'ghost_lock_list_imported_profiles',
        description:
            'List user-imported GhostLock profiles with release, size, import '
            'time and whether the document failed to parse.',
        parameters: noArgsSchema,
        execute: (Map<String, dynamic> arguments) async {
          final List<GhostLockUserProfile> profiles = await ref.read(
            ghostLockImportedProfilesProvider.future,
          );
          return jsonEncode(<String, Object?>{
            'items': <Map<String, Object?>>[
              for (final GhostLockUserProfile profile in profiles)
                <String, Object?>{
                  'name': profile.name,
                  'release': profile.release,
                  'sizeBytes': profile.sizeBytes,
                  'importedAtMs': profile.importedAtMs,
                  'parseError': profile.parseError,
                },
            ],
          });
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_list_builtin_releases',
        description:
            'List all built-in GhostLock kernel profile releases, sorted by '
            'similarity to the device kernel when available.',
        parameters: noArgsSchema,
        execute: (Map<String, dynamic> arguments) async {
          final List<String> releases = await ref.read(
            ghostLockBuiltinReleasesProvider.future,
          );
          return jsonEncode(<String, Object?>{'items': releases});
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_read_imported_profile',
        description:
            'Read the raw HOCON text of one user-imported GhostLock profile.',
        parameters: objectSchema(
          properties: <String, dynamic>{
            'name': stringProperty(
              description: 'Profile file name, including extension.',
            ),
          },
          required: <String>['name'],
        ),
        execute: (Map<String, dynamic> arguments) async {
          final String name = requireString(arguments, 'name');
          final String text = await ref.read(
            ghostLockImportedProfileContentProvider(name: name).future,
          );
          return jsonEncode(<String, Object?>{'name': name, 'text': text});
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_get_probe_progress',
        description:
            'Read the latest GhostLock kernel table probe progress snapshot.',
        parameters: noArgsSchema,
        execute: (Map<String, dynamic> arguments) async {
          final GhostLockProbeProgress progress = await ref
              .read(ghostLockProfileActionRepositoryProvider)
              .profileProgress();
          return jsonEncode(<String, Object?>{
            'phase': progress.phase,
            'downloading': progress.downloading,
            'finished': progress.finished,
            'done': progress.done,
            'total': progress.total,
            'fraction': progress.fraction,
          });
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_list_extracted_images',
        description:
            'List image files left in the app cache by the last GhostLock '
            'profile extraction.',
        parameters: noArgsSchema,
        execute: (Map<String, dynamic> arguments) async {
          final List<String> paths = await ref
              .read(ghostLockProfileActionRepositoryProvider)
              .listExtractedImages();
          return jsonEncode(<String, Object?>{'items': paths});
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_get_profile_config',
        description:
            'Load the effective GhostLock profile for a kernel release, '
            'merged from builtin, imported and local override layers.',
        parameters: objectSchema(
          properties: <String, dynamic>{
            'release': stringProperty(
              description: 'Kernel release, for example 6.6.57-android14.',
            ),
          },
          required: <String>['release'],
        ),
        execute: (Map<String, dynamic> arguments) async {
          final String release = requireString(arguments, 'release');
          final GhostLockProfileConfig config = await ref
              .read(ghostLockProfileEditActionRepositoryProvider)
              .load(release: release);
          return jsonEncode(_configJson(config));
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_get_active_source',
        description:
            'Read which built-in release and which user profile are currently '
            'selected as the effective GhostLock profile source.',
        parameters: noArgsSchema,
        execute: (Map<String, dynamic> arguments) async {
          final GhostLockActiveSource source = await ref.read(
            ghostLockActiveSourceProvider.future,
          );
          return jsonEncode(<String, Object?>{
            'builtin': source.builtin,
            'user': source.user,
          });
        },
      ),
    ];

Map<String, Object?> _configJson(GhostLockProfileConfig config) =>
    <String, Object?>{
      'release': config.release,
      'hasProfile': config.hasProfile,
      'route': config.route,
      'fallbackTo': config.fallbackTo,
      'invalidPaths': config.invalidPaths,
      'builtinReleases': config.builtinReleases,
      'general': <Map<String, Object?>>[
        for (final GhostLockExecutionField field in config.general)
          <String, Object?>{
            'path': field.path,
            'value': field.value,
            'overridden': field.overridden,
          },
      ],
      'roots': <Map<String, Object?>>[
        for (final GhostLockProfileFieldNode node in config.roots)
          _nodeJson(node),
      ],
    };

Map<String, Object?> _nodeJson(GhostLockProfileFieldNode node) =>
    <String, Object?>{
      'path': node.path,
      'name': node.name,
      'value': node.value,
      'provided': node.provided,
      'overridden': node.overridden,
      'isGroup': node.isGroup,
      if (node.children.isNotEmpty)
        'children': <Map<String, Object?>>[
          for (final GhostLockProfileFieldNode child in node.children)
            _nodeJson(child),
        ],
    };
