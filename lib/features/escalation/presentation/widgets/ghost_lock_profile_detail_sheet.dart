import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/routes/app_route.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/core/utils/hocon_text.dart';
import 'package:Aisupass/core/utils/kernel_profile_text.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_user_profile.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 打开一份已导入 GhostLock 内核表的详情弹窗。
Future<void> showGhostLockProfileDetailSheet(
  BuildContext context, {
  required GhostLockUserProfile profile,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (BuildContext _) => GhostLockProfileDetailSheet(profile: profile),
);

/// 打开一份内置 GhostLock 内核表的详情弹窗（只读，无文件名/大小）。
///
/// [editable] 为 false 时不显示编辑入口；参考模板字段全空，编辑器打不开。
Future<void> showGhostLockBuiltinDetailSheet(
  BuildContext context, {
  required String release,
  bool editable = true,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (BuildContext _) => GhostLockProfileDetailSheet(
    profile: GhostLockUserProfile(
      name: release,
      release: release,
      sizeBytes: 0,
      importedAtMs: 0,
      parseError: false,
    ),
    builtin: true,
    editable: editable,
  ),
);

/// 详情弹窗：概览字段 + 结构偏移 + 符号偏移 + 可展开的原始 HOCON 文本。
class GhostLockProfileDetailSheet extends HookConsumerWidget {
  const GhostLockProfileDetailSheet({
    required this.profile,
    this.builtin = false,
    this.editable = true,
    super.key,
  });

  final GhostLockUserProfile profile;

  /// 内置表没有文件名与大小，顶部卡片只显示 release。
  final bool builtin;

  /// 是否显示编辑入口；参考模板等不可编辑的文档传 false。
  final bool editable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final AsyncValue<String> contentAsync = ref.watch(
      ghostLockImportedProfileContentProvider(name: profile.name),
    );
    final ValueNotifier<bool> showRaw = useState<bool>(false);

    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 6.w, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    l10n.kernelProfileDetailTitle,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurface,
                    ),
                  ),
                ),
                if (!profile.parseError && editable)
                  IconButton(
                    tooltip: l10n.escalationGhostLockProfileEdit,
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.push(AppRoute.ghostLockProfilePath(profile.name));
                    },
                    icon: Icon(Icons.edit_outlined, size: 18.sp),
                    visualDensity: VisualDensity.compact,
                  ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close_rounded, size: 18.sp),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          Expanded(
            child: contentAsync.when(
              loading: () => const Loading(),
              error: (Object error, StackTrace _) => RefError(
                message: '$error',
                onRetry: () => ref.invalidate(
                  ghostLockImportedProfileContentProvider(name: profile.name),
                ),
              ),
              data: (String text) {
                final Map<String, String> fields = flattenHocon(text);
                final List<(String, String)> structRows = <(String, String)>[
                  for (final (String key, String value) in _rowsUnder(
                    fields,
                    'task_struct',
                  ))
                    (key, kernelProfileHex(value)),
                ];
                final List<(String, String)> symbolRows = <(String, String)>[
                  for (final (String key, String value) in _rowsUnder(
                    fields,
                    'offset',
                  ))
                    (key, kernelProfileHex(value)),
                ];
                return ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                  children: <Widget>[
                    _ReleaseCard(profile: profile, builtin: builtin),
                    SizedBox(height: 14.h),
                    _Section(
                      title: l10n.kernelProfileDetailOverview,
                      child: _FieldTable(
                        rows: <(String, String)>[
                          (
                            l10n.escalationGhostLockProfileRouteLabel,
                            _routeName(fields),
                          ),
                          (
                            l10n.escalationGhostLockProfileFallbackLabel,
                            fields['fallback.to'] ?? '-',
                          ),
                          (
                            l10n.kernelProfileDetailSchema,
                            fields['schema_version'] ?? '-',
                          ),
                          (
                            l10n.kernelProfileDetailKernelMajor,
                            fields['kernel_major'] ?? '-',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),
                    _Section(
                      title: l10n.kernelProfileDetailOffsets,
                      child: _OffsetGrid(rows: structRows),
                    ),
                    SizedBox(height: 14.h),
                    _Section(
                      title: l10n.kernelProfileDetailSymbolOffsets,
                      child: _OffsetGrid(rows: symbolRows),
                    ),
                    SizedBox(height: 14.h),
                    _Section(
                      title: l10n.kernelProfileDetailRaw,
                      trailing: Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: () async {
                              await Clipboard.setData(
                                ClipboardData(text: text),
                              );
                              ToastMessage.success(
                                l10n.kernelProfileDetailCopied,
                              );
                            },
                            tooltip: l10n.kernelProfileDetailCopy,
                            icon: Icon(Icons.copy_rounded, size: 15.sp),
                            visualDensity: VisualDensity.compact,
                            constraints: BoxConstraints(
                              minWidth: 28.w,
                              minHeight: 28.h,
                            ),
                          ),
                          IconButton(
                            onPressed: () => showRaw.value = !showRaw.value,
                            icon: Icon(
                              showRaw.value
                                  ? Icons.expand_less_rounded
                                  : Icons.expand_more_rounded,
                              size: 18.sp,
                            ),
                            visualDensity: VisualDensity.compact,
                            constraints: BoxConstraints(
                              minWidth: 28.w,
                              minHeight: 28.h,
                            ),
                          ),
                        ],
                      ),
                      child: showRaw.value
                          ? _RawText(
                              text: text.trim().isEmpty
                                  ? l10n.kernelProfileDetailEmpty
                                  : text,
                            )
                          : SizedBox.shrink(),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// `route { <name> { ... } }` 的第一层键即当前路由名。
  static String _routeName(Map<String, String> fields) {
    for (final String key in fields.keys) {
      if (key.startsWith('route.')) {
        final List<String> parts = key.split('.');
        if (parts.length > 1 && parts[1].isNotEmpty) return parts[1];
      }
    }
    return '-';
  }

  /// 取某个顶层分组下的全部扁平字段，键去掉前缀。
  static List<(String, String)> _rowsUnder(
    Map<String, String> fields,
    String group,
  ) {
    final String prefix = '$group.';
    return <(String, String)>[
      for (final MapEntry<String, String> entry in fields.entries)
        if (entry.key.startsWith(prefix))
          (entry.key.substring(prefix.length), entry.value),
    ];
  }
}

/// 顶部卡片：内核版本 + 文件名与大小。
class _ReleaseCard extends HookWidget {
  const _ReleaseCard({required this.profile, this.builtin = false});

  final GhostLockUserProfile profile;

  final bool builtin;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            profile.parseError
                ? l10n.escalationGhostLockImportedParseError
                : profile.release,
            style: TextStyle(
              fontSize: 12.5.sp,
              height: 1.4,
              fontFamily: AppFonts.code,
              fontWeight: FontWeight.w600,
              color: profile.parseError ? scheme.error : scheme.onSurface,
            ),
          ),
          if (!builtin) ...<Widget>[
            SizedBox(height: 6.h),
            Text(
              '${l10n.kernelProfileDetailSource} · ${profile.name} · '
              '${(profile.sizeBytes / 1024).toStringAsFixed(1)} KB',
              style: TextStyle(fontSize: 11.sp, color: scheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

/// 带标题的分区卡片，`trailing` 放右侧操作按钮。
class _Section extends HookWidget {
  const _Section({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 10.h, 10.w, 12.h),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          SizedBox(height: 4.h),
          child,
        ],
      ),
    );
  }
}

/// 键值两列表格：左标签右值，值等宽显示。
class _FieldTable extends HookWidget {
  const _FieldTable({required this.rows});

  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    return Column(
      children: <Widget>[
        for (final (String label, String value) in rows)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                SelectableText(
                  value,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: AppFonts.code,
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// 偏移量两列网格：字段名 + 值。
class _OffsetGrid extends HookWidget {
  const _OffsetGrid({required this.rows});

  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    if (rows.isEmpty) {
      return Text(
        '-',
        style: TextStyle(fontSize: 12.sp, color: scheme.onSurfaceVariant),
      );
    }
    return Column(
      children: <Widget>[
        for (int i = 0; i < rows.length; i += 2)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _OffsetCell(label: rows[i].$1, value: rows[i].$2),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: i + 1 < rows.length
                      ? _OffsetCell(
                          label: rows[i + 1].$1,
                          value: rows[i + 1].$2,
                        )
                      : SizedBox.shrink(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// 网格里的单个偏移量单元格：字段名在上，值在下。
class _OffsetCell extends HookWidget {
  const _OffsetCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 10.5.sp, color: scheme.onSurfaceVariant),
        ),
        SizedBox(height: 1.h),
        SelectableText(
          value,
          style: TextStyle(
            fontSize: 11.5.sp,
            fontFamily: AppFonts.code,
            color: scheme.onSurface,
          ),
        ),
      ],
    );
  }
}

/// 原始 HOCON 文本块：等宽、可选中。
class _RawText extends HookWidget {
  const _RawText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: SelectableText(
        text,
        style: TextStyle(
          fontSize: 11.sp,
          height: 1.5,
          fontFamily: AppFonts.code,
          color: scheme.onSurface,
        ),
      ),
    );
  }
}
