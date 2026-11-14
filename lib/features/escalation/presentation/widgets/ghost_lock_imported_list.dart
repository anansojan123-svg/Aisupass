import 'dart:convert';

import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/routes/app_route.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_user_profile.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/ghost_lock_profile_detail_sheet.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_remove_dialog.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// GhostLock 已导入内核表列表：release + 文件名 + 大小 + 操作。
///
/// [activeName] 标记当前生效行，[onSelect] 是整行的单选回调（切换生效在外层完成）。
class GhostLockImportedList extends HookConsumerWidget {
  const GhostLockImportedList({
    super.key,
    required this.onSelect,
    this.activeName = '',
    this.selectedName = '',
    this.onImport,
  });

  final String activeName;

  /// 单选态下被选中的文档名。
  final String selectedName;

  /// 整行单选回调。
  final ValueChanged<GhostLockUserProfile> onSelect;

  /// 空列表时的导入入口；为 null 时不显示。
  final VoidCallback? onImport;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final AsyncValue<List<GhostLockUserProfile>> async = ref.watch(
      ghostLockImportedProfilesProvider,
    );

    Future<void> remove(GhostLockUserProfile profile) async {
      final bool? confirmed = await showKernelProfileRemoveDialog(
        context,
        release: profile.parseError ? profile.name : profile.release,
      );
      if (confirmed != true) return;
      try {
        await ref
            .read(ghostLockProfileActionsProvider)
            .removeImportedProfile(name: profile.name);
      } catch (error) {
        ToastMessage.error(error);
      }
    }

    Future<void> rename(GhostLockUserProfile profile) async {
      final String? newName = await _promptRename(context, profile.name);
      if (newName == null || newName.trim().isEmpty) return;
      try {
        final String renamed = await ref
            .read(ghostLockProfileActionsProvider)
            .renameImportedProfile(name: profile.name, newName: newName.trim());
        if (renamed.isEmpty) {
          ToastMessage.error(l10n.escalationGhostLockImportFailed('rename'));
        }
      } catch (error) {
        ToastMessage.error(error);
      }
    }

    Future<void> exportProfile(GhostLockUserProfile profile) async {
      try {
        final String text = await ref
            .read(ghostLockProfileActionsProvider)
            .exportImportedProfile(name: profile.name);
        if (text.isEmpty) {
          ToastMessage.error(l10n.escalationGhostLockImportFailed('export'));
          return;
        }
        if (!context.mounted) return;
        final String? path = await FilePicker.saveFile(
          dialogTitle: l10n.escalationGhostLockImportedExport,
          fileName: profile.name,
          type: FileType.any,
          bytes: utf8.encode(text),
        );
        if (path == null || !context.mounted) return;
        ToastMessage.success(l10n.escalationGhostLockImportedExported);
      } catch (error) {
        ToastMessage.error(error);
      }
    }

    void edit(GhostLockUserProfile profile) {
      if (profile.parseError || profile.release.isEmpty) return;
      context.push(AppRoute.ghostLockProfilePath(profile.name));
    }

    return async.when(
      loading: () => SizedBox(height: 80.h, child: const Loading()),
      error: (Object error, StackTrace stackTrace) => RefError(
        onRetry: () => ref.invalidate(ghostLockImportedProfilesProvider),
      ),
      data: (List<GhostLockUserProfile> profiles) {
        if (profiles.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.inbox_outlined,
                  size: 30.sp,
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
                SizedBox(height: 8.h),
                Text(
                  l10n.kernelProfileImportedEmpty,
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                if (onImport != null) ...<Widget>[
                  SizedBox(height: 10.h),
                  OutlinedButton.icon(
                    onPressed: onImport,
                    icon: Icon(Icons.add_rounded, size: 16.sp),
                    label: Text(
                      l10n.kernelProfileImportEntry,
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    style: OutlinedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ],
            ),
          );
        }
        return Column(
          children: <Widget>[
            for (final GhostLockUserProfile profile in profiles)
              _GhostLockImportedRow(
                profile: profile,
                active: profile.name == activeName,
                selected: profile.name == selectedName,
                onSelect: () => onSelect(profile),
                onRemove: () => remove(profile),
                onRename: () => rename(profile),
                onExport: () => exportProfile(profile),
                onEdit: () => edit(profile),
              ),
          ],
        );
      },
    );
  }

  /// 重命名输入框；取消返回 null。
  Future<String?> _promptRename(BuildContext context, String current) =>
      showDialog<String>(
        context: context,
        builder: (BuildContext _) => _RenameDialog(current: current),
      );
}

