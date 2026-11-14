import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/core/utils/hocon_text.dart';
import 'package:Aisupass/core/utils/kernel_profile_text.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile.dart';
import 'package:Aisupass/features/escalation/presentation/providers/kernel_profile_query_provider.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// 打开一份已导入 profile 的详情弹窗。
Future<void> showKernelProfileDetailSheet(
  BuildContext context, {
  required KernelProfile profile,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (BuildContext _) => KernelProfileDetailSheet(profile: profile),
);

/// 详情弹窗：概览字段 + 偏移量表 + 可展开的原始 HOCON 文本。
class KernelProfileDetailSheet extends HookConsumerWidget {
  const KernelProfileDetailSheet({required this.profile, super.key});

  final KernelProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final AsyncValue<String> contentAsync = ref.watch(
      kernelProfileContentProvider(release: profile.release),
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
                  kernelProfileContentProvider(release: profile.release),
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
        ],
      ),
    );
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
