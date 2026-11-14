import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/tool_schema.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_active_source.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_execution_field.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_import_result.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_probe.dart';
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
          final GhostLockProbeProgress progress = await ref.read(
            ghostLockProbeProgressSnapshotProvider.future,
          );
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
          final List<String> paths = await ref.read(
            ghostLockExtractedImagesProvider.future,
          );
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
          final GhostLockProfileConfig config = await ref.read(
            ghostLockProfileConfigProvider(release: release).future,
          );
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
      ChatToolDefinition(
        name: 'ghost_lock_probe_profile',
        description:
            'Parse kernel tables from an image, payload.bin or OTA URL without '
            'saving. Returns the generated GLK profile text for a later '
            'ghost_lock_save_profile call. Long running.',
        parameters: objectSchema(
          properties: <String, dynamic>{
            'input': stringProperty(
              description: 'Boot image path, payload.bin path or OTA URL.',
            ),
            'insecure': boolProperty(
              description: 'Allow insecure TLS for the download.',
            ),
            'xblPath': stringProperty(description: 'Optional xbl image path.'),
            'uefiPath': stringProperty(description: 'Optional uefi image path.'),
            'vendorBootPath': stringProperty(
              description: 'Optional vendor_boot image path.',
            ),
            'phys': stringProperty(
              description: 'Manual kernel physical load address.',
            ),
            'kallsymsPath': stringProperty(
              description: 'Optional external kallsyms text file.',
            ),
            'iomemPath': stringProperty(
              description: 'Optional external iomem text file.',
            ),
            'route': stringProperty(description: 'Force a route token.'),
            'allowMissing': boolProperty(
              description: 'Allow missing fields instead of failing.',
            ),
            'noDisasm': boolProperty(description: 'Skip disassembly.'),
          },
          required: <String>['input'],
        ),
        execute: (Map<String, dynamic> arguments) async {
          final GhostLockProbe probe = await ref
              .read(ghostLockProfileActionsProvider)
              .probeProfile(
                input: requireString(arguments, 'input'),
                insecure: boolArg(arguments, 'insecure', fallback: false),
                xblPath: stringArg(arguments, 'xblPath'),
                uefiPath: stringArg(arguments, 'uefiPath'),
                vendorBootPath: stringArg(arguments, 'vendorBootPath'),
                phys: stringArg(arguments, 'phys'),
                kallsymsPath: stringArg(arguments, 'kallsymsPath'),
                iomemPath: stringArg(arguments, 'iomemPath'),
                route: stringArg(arguments, 'route'),
                allowMissing: boolArg(
                  arguments,
                  'allowMissing',
                  fallback: false,
                ),
                noDisasm: boolArg(arguments, 'noDisasm', fallback: false),
              );
          return jsonEncode(<String, Object?>{
            'ok': probe.ok,
            'release': probe.release,
            'reason': probe.reason,
            'warnings': probe.warnings,
            'bootPath': probe.bootPath,
            'kernelPhysLoad': probe.kernelPhysLoad,
            'kernelPhysOffset': probe.kernelPhysOffset,
            'physSource': probe.physSource,
            'hasKernelPhysLoad': probe.hasKernelPhysLoad,
            'conf': probe.conf,
          });
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_save_profile',
        description:
            'Persist the profile text returned by ghost_lock_probe_profile. '
            'Set overwrite=true only after the user confirms replacing an '
            'existing document.',
        parameters: objectSchema(
          properties: <String, dynamic>{
            'release': stringProperty(description: 'Kernel release.'),
            'conf': stringProperty(description: 'Full GLK profile text.'),
            'overwrite': boolProperty(description: 'Replace existing file.'),
          },
          required: <String>['release', 'conf'],
        ),
        execute: (Map<String, dynamic> arguments) async {
          final result = await ref
              .read(ghostLockProfileActionsProvider)
              .saveProfile(
                release: requireString(arguments, 'release'),
                conf: requireString(arguments, 'conf'),
                overwrite: boolArg(arguments, 'overwrite', fallback: false),
              );
          return jsonEncode(_importResultJson(result));
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_import_profile_text',
        description:
            'Import existing profile text (HOCON or JSON) as a user document.',
        parameters: objectSchema(
          properties: <String, dynamic>{
            'text': stringProperty(description: 'Profile text.'),
            'fileName': stringProperty(description: 'Target file name.'),
            'overwrite': boolProperty(description: 'Replace existing file.'),
          },
          required: <String>['text', 'fileName'],
        ),
        execute: (Map<String, dynamic> arguments) async {
          final result = await ref
              .read(ghostLockProfileActionsProvider)
              .importProfileText(
                text: requireString(arguments, 'text'),
                fileName: requireString(arguments, 'fileName'),
                overwrite: boolArg(arguments, 'overwrite', fallback: false),
              );
          return jsonEncode(_importResultJson(result));
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_rename_imported_profile',
        description: 'Rename a user GhostLock profile document.',
        parameters: objectSchema(
          properties: <String, dynamic>{
            'name': stringProperty(description: 'Current file name.'),
            'newName': stringProperty(description: 'New file name.'),
          },
          required: <String>['name', 'newName'],
        ),
        execute: (Map<String, dynamic> arguments) async {
          final String renamed = await ref
              .read(ghostLockProfileActionsProvider)
              .renameImportedProfile(
                name: requireString(arguments, 'name'),
                newName: requireString(arguments, 'newName'),
              );
          return jsonEncode(<String, Object?>{'newName': renamed});
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_remove_imported_profile',
        description: 'Delete a user GhostLock profile document.',
        parameters: objectSchema(
          properties: <String, dynamic>{
            'name': stringProperty(description: 'File name to delete.'),
          },
          required: <String>['name'],
        ),
        execute: (Map<String, dynamic> arguments) async {
          final bool removed = await ref
              .read(ghostLockProfileActionsProvider)
              .removeImportedProfile(name: requireString(arguments, 'name'));
          return jsonEncode(<String, Object?>{'removed': removed});
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_export_imported_profile',
        description: 'Render one user GhostLock profile as HOCON text.',
        parameters: objectSchema(
          properties: <String, dynamic>{
            'name': stringProperty(description: 'File name.'),
          },
          required: <String>['name'],
        ),
        execute: (Map<String, dynamic> arguments) async {
          final String text = await ref
              .read(ghostLockProfileActionsProvider)
              .exportImportedProfile(name: requireString(arguments, 'name'));
          return jsonEncode(<String, Object?>{'text': text});
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_convert_imported_profile',
        description: 'Convert an old-layout user profile to the current layout.',
        parameters: objectSchema(
          properties: <String, dynamic>{
            'name': stringProperty(description: 'File name.'),
          },
          required: <String>['name'],
        ),
        execute: (Map<String, dynamic> arguments) async {
          final result = await ref
              .read(ghostLockProfileActionsProvider)
              .convertImportedProfile(name: requireString(arguments, 'name'));
          return jsonEncode(_importResultJson(result));
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_export_local_file',
        description: 'Copy a cached file into the phone Download directory.',
        parameters: objectSchema(
          properties: <String, dynamic>{
            'sourcePath': stringProperty(description: 'Cached file path.'),
            'fileName': stringProperty(description: 'Target display name.'),
          },
          required: <String>['sourcePath', 'fileName'],
        ),
        execute: (Map<String, dynamic> arguments) async {
          final String saved = await ref
              .read(ghostLockProfileActionsProvider)
              .exportLocalFile(
                sourcePath: requireString(arguments, 'sourcePath'),
                fileName: requireString(arguments, 'fileName'),
              );
          return jsonEncode(<String, Object?>{'savedAs': saved});
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_update_general_fields',
        description:
            'Write execution tuning values (dotted path to integer) into the '
            'local override layer of one release.',
        parameters: objectSchema(
          properties: <String, dynamic>{
            'release': stringProperty(description: 'Kernel release.'),
            'values': intMapProperty(
              description: 'Dotted path to value, for example {"execution.x":1}.',
            ),
          },
          required: <String>['release', 'values'],
        ),
        execute: (Map<String, dynamic> arguments) async {
          final config = await ref
              .read(ghostLockProfileActionsProvider)
              .updateGeneral(
                release: requireString(arguments, 'release'),
                values: intMapArg(arguments, 'values'),
              );
          return jsonEncode(_configJson(config));
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_update_advanced_fields',
        description:
            'Write advanced field values (dotted path to integer) into the '
            'local override layer of one release.',
        parameters: objectSchema(
          properties: <String, dynamic>{
            'release': stringProperty(description: 'Kernel release.'),
            'values': intMapProperty(
              description: 'Dotted path to value, for example {"task.cred":1}.',
            ),
          },
          required: <String>['release', 'values'],
        ),
        execute: (Map<String, dynamic> arguments) async {
          final config = await ref
              .read(ghostLockProfileActionsProvider)
              .updateAdvanced(
                release: requireString(arguments, 'release'),
                values: intMapArg(arguments, 'values'),
              );
          return jsonEncode(_configJson(config));
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_update_route',
        description:
            'Set the route token for one release; an empty string restores the '
            'profile-declared route.',
        parameters: objectSchema(
          properties: <String, dynamic>{
            'release': stringProperty(description: 'Kernel release.'),
            'route': stringProperty(description: 'Route token.'),
          },
          required: <String>['release', 'route'],
        ),
        execute: (Map<String, dynamic> arguments) async {
          final config = await ref
              .read(ghostLockProfileActionsProvider)
              .updateRoute(
                release: requireString(arguments, 'release'),
                route: stringArg(arguments, 'route'),
              );
          return jsonEncode(_configJson(config));
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_update_fallback',
        description:
            'Set the fallback target; "none" disables, empty string removes the '
            'declaration.',
        parameters: objectSchema(
          properties: <String, dynamic>{
            'release': stringProperty(description: 'Kernel release.'),
            'fallbackTo': stringProperty(description: 'Fallback target.'),
          },
          required: <String>['release', 'fallbackTo'],
        ),
        execute: (Map<String, dynamic> arguments) async {
          final config = await ref
              .read(ghostLockProfileActionsProvider)
              .updateFallback(
                release: requireString(arguments, 'release'),
                fallbackTo: stringArg(arguments, 'fallbackTo'),
              );
          return jsonEncode(_configJson(config));
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_reset_profile',
        description:
            'Clear every local override for one release. scope accepts all, '
            'general or advanced.',
        parameters: objectSchema(
          properties: <String, dynamic>{
            'release': stringProperty(description: 'Kernel release.'),
            'scope': stringProperty(
              description: 'Which overrides to clear.',
              allowedValues: <String>['all', 'general', 'advanced'],
            ),
          },
          required: <String>['release', 'scope'],
        ),
        execute: (Map<String, dynamic> arguments) async {
          final String release = requireString(arguments, 'release');
          final String scope = oneOfArg(
            arguments,
            'scope',
            const <String>['all', 'general', 'advanced'],
          );
          final actions = ref.read(ghostLockProfileActionsProvider);
          final config = switch (scope) {
            'general' => await actions.resetGeneral(release: release),
            'advanced' => await actions.resetAdvanced(release: release),
            _ => await actions.resetProfile(release: release),
          };
          return jsonEncode(_configJson(config));
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_select_source',
        description:
            'Choose the effective built-in release and/or user profile for one '
            'release. Empty strings clear the selection.',
        parameters: objectSchema(
          properties: <String, dynamic>{
            'release': stringProperty(description: 'Kernel release.'),
            'builtinRelease': stringProperty(
              description: 'Built-in table release; empty restores device.',
            ),
            'userProfile': stringProperty(
              description: 'User document name; empty disables the layer.',
            ),
          },
          required: <String>['release'],
        ),
        execute: (Map<String, dynamic> arguments) async {
          final String release = requireString(arguments, 'release');
          final String builtin = stringArg(arguments, 'builtinRelease');
          final String user = stringArg(arguments, 'userProfile');
          final actions = ref.read(ghostLockProfileActionsProvider);
          GhostLockProfileConfig config = await actions.selectBuiltin(
            release: release,
            profileRelease: builtin,
          );
          config = await actions.selectUserProfile(
            release: release,
            name: user,
          );
          return jsonEncode(_configJson(config));
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_render_profile',
        description: 'Render the effective configuration as HOCON text.',
        parameters: objectSchema(
          properties: <String, dynamic>{
            'release': stringProperty(description: 'Kernel release.'),
          },
          required: <String>['release'],
        ),
        execute: (Map<String, dynamic> arguments) async {
          final String text = await ref
              .read(ghostLockProfileActionsProvider)
              .renderProfile(release: requireString(arguments, 'release'));
          return jsonEncode(<String, Object?>{'text': text});
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_export_profile',
        description: 'Export the effective configuration to a local file.',
        parameters: objectSchema(
          properties: <String, dynamic>{
            'release': stringProperty(description: 'Kernel release.'),
            'path': stringProperty(description: 'Target file path.'),
          },
          required: <String>['release', 'path'],
        ),
        execute: (Map<String, dynamic> arguments) async {
          final bool ok = await ref
              .read(ghostLockProfileActionsProvider)
              .exportProfile(
                release: requireString(arguments, 'release'),
                path: requireString(arguments, 'path'),
              );
          return jsonEncode(<String, Object?>{'ok': ok});
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_save_modified_profile',
        description:
            'Save the effective configuration as a new user document.',
        parameters: objectSchema(
          properties: <String, dynamic>{
            'release': stringProperty(description: 'Kernel release.'),
          },
          required: <String>['release'],
        ),
        execute: (Map<String, dynamic> arguments) async {
          final bool ok = await ref
              .read(ghostLockProfileActionsProvider)
              .saveModified(release: requireString(arguments, 'release'));
          return jsonEncode(<String, Object?>{'ok': ok});
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_overwrite_profile',
        description:
            'Write the effective configuration back into a user document and '
            'clear that release overrides.',
        parameters: objectSchema(
          properties: <String, dynamic>{
            'release': stringProperty(description: 'Kernel release.'),
            'name': stringProperty(description: 'Target user document.'),
          },
          required: <String>['release', 'name'],
        ),
        execute: (Map<String, dynamic> arguments) async {
          final bool ok = await ref
              .read(ghostLockProfileActionsProvider)
              .overwriteProfile(
                release: requireString(arguments, 'release'),
                name: requireString(arguments, 'name'),
              );
          return jsonEncode(<String, Object?>{'ok': ok});
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_begin_edit_session',
        description:
            'Open an edit session on a user document, or on the built-in / '
            'device state when name is empty.',
        parameters: objectSchema(
          properties: <String, dynamic>{
            'name': stringProperty(description: 'User document name.'),
            'deviceRelease': stringProperty(description: 'Device kernel release.'),
          },
          required: <String>['deviceRelease'],
        ),
        execute: (Map<String, dynamic> arguments) async {
          final config = await ref
              .read(ghostLockProfileActionsProvider)
              .beginEditSession(
                name: stringArg(arguments, 'name'),
                deviceRelease: requireString(arguments, 'deviceRelease'),
              );
          return jsonEncode(_configJson(config));
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_reload_edit_session',
        description: 'Discard unsaved edits and re-parse the session target.',
        parameters: noArgsSchema,
        execute: (Map<String, dynamic> arguments) async {
          final config = await ref
              .read(ghostLockProfileActionsProvider)
              .reloadEditSession();
          return jsonEncode(_configJson(config));
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_get_edit_session',
        description:
            'Read edit session state: whether it targets the live config, its '
            'target document and its release.',
        parameters: noArgsSchema,
        execute: (Map<String, dynamic> arguments) async {
          final actions = ref.read(ghostLockProfileActionsProvider);
          return jsonEncode(<String, Object?>{
            'isLive': await actions.editSessionIsLive(),
            'target': await actions.editSessionTarget(),
            'release': await actions.editSessionRelease(),
          });
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_commit_edit_session',
        description: 'Write the session overrides into the live override layer.',
        parameters: noArgsSchema,
        execute: (Map<String, dynamic> arguments) async {
          final bool ok = await ref
              .read(ghostLockProfileActionsProvider)
              .commitEditSession();
          return jsonEncode(<String, Object?>{'ok': ok});
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_save_edit_session_in_place',
        description: 'Overwrite the target document with the session result.',
        parameters: noArgsSchema,
        execute: (Map<String, dynamic> arguments) async {
          final bool ok = await ref
              .read(ghostLockProfileActionsProvider)
              .saveEditSessionInPlace();
          return jsonEncode(<String, Object?>{'ok': ok});
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_save_edit_session_as_new',
        description: 'Save the session result as a new user document.',
        parameters: noArgsSchema,
        execute: (Map<String, dynamic> arguments) async {
          final String name = await ref
              .read(ghostLockProfileActionsProvider)
              .saveEditSessionAsNew();
          return jsonEncode(<String, Object?>{'newName': name});
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_export_edit_session',
        description: 'Export the session result to a local file.',
        parameters: objectSchema(
          properties: <String, dynamic>{
            'path': stringProperty(description: 'Target file path.'),
          },
          required: <String>['path'],
        ),
        execute: (Map<String, dynamic> arguments) async {
          final bool ok = await ref
              .read(ghostLockProfileActionsProvider)
              .exportEditSession(path: requireString(arguments, 'path'));
          return jsonEncode(<String, Object?>{'ok': ok});
        },
      ),
      ChatToolDefinition(
        name: 'ghost_lock_end_edit_session',
        description: 'Close the current edit session.',
        parameters: noArgsSchema,
        execute: (Map<String, dynamic> arguments) async {
          await ref.read(ghostLockProfileActionsProvider).endEditSession();
          return jsonEncode(<String, Object?>{'closed': true});
        },
      ),
    ];

Map<String, Object?> _importResultJson(GhostLockImportResult result) =>
    <String, Object?>{
      'ok': result.ok,
      'release': result.release,
      'fileName': result.fileName,
      'reason': result.reason,
      'requiresOverwrite': result.requiresOverwrite,
    };

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
