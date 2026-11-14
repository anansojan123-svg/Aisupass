import 'dart:convert';

import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/features/escalation/domain/models/device_identity.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_active_source.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_execution_field.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_profile_config.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_profile_field_node.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/ghost_lock_profile_field_tree.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 保存方式：写回当前文件 / 另存为新文档 / 导出到本地。
enum _SaveAction { writeBack, saveAs, export }

/// CPU 对由设备/会话决定，编辑器只展示不写入。
const Set<String> _CpuPairPaths = <String>{
  'execution.selected_cpus.main',
  'execution.selected_cpus.consumer',
};

/// GhostLock 内核表编辑器：通用参数、路由、高级字段三个页签。
///
/// 所有编辑都落在会话里，保存时才决定写回生效配置或覆盖目标文档。
class GhostLockProfilePage extends HookConsumerWidget {
  const GhostLockProfilePage({super.key, this.name = ''});

  /// 编辑目标文档名；空串表示内置/设备态。
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final GhostLockProfileActions actions = ref.watch(
      ghostLockProfileActionsProvider,
    );
    final AsyncValue<DeviceIdentity> identityAsync = ref.watch(
      currentDeviceIdentityProvider,
    );
    final String deviceRelease = identityAsync.value?.kernelRelease ?? '';
    final ValueNotifier<GhostLockProfileConfig?> draft =
        useState<GhostLockProfileConfig?>(null);
    final ValueNotifier<Object?> failure = useState<Object?>(null);
    /* 会话有可覆盖目标时才允许「保存」；内置/设备态只能另存。 */
    final ValueNotifier<bool> canSaveDirect = useState<bool>(false);
    /* 输入框只登记不提交，保存按钮统一取值。 */
    final ProfileEditDraft editDraft = useMemoized(ProfileEditDraft.new);

    Future<void> openSession() async {
      if (deviceRelease.isEmpty) return;
      try {
        final GhostLockProfileConfig next = await actions.beginEditSession(
          name: name,
          deviceRelease: deviceRelease,
        );
        final bool live = await actions.editSessionIsLive();
        final String target = await actions.editSessionTarget();
        canSaveDirect.value = live || target.isNotEmpty;
        draft.value = next;
        failure.value = null;
      } catch (error) {
        failure.value = error;
      }
    }

    useEffect(() {
      openSession();
      return () {
        actions.endEditSession();
      };
    }, <Object?>[deviceRelease, name]);