/// 重命名弹窗。
///
/// 控制器必须由弹窗自己持有：`showDialog` 的 Future 在 `didPop` 就完成，
/// 若在外部 `whenComplete` 里 dispose，退场动画期间 TextField 仍在用它，
/// 弹窗子树被拆除时就会出现 InheritedElement 断言（`_dependents.isEmpty`）。
///
/// 输入框只暴露文件名主干：`.conf` 由原生侧统一补，让用户改后缀只会改坏解析。
class _RenameDialog extends HookWidget {
  const _RenameDialog({required this.current});

  final String current;

  static const String _suffix = '.conf';

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final String stem = current.toLowerCase().endsWith(_suffix)
        ? current.substring(0, current.length - _suffix.length)
        : current;
    final TextEditingController controller = useTextEditingController(
      text: stem,
    );

    void submit() {
      /* 用户手动补了后缀也剥掉，避免出现 xx.conf.conf。 */
      String name = controller.text.trim();
      if (name.toLowerCase().endsWith(_suffix)) {
        name = name.substring(0, name.length - _suffix.length).trim();
      }
      Navigator.of(context).pop(name.isEmpty ? null : name);
    }

    return AlertDialog(
      title: Text(l10n.escalationGhostLockImportedRename),
      content: TextField(
        controller: controller,
        autofocus: true,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => submit(),
        decoration: InputDecoration(
          hintText: l10n.escalationGhostLockImportedRenameHint,
          suffixText: _suffix,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.aiCancel),
        ),
        FilledButton(onPressed: submit, child: Text(l10n.aiSave)),
      ],
    );
  }
}

/// 单行：release + 文件名 + 大小 + 单选圆点 + 更多操作。
///
/// 点行只做选中，详情在行末菜单里。
class _GhostLockImportedRow extends StatelessWidget {
  const _GhostLockImportedRow({
    required this.profile,
    required this.active,
    required this.selected,
    required this.onSelect,
    required this.onRemove,
    required this.onRename,
    required this.onExport,
    required this.onEdit,
  });

  final GhostLockUserProfile profile;
  final bool active;
  final bool selected;
  final VoidCallback onSelect;
  final VoidCallback onRemove;
  final VoidCallback onRename;
  final VoidCallback onExport;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final String release = profile.parseError
        ? l10n.escalationGhostLockImportedParseError
        : profile.release;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Material(
        color: selected
            ? scheme.primaryContainer.withValues(alpha: 0.45)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        child: InkWell(
          onTap: onSelect,
          borderRadius: BorderRadius.circular(10.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 18.w,
                  child: Icon(
                    selected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: 14.sp,
                    color: selected ? scheme.primary : scheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        release,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppFonts.code,
                          fontSize: 12.5.sp,
                          fontWeight: active || selected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: profile.parseError
                              ? scheme.error
                              : active || selected
                              ? scheme.primary
                              : scheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        '${profile.name} · '
                        '${(profile.sizeBytes / 1024).toStringAsFixed(1)} KB · '
                        '${_formatImportedAt(profile.importedAtMs)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!profile.parseError)
                  PopupMenuButton<VoidCallback>(
                    tooltip: l10n.escalationGhostLockMoreActions,
                    icon: Icon(
                      Icons.more_vert_rounded,
                      size: 18.sp,
                      color: scheme.onSurfaceVariant,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: 32.w,
                      minHeight: 32.h,
                    ),
                    onSelected: (VoidCallback action) {
                      /* 菜单条目与本条触发的弹窗若在同一帧内一删一增，
                         Overlay 会在旧条目仍被依赖时就把它拆掉；等这一帧结束再弹。 */
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!context.mounted) return;
                        action();
                      });
                    },
                    itemBuilder: (BuildContext menuContext) =>
                        <PopupMenuEntry<VoidCallback>>[
                          PopupMenuItem<VoidCallback>(
                            value: () => showGhostLockProfileDetailSheet(
                              context,
                              profile: profile,
                            ),
                            child: Text(l10n.kernelProfileDetailTitle),
                          ),
                          PopupMenuItem<VoidCallback>(
                            value: onEdit,
                            child: Text(l10n.kernelProfileEditParams),
                          ),
                          PopupMenuItem<VoidCallback>(
                            value: onRename,
                            child: Text(l10n.escalationGhostLockImportedRename),
                          ),
                          PopupMenuItem<VoidCallback>(
                            value: onExport,
                            child: Text(l10n.escalationGhostLockImportedExport),
                          ),
                          PopupMenuItem<VoidCallback>(
                            value: onRemove,
                            child: Text(l10n.escalationGhostLockImportedRemove),
                          ),
                        ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 导入时间；无时间戳时返回空串，避免占位符出现在行里。
String _formatImportedAt(int millis) {
  if (millis <= 0) return '';
  final DateTime time = DateTime.fromMillisecondsSinceEpoch(millis);
  String two(int value) => value.toString().padLeft(2, '0');
  return '${time.year}-${two(time.month)}-${two(time.day)} '
      '${two(time.hour)}:${two(time.minute)}';
}
