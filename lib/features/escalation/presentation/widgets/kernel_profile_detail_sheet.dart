import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/routes/app_route.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/core/utils/hocon_text.dart';
import 'package:Aisupass/core/utils/kernel_profile_text.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile.dart';
import 'package:Aisupass/features/escalation/presentation/providers/kernel_profile_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/kernel_profile_query_provider.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// 打开一份已导入 profile 的详情弹窗。
///
/// [editable] 为 true 时底部提供编辑入口（仅用户导入文档）。
Future<void> showKernelProfileDetailSheet(
  BuildContext context, {
  required KernelProfile profile,
  bool editable = false,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (BuildContext _) =>
      KernelProfileDetailSheet(profile: profile, editable: editable),
);

/// 详情弹窗：概览字段 + 偏移量表 + 可展开的原始 HOCON 文本。
class KernelProfileDetailSheet extends HookConsumerWidget {
  const KernelProfileDetailSheet({
    required this.profile,
    this.editable = false,
    super.key,
  });

  final KernelProfile profile;

  /// 是否展示编辑入口。
  final bool editable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final AsyncValue<String> contentAsync = ref.watch(
      kernelProfileContentProvider(
        name: profile.name,
        release: profile.release,
      ),
    );
    final ValueNotifier<bool> showRaw = useState<bool>(false);
    final String activeName =
        ref.watch(kernelProfileActiveNameProvider).value ?? '';
    final String activeBuiltin =
        ref.watch(kernelProfileActiveBuiltinProvider).value ?? '';
    final ValueNotifier<bool> busy = useState<bool>(false);
    final bool isBusy = useValueListenable(busy);
    /* 内置表以 release 标识，用户文档以文档名标识，两者互斥。 */
    final bool isActive = profile.name.isNotEmpty
        ? profile.name == activeName
        : profile.release == activeBuiltin;

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
                  kernelProfileContentProvider(
                    name: profile.name,
                    release: profile.release,
                  ),
                ),
              ),
              data: (String text) {
                if (text.trim().isEmpty) {
                  return Center(
                    child: Text(
                      l10n.kernelProfileDetailEmpty,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }
                final Map<String, String> fields = flattenHocon(text);
                return ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                  children: <Widget>[
                    _ReleaseCard(profile: profile),
                    SizedBox(height: 14.h),
                    _Section(
                      title: l10n.kernelProfileDetailOverview,
                      child: _FieldTable(
                        rows: <(String, String)>[
                          (
                            l10n.kernelProfileDetailVulnType,
                            fields['vuln_type'] ?? '-',
                          ),
                          (
                            l10n.kernelProfileDetailPageOffset,
                            kernelProfileHex(fields['page_offset']),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),
                    _Section(
                      title: l10n.kernelProfileDetailOffsets,
                      child: _OffsetGrid(rows: kernelProfileOffsetRows(fields)),
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
                          ? _RawText(text: text)
                          : SizedBox.shrink(),
                    ),
                  ],
                );
              },
            ),
          ),
          if (profile.name.isNotEmpty ||
              activeName.isNotEmpty ||
              activeBuiltin.isNotEmpty)
            SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
                child: Row(
                  children: <Widget>[
                    /* 内置表：指定/取消这一份内置表，与用户文档来源互斥。 */
                    if (profile.name.isEmpty)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isBusy
                              ? null
                              : () => _toggleBuiltin(
                                  context,
                                  ref,
                                  busy,
                                  isActive,
                                ),
                          child: Text(
                            isActive
                                ? l10n.kernelProfileClearActive
                                : l10n.kernelProfileSetActive,
                          ),
                        ),
                      ),
                    if (profile.name.isNotEmpty) ...<Widget>[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isBusy
                              ? null
                              : () =>
                                    _toggleActive(context, ref, busy, isActive),
                          child: Text(
                            isActive
                                ? l10n.kernelProfileClearActive
                                : l10n.kernelProfileSetActive,
                          ),
                        ),
                      ),
                      if (editable) ...<Widget>[
                        SizedBox(width: 10.w),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () async {
                              await context.push(
                                AppRoute.kernelProfileEditPath(profile.name),
                              );
                              /* 编辑可能已写回，返回后重取详情内容。 */
                              ref.invalidate(
                                kernelProfileContentProvider(
                                  name: profile.name,
                                  release: profile.release,
                                ),
                              );
                            },
                            icon: Icon(Icons.edit_rounded, size: 16.r),
                            label: Text(l10n.kernelProfileEditAction),
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 把该文档设为生效，或取消指定回到自动匹配。
  Future<void> _toggleActive(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> busy,
    bool isActive,
  ) async {
    final AppLocalizations l10n = context.l10n;
    busy.value = true;
    try {
      await ref
          .read(kernelProfileActionsProvider)
          .select(isActive ? '' : profile.name);
      if (!context.mounted) return;
      ToastMessage.success(
        isActive
            ? l10n.kernelProfileClearedActive
            : l10n.kernelProfileActivated,
      );
    } catch (error) {
      if (context.mounted) ToastMessage.error(error);
    } finally {
      busy.value = false;
    }
  }

  /// 指定/取消这份内置表；取消后由设备 release 精确匹配决定。
  Future<void> _toggleBuiltin(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> busy,
    bool isActive,
  ) async {
    final AppLocalizations l10n = context.l10n;
    busy.value = true;
    try {
      await ref
          .read(kernelProfileActionsProvider)
          .selectBuiltin(isActive ? '' : profile.release);
      if (!context.mounted) return;
      ToastMessage.success(
        isActive
            ? l10n.kernelProfileClearedActive
            : l10n.kernelProfileActivated,
      );
    } catch (error) {
      if (context.mounted) ToastMessage.error(error);
    } finally {
      busy.value = false;
    }
  }
}

/// 顶部卡片：内核版本 + 导入来源。
class _ReleaseCard extends StatelessWidget {
  const _ReleaseCard({required this.profile});

  final KernelProfile profile;

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
            profile.release,
            style: TextStyle(
              fontSize: 12.5.sp,
              height: 1.4,
              fontFamily: AppFonts.code,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface,
            ),
          ),
          if (profile.detail.isNotEmpty) ...<Widget>[
            SizedBox(height: 6.h),
            Text(
              '${l10n.kernelProfileDetailSource} · ${profile.detail}',
              style: TextStyle(fontSize: 11.sp, color: scheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

/// 带标题的分区卡片，`trailing` 放右侧操作按钮。
class _Section extends StatelessWidget {
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

/// 键值两列表格：左标签右值，值右对齐并等宽显示。
class _FieldTable extends StatelessWidget {
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

/// 偏移量两列网格：字段名 + 十六进制值。
class _OffsetGrid extends StatelessWidget {
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
class _OffsetCell extends StatelessWidget {
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

/// 原始 HOCON 文本块：等宽、可滚动、可选中。
class _RawText extends StatelessWidget {
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
