import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/routes/app_route.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_execution_field.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_profile_config.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_profile_field_node.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_user_profile.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/ghost_lock_profile_field_tree.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// GhostLock 内核表编辑器：通用参数、路由、高级字段三个页签。
///
/// 所有编辑都落 sparse override，导入的 conf 原文不动。
class GhostLockProfilePage extends HookConsumerWidget {
  const GhostLockProfilePage({super.key, required this.release});

  /// 设备内核 release，用于定位要编辑的内核表。
  final String release;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final AsyncValue<GhostLockProfileConfig> configAsync = ref.watch(
      ghostLockProfileConfigProvider(release: release),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.escalationGhostLockProfileEdit),
        actions: <Widget>[
          IconButton(
            tooltip: l10n.escalationGhostLockImportTitle,
            onPressed: () => context.push(
              AppRoute.kernelProfilePath(tab: 'ghostlock'),
            ),
            icon: Icon(Icons.file_download_outlined, size: 20.sp),
          ),
          IconButton(
            tooltip: l10n.escalationGhostLockProfileSelect,
            onPressed: () => _selectSource(context, ref, configAsync.value),
            icon: Icon(Icons.tune_rounded, size: 20.sp),
          ),
          IconButton(
            tooltip: l10n.escalationGhostLockProfileReset,
            onPressed: () => _reset(ref),
            icon: Icon(Icons.restart_alt_rounded, size: 20.sp),
          ),
          IconButton(
            tooltip: l10n.escalationGhostLockProfileExport,
            onPressed: () => _export(context, ref, configAsync.value),
            icon: Icon(Icons.save_alt_rounded, size: 20.sp),
          ),
          IconButton(
            tooltip: l10n.escalationGhostLockProfileSaveAs,
            onPressed: () => _saveAs(ref),
            icon: Icon(Icons.copy_all_rounded, size: 20.sp),
          ),
        ],
      ),
      body: configAsync.when(
        loading: () => const Loading(),
        error: (Object error, StackTrace stackTrace) => RefError(
          onRetry: () => ref.invalidate(
            ghostLockProfileConfigProvider(release: release),
          ),
        ),
        data: (GhostLockProfileConfig config) {
          if (!config.hasProfile) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Text(
                  l10n.escalationGhostLockProfileNoProfile,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }
          return _ProfileTabs(config: config);
        },
      ),
    );
  }

  Future<void> _reset(WidgetRef ref) async {
    try {
      await ref.read(ghostLockProfileActionsProvider).reset(release: release);
    } catch (error) {
      ToastMessage.error(error);
    }
  }

  Future<void> _export(
    BuildContext context,
    WidgetRef ref,
    GhostLockProfileConfig? config,
  ) async {
    if (config == null) return;
    try {
      final String? path = await FilePicker.saveFile(
        dialogTitle: context.l10n.escalationGhostLockProfileExport,
        fileName: '${release.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_')}.conf',
        type: FileType.any,
      );
      if (path == null) return;
      await ref
          .read(ghostLockProfileActionsProvider)
          .exportProfile(release: release, path: path);
    } catch (error) {
      ToastMessage.error(error);
    }
  }

  Future<void> _saveAs(WidgetRef ref) async {
    try {
      await ref.read(ghostLockProfileActionsProvider).saveModified(release: release);
    } catch (error) {
      ToastMessage.error(error);
    }
  }

  /// 打开「生效来源」选择：内置表与我的配置是两个独立的层。
  Future<void> _selectSource(
    BuildContext context,
    WidgetRef ref,
    GhostLockProfileConfig? config,
  ) async {
    if (config == null) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) => _SourceSheet(
        release: release,
        builtinReleases: config.builtinReleases,
        onSelectBuiltin: (String profileRelease) =>
            _applySelection(ref, builtin: profileRelease),
        onSelectUserProfile: (String name) =>
            _applySelection(ref, userProfile: name),
      ),
    );
  }

  Future<void> _applySelection(
    WidgetRef ref, {
    String? builtin,
    String? userProfile,
  }) async {
    try {
      final GhostLockProfileActions actions = ref.read(
        ghostLockProfileActionsProvider,
      );
      if (builtin != null) {
        await actions.selectBuiltin(release: release, profileRelease: builtin);
      }
      if (userProfile != null) {
        await actions.selectUserProfile(release: release, name: userProfile);
      }
      ref.invalidate(ghostLockImportedProfilesProvider);
    } catch (error) {
      ToastMessage.error(error);
    }
  }
}