    final GhostLockProfileConfig? config = draft.value;
    /* 生效来源是只读查询，由写操作失效后自动重取。 */
    final GhostLockActiveSource source =
        ref.watch(ghostLockActiveSourceProvider).value ??
        const GhostLockActiveSource(builtin: '', user: '');

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.escalationGhostLockProfileEdit),
        actions: <Widget>[
          PopupMenuButton<_SaveAction>(
            tooltip: l10n.aiSave,
            icon: Icon(Icons.save_rounded, size: 20.sp),
            onSelected: (_SaveAction action) {
              switch (action) {
                case _SaveAction.writeBack:
                  _save(context, ref, draft, editDraft);
                case _SaveAction.saveAs:
                  _saveAs(context, ref, draft, editDraft);
                case _SaveAction.export:
                  _export(context, ref, config);
              }
            },
            itemBuilder: (BuildContext menuContext) =>
                <PopupMenuEntry<_SaveAction>>[
                  _menuEntry<_SaveAction>(
                    menuContext,
                    value: _SaveAction.writeBack,
                    icon: Icons.save_alt_rounded,
                    title: l10n.escalationGhostLockProfileWriteBack,
                    subtitle: canSaveDirect.value
                        ? l10n.escalationGhostLockProfileWriteBackHint
                        : l10n.escalationGhostLockProfileWriteBackDisabled,
                    enabled: canSaveDirect.value,
                  ),
                  _menuEntry<_SaveAction>(
                    menuContext,
                    value: _SaveAction.saveAs,
                    icon: Icons.content_copy_rounded,
                    title: l10n.escalationGhostLockProfileSaveAs,
                    subtitle: l10n.escalationGhostLockProfileSaveAsHint,
                  ),
                  _menuEntry<_SaveAction>(
                    menuContext,
                    value: _SaveAction.export,
                    icon: Icons.file_download_outlined,
                    title: l10n.escalationGhostLockProfileExport,
                    subtitle: l10n.escalationGhostLockProfileExportHint,
                  ),
                ],
          ),
        ],
      ),
      body: config == null
          ? (failure.value != null
                ? RefError(onRetry: openSession)
                : const Loading())
          : Column(
              children: <Widget>[
                _statusBar(
                  context,
                  config,
                  builtin: source.builtin,
                  user: source.user,
                ),
                Expanded(
                  child: config.hasProfile
                      ? _ProfileTabs(
                            config: config,
                            draft: editDraft,
                            onUpdated: (GhostLockProfileConfig next) =>
                                draft.value = next,
                          )
                      : Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32.w),
                            child: Text(
                              l10n.kernelProfileEditorNotEditable,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.5.sp,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  /// 顶部状态条：当前生效来源 + 本地修改条目数。
  Widget _statusBar(
    BuildContext context,
    GhostLockProfileConfig config, {
    required String builtin,
    required String user,
  }) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final String source = user.isNotEmpty
        ? '${l10n.escalationGhostLockProfileSourceUser} · $user'
        : builtin.isNotEmpty
        ? '${l10n.escalationGhostLockProfileSourceBuiltin} · $builtin'
        : l10n.escalationGhostLockProfileSourceDevice;
    final int changed = _countOverridden(config);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
      color: scheme.surfaceContainerHighest,
      child: Row(
        children: <Widget>[
          Icon(
            Icons.layers_outlined,
            size: 14.sp,
            color: scheme.onSurfaceVariant,
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              '${l10n.escalationGhostLockProfileSourceLabel}: $source',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11.sp, color: scheme.onSurfaceVariant),
            ),
          ),
          if (changed > 0)
            Text(
              l10n.escalationGhostLockProfileOverriddenCount(changed),
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: scheme.primary,
              ),
            ),
        ],
      ),
    );
  }

  /// 本地 override 的叶子条目数；分组节点的标记代表子孙，不重复计。
  int _countOverridden(GhostLockProfileConfig config) {
    int count = config.general
        .where((GhostLockExecutionField f) => f.overridden)
        .length;
    void walk(List<GhostLockProfileFieldNode> nodes) {
      for (final GhostLockProfileFieldNode node in nodes) {
        if (node.isGroup) {
          walk(node.children);
        } else if (node.overridden) {
          count++;
        }
      }
    }

    walk(config.roots);
    return count;
  }

  /// 菜单项：图标 + 标题 + 副说明，避免三项名字相近分不清。
  ///
  /// [enabled] 为 false 时置灰但仍展示，让用户看到「该动作存在，当前不适用」。
  PopupMenuItem<T> _menuEntry<T>(
    BuildContext context, {
    required T value,
    required IconData icon,
    required String title,
    required String subtitle,
    bool enabled = true,
  }) {
    final ColorScheme scheme = context.colorScheme;
    final Color foreground = enabled
        ? scheme.onSurface
        : scheme.onSurface.withValues(alpha: 0.38);
    final Color secondary = enabled
        ? scheme.onSurfaceVariant
        : scheme.onSurface.withValues(alpha: 0.38);
    return PopupMenuItem<T>(
      value: value,
      enabled: enabled,
      height: 64.h,
      child: Row(
        children: <Widget>[
          Icon(icon, size: 18.sp, color: foreground),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontSize: 13.sp, color: foreground),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10.5.sp, color: secondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 把输入框里的值一次性写进 override。
  ///
  /// 输入框平时不提交，所以保存前必须先落这批值，否则写回的是旧配置。
  Future<GhostLockProfileConfig?> _commitDraft(
    WidgetRef ref,
    ValueNotifier<GhostLockProfileConfig?> draft,
    ProfileEditDraft editDraft,
  ) async {
    final GhostLockProfileConfig? config = draft.value;
    if (config == null) return null;
    final Map<String, int> values = editDraft.collect();
    if (values.isEmpty) return config;
    final GhostLockProfileConfig next = await ref
        .read(ghostLockProfileActionsProvider)
        .updateAdvanced(release: config.release, values: values);
    editDraft.clear();
    draft.value = next;
    return next;
  }

  /// 保存：把改动写回文档。
  ///
  /// 原生侧在收到这批字段后就直接落盘并清空 override，所以这里不再区分
  /// live / 非 live 两条路径——重开读文档，值一定在。
  Future<void> _save(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<GhostLockProfileConfig?> draft,
    ProfileEditDraft editDraft,
  ) async {
    final AppLocalizations l10n = context.l10n;
    try {
      final GhostLockProfileConfig? next = await _commitDraft(
        ref,
        draft,
        editDraft,
      );
      if (!context.mounted) return;
      next == null
          ? ToastMessage.error(l10n.escalationGhostLockProfileWriteFailed)
          : ToastMessage.success(l10n.escalationGhostLockProfileSaved);
    } catch (error) {
      if (!context.mounted) return;
      _showSubmitError(context, error);
    }
  }

  Future<void> _saveAs(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<GhostLockProfileConfig?> draft,
    ProfileEditDraft editDraft,
  ) async {
    try {
      await _commitDraft(ref, draft, editDraft);
      final String created = await ref
          .read(ghostLockProfileActionsProvider)
          .saveEditSessionAsNew();
      if (!context.mounted) return;
      created.isEmpty
          ? ToastMessage.error(
              context.l10n.escalationGhostLockProfileWriteFailed,
            )
          : ToastMessage.success(
              context.l10n.escalationGhostLockProfileSavedAsNew(created),
            );
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
      // Android/iOS 的 saveFile 必须随内容提交，先取渲染文本再落盘。
      final GhostLockProfileActions actions = ref.read(
        ghostLockProfileActionsProvider,
      );
      final String text = await actions.renderProfile(release: config.release);
      if (text.isEmpty) {
        if (context.mounted) {
          ToastMessage.error(
            context.l10n.escalationGhostLockProfileWriteFailed,
          );
        }
        return;
      }
      final String? path = await FilePicker.saveFile(
        dialogTitle: context.l10n.escalationGhostLockProfileExport,
        fileName:
            '${config.release.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_')}.conf',
        bytes: utf8.encode(text),
        type: FileType.any,
      );
      if (path == null) return;
    } catch (error) {
      ToastMessage.error(error);
    }
  }
}