/// 生效来源弹窗：内置表与我的配置分段选择，空串表示不指定。
class _SourceSheet extends HookConsumerWidget {
  const _SourceSheet({
    required this.release,
    required this.builtinReleases,
    required this.onSelectBuiltin,
    required this.onSelectUserProfile,
  });

  final String release;
  final List<String> builtinReleases;
  final void Function(String profileRelease) onSelectBuiltin;
  final void Function(String name) onSelectUserProfile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final TextEditingController filter = useTextEditingController();
    final ValueNotifier<String> keyword = useState<String>('');
    final AsyncValue<List<GhostLockUserProfile>> importedAsync = ref.watch(
      ghostLockImportedProfilesProvider,
    );
    final String lower = keyword.value.trim().toLowerCase();
    final List<String> matches = lower.isEmpty
        ? builtinReleases
        : builtinReleases
              .where((String item) => item.toLowerCase().contains(lower))
              .toList();

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
              child: Text(
                l10n.escalationGhostLockProfileSelect,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.auto_awesome_rounded, size: 18.sp),
              title: Text(
                l10n.escalationGhostLockProfileSelectAuto,
                style: TextStyle(fontSize: 13.sp),
              ),
              subtitle: Text(
                release,
                style: TextStyle(
                  fontFamily: AppFonts.code,
                  fontSize: 11.sp,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                onSelectBuiltin('');
              },
            ),
            Divider(height: 1.h),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 6.h),
              child: Text(
                l10n.escalationGhostLockProfileSelectBuiltin,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: TextField(
                controller: filter,
                onChanged: (String value) => keyword.value = value,
                style: TextStyle(fontSize: 12.5.sp),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: l10n.escalationGhostLockProfileSelectSearch,
                  hintStyle: TextStyle(fontSize: 12.sp),
                  prefixIcon: Icon(Icons.search_rounded, size: 16.sp),
                  border: const OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 10.h,
                  ),
                ),
              ),
            ),
            SizedBox(height: 6.h),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.35,
              child: ListView.builder(
                itemCount: matches.length,
                itemBuilder: (BuildContext context, int index) {
                  final String item = matches[index];
                  return ListTile(
                    dense: true,
                    title: Text(
                      item,
                      style: TextStyle(
                        fontFamily: AppFonts.code,
                        fontSize: 11.5.sp,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      onSelectBuiltin(item);
                    },
                  );
                },
              ),
            ),
            Divider(height: 1.h),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 6.h),
              child: Text(
                l10n.escalationGhostLockProfileSelectUser,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
            importedAsync.when(
              loading: () => SizedBox(height: 48.h, child: const Loading()),
              error: (Object error, StackTrace stackTrace) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  l10n.commonLoadFailed,
                  style: TextStyle(fontSize: 12.sp, color: scheme.error),
                ),
              ),
              data: (List<GhostLockUserProfile> profiles) {
                if (profiles.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
                    child: Text(
                      l10n.escalationGhostLockImportedEmpty,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ListTile(
                      dense: true,
                      leading: Icon(Icons.block_rounded, size: 18.sp),
                      title: Text(
                        l10n.escalationGhostLockProfileSelectNoUser,
                        style: TextStyle(fontSize: 13.sp),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        onSelectUserProfile('');
                      },
                    ),
                    SizedBox(
                      height: 140.h,
                      child: ListView.builder(
                        itemCount: profiles.length,
                        itemBuilder: (BuildContext context, int index) {
                          final GhostLockUserProfile profile = profiles[index];
                          return ListTile(
                            dense: true,
                            title: Text(
                              profile.parseError ? profile.name : profile.release,
                              style: TextStyle(
                                fontFamily: AppFonts.code,
                                fontSize: 11.5.sp,
                              ),
                            ),
                            subtitle: Text(
                              profile.name,
                              style: TextStyle(fontSize: 10.5.sp),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              onSelectUserProfile(profile.name);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}

/// 三个页签的骨架；违规字段在「高级」页签上挂红点。
class _ProfileTabs extends HookWidget {
  const _ProfileTabs({required this.config});

  final GhostLockProfileConfig config;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final bool hasInvalid = config.invalidPaths.isNotEmpty;

    return DefaultTabController(
      length: 3,
      child: Column(
        children: <Widget>[
          TabBar(
            tabs: <Widget>[
              Tab(text: l10n.escalationGhostLockProfileTabGeneral),
              Tab(text: l10n.escalationGhostLockProfileTabRoute),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(l10n.escalationGhostLockProfileTabAdvanced),
                    if (hasInvalid) ...<Widget>[
                      SizedBox(width: 4.w),
                      Icon(Icons.circle, size: 6.sp, color: scheme.error),
                    ],
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: <Widget>[
                _GeneralTab(release: config.release, general: config.general),
                _RouteTab(config: config),
                _AdvancedTab(config: config),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 通用参数页：每行一个 execution 调参，失焦提交。
class _GeneralTab extends HookConsumerWidget {
  const _GeneralTab({required this.release, required this.general});

  final String release;
  final List<GhostLockExecutionField> general;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (general.isEmpty) return const SizedBox.shrink();
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: general.length,
      itemBuilder: (BuildContext context, int index) {
        final GhostLockExecutionField field = general[index];
        return _GeneralFieldRow(
          field: field,
          onSubmit: (int value) => _submit(ref, field.path, value),
        );
      },
    );
  }

  Future<void> _submit(WidgetRef ref, String path, int value) async {
    try {
      await ref
          .read(ghostLockProfileActionsProvider)
          .updateGeneral(
            release: release,
            values: <String, int>{path: value},
          );
    } catch (error) {
      ToastMessage.error(error);
    }
  }
}

/// 通用参数行：末段键名 + 数字输入框 + override 标记。
class _GeneralFieldRow extends HookWidget {
  const _GeneralFieldRow({required this.field, required this.onSubmit});

  final GhostLockExecutionField field;
  final void Function(int value) onSubmit;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    final TextEditingController controller = useTextEditingController(
      text: '${field.value}',
    );
    final FocusNode focusNode = useFocusNode();

    void submit() {
      final int? value = int.tryParse(controller.text.trim());
      if (value == null || value == field.value) return;
      onSubmit(value);
    }

    useEffect(() {
      void onFocusChanged() {
        if (!focusNode.hasFocus) submit();
      }

      focusNode.addListener(onFocusChanged);
      return () => focusNode.removeListener(onFocusChanged);
    }, <Object?>[focusNode, controller, field.value]);

    useEffect(() {
      final String next = '${field.value}';
      if (!focusNode.hasFocus && controller.text != next) controller.text = next;
      return null;
    }, <Object?>[field.value, focusNode, controller]);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 8.w,
            child: field.overridden
                ? Icon(Icons.circle, size: 6.sp, color: scheme.primary)
                : null,
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => submit(),
              style: TextStyle(fontSize: 13.sp),
              decoration: InputDecoration(
                isDense: true,
                labelText: _lastSegment(field.path),
                labelStyle: TextStyle(
                  fontFamily: AppFonts.code,
                  fontSize: 12.sp,
                ),
                helperText: field.path,
                helperStyle: TextStyle(
                  fontSize: 10.sp,
                  color: scheme.onSurfaceVariant,
                ),
                border: const OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 8.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _lastSegment(String path) => path.split('.').last;
}

/// 路由页：route 与 fallback 的选择，空串表示交还给 profile 声明。
class _RouteTab extends HookConsumerWidget {
  const _RouteTab({required this.config});

  final GhostLockProfileConfig config;

  /// 与 native `kRouteCatalog` 对齐的三条路由。
  static const List<String> _routes = <String>[
    'select_stack',
    'tcp_zerocopy',
    'multicast_waiter',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;

    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      children: <Widget>[
        Text(
          l10n.escalationGhostLockProfileRouteLabel,
          style: TextStyle(
            fontFamily: AppFonts.code,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: scheme.onSurface,
          ),
        ),
        SizedBox(height: 6.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 6.h,
          children: <Widget>[
            _chip(
              label: l10n.escalationGhostLockProfileRouteAuto,
              selected: config.route.isEmpty,
              onTap: () => _setRoute(ref, ''),
            ),
            for (final String route in _routes)
              _chip(
                label: route,
                selected: config.route == route,
                onTap: () => _setRoute(ref, route),
              ),
          ],
        ),
        SizedBox(height: 18.h),
        Text(
          l10n.escalationGhostLockProfileFallbackLabel,
          style: TextStyle(
            fontFamily: AppFonts.code,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: scheme.onSurface,
          ),
        ),
        SizedBox(height: 6.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 6.h,
          children: <Widget>[
            _chip(
              label: l10n.escalationGhostLockProfileFallbackNone,
              selected: config.fallbackTo == 'none',
              onTap: () => _setFallback(ref, 'none'),
            ),
            for (final String route in _routes)
              _chip(
                label: route,
                selected: config.fallbackTo == route,
                onTap: () => _setFallback(ref, route),
              ),
          ],
        ),
      ],
    );
  }

  Widget _chip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) => ChoiceChip(
    label: Text(label, style: TextStyle(fontSize: 12.sp)),
    selected: selected,
    onSelected: (bool _) => onTap(),
  );

  Future<void> _setRoute(WidgetRef ref, String route) async {
    try {
      await ref
          .read(ghostLockProfileActionsProvider)
          .updateRoute(release: config.release, route: route);
    } catch (error) {
      ToastMessage.error(error);
    }
  }

  Future<void> _setFallback(WidgetRef ref, String fallbackTo) async {
    try {
      await ref
          .read(ghostLockProfileActionsProvider)
          .updateFallback(release: config.release, fallbackTo: fallbackTo);
    } catch (error) {
      ToastMessage.error(error);
    }
  }
}

/// 高级页：字段树，提交时把当前全部已提供值连同改动一起交回。
class _AdvancedTab extends HookConsumerWidget {
  const _AdvancedTab({required this.config});

  final GhostLockProfileConfig config;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      children: <Widget>[
        GhostLockProfileFieldTree(
          nodes: config.roots,
          invalidPaths: config.invalidPaths,
          onSubmit: (String path, int value) => _submit(ref, path, value),
        ),
      ],
    );
  }

  Future<void> _submit(WidgetRef ref, String path, int value) async {
    final Map<String, int> values = <String, int>{
      ..._flattenProvided(config.roots),
      path: value,
    };
    try {
      await ref
          .read(ghostLockProfileActionsProvider)
          .updateAdvanced(release: config.release, values: values);
    } catch (error) {
      ToastMessage.error(error);
    }
  }

  /// 只收已提供的叶子：未提供字段的 0 不是真实值。
  Map<String, int> _flattenProvided(List<GhostLockProfileFieldNode> nodes) {
    final Map<String, int> out = <String, int>{};
    void walk(List<GhostLockProfileFieldNode> list) {
      for (final GhostLockProfileFieldNode node in list) {
        if (node.isGroup) {
          walk(node.children);
        } else if (node.provided) {
          out[node.path] = node.value;
        }
      }
    }

    walk(nodes);
    return out;
  }
}