/// 三个页签的骨架；违规字段在「高级」页签上挂红点。
class _ProfileTabs extends HookWidget {
  const _ProfileTabs({
    super.key,
    required this.config,
    required this.draft,
    required this.onUpdated,
  });

  final GhostLockProfileConfig config;
  final ProfileEditDraft draft;

  /// 每个写操作返回的新配置都回灌到页面，UI 不依赖 provider 失效刷新。
  final ValueChanged<GhostLockProfileConfig> onUpdated;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final bool hasInvalid = config.invalidPaths.isNotEmpty;
    /* 用 Hook 持有 controller：配置刷新时不能把页签弹回第一个。 */
    final TabController tabController = useTabController(initialLength: 3);

    return Column(
      children: <Widget>[
        TabBar(
          controller: tabController,
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
            controller: tabController,
            children: <Widget>[
              _GeneralTab(general: config.general, draft: draft),
              _RouteTab(config: config, onUpdated: onUpdated),
              _AdvancedTab(config: config, draft: draft),
            ],
          ),
        ),
      ],
    );
  }
}

/// 通用参数页：每行一个 execution 调参，改动由保存按钮统一提交。
class _GeneralTab extends HookConsumerWidget {
  const _GeneralTab({required this.general, required this.draft});

  final List<GhostLockExecutionField> general;
  final ProfileEditDraft draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: _TabHint(
            text: context.l10n.escalationGhostLockProfileTabGeneralHint,
          ),
        ),
        for (final GhostLockExecutionField field in general)
          _GeneralFieldRow(
            field: field,
            readOnly: _CpuPairPaths.contains(field.path),
            draft: draft,
          ),
      ],
    );
  }
}

/// 通用参数行：末段键名 + 数字输入框 + override 标记。
///
/// [readOnly] 为真时（CPU 对）只展示当前值，不写盘。
class _GeneralFieldRow extends HookWidget {
  const _GeneralFieldRow({
    required this.field,
    required this.readOnly,
    required this.draft,
  });

  final GhostLockExecutionField field;
  final bool readOnly;
  final ProfileEditDraft draft;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    final TextEditingController controller = useTextEditingController(
      text: '${field.value}',
    );

    /* 服务端值变化就强制回填：保存后字段可能因合并而变，旧文本要跟着更新。 */
    final ObjectRef<int> synced = useRef<int>(field.value);
    useEffect(() {
      if (synced.value == field.value) return null;
      synced.value = field.value;
      final String next = '${field.value}';
      if (controller.text != next) controller.text = next;
      return null;
    }, <Object?>[field.value, controller]);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 12.w,
            child: readOnly
                ? Icon(
                    Icons.lock_outline_rounded,
                    size: 11.sp,
                    color: scheme.onSurfaceVariant,
                  )
                : field.overridden
                ? Icon(Icons.circle, size: 6.sp, color: scheme.primary)
                : null,
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: !readOnly,
              onChanged: readOnly
                  ? null
                  : (String text) => draft.update(field.path, text),
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              textInputAction: TextInputAction.next,
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
  const _RouteTab({required this.config, required this.onUpdated});

  final GhostLockProfileConfig config;
  final ValueChanged<GhostLockProfileConfig> onUpdated;

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
        _TabHint(text: l10n.escalationGhostLockProfileTabRouteHint),
        /* 合并后的实际值；chip 只是 override 意图，这里才是要跑的那条。 */
        Text(
          '${l10n.escalationGhostLockProfileRouteCurrent}: '
          '${config.route.isEmpty ? l10n.escalationGhostLockProfileRouteAuto : config.route}'
          ' / ${config.fallbackTo.isEmpty ? l10n.escalationGhostLockProfileFallbackDeclared : config.fallbackTo}',
          style: TextStyle(
            fontFamily: AppFonts.code,
            fontSize: 11.sp,
            color: scheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 10.h),
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
        SizedBox(height: 8.h),
        /* 切到表里没生成过的路由时，几何字段是 null，说清楚而不是让用户自己踩。 */
        _TabHint(text: l10n.escalationGhostLockProfileRouteGeometryHint),
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
              label: l10n.escalationGhostLockProfileFallbackDeclared,
              selected: config.fallbackTo.isEmpty,
              onTap: () => _setFallback(ref, ''),
            ),
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
      final GhostLockProfileConfig next = await ref
          .read(ghostLockProfileActionsProvider)
          .updateRoute(release: config.release, route: route);
      onUpdated(next);
    } catch (error) {
      ToastMessage.error(error);
    }
  }

  Future<void> _setFallback(WidgetRef ref, String fallbackTo) async {
    try {
      final GhostLockProfileConfig next = await ref
          .read(ghostLockProfileActionsProvider)
          .updateFallback(release: config.release, fallbackTo: fallbackTo);
      onUpdated(next);
    } catch (error) {
      ToastMessage.error(error);
    }
  }
}

/// 高级页：字段树，改动由保存按钮统一提交。
class _AdvancedTab extends HookConsumerWidget {
  const _AdvancedTab({required this.config, required this.draft});

  final GhostLockProfileConfig config;
  final ProfileEditDraft draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: _TabHint(
            text: context.l10n.escalationGhostLockProfileTabAdvancedHint,
          ),
        ),
        GhostLockProfileFieldTree(
          nodes: config.roots,
          invalidPaths: config.invalidPaths,
          draft: draft,
        ),
      ],
    );
  }
}

/// 字段提交失败：原生判定「该值会让配置无法解析」时给可读文案，其余原样抛出。
void _showSubmitError(BuildContext context, Object error) {
  final String text = error.toString();
  if (text.contains('profileOverrideRejected')) {
    ToastMessage.error(context.l10n.escalationGhostLockProfileRejected);
    return;
  }
  ToastMessage.error(error);
}

/// 页签顶部说明：这一页改什么、什么时候生效。
class _TabHint extends StatelessWidget {
  const _TabHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    return Padding(
      padding: EdgeInsets.only(top: 4.h, bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.info_outline_rounded,
            size: 13.sp,
            color: scheme.onSurfaceVariant,
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11.sp,
                height: 1.35,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
