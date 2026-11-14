import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile.dart';
import 'package:Aisupass/features/escalation/presentation/providers/kernel_profile_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_detail_sheet.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_remove_dialog.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// 单行 profile：release + 文档名/来源 + 可选删除按钮。
///
/// [matched] 表示该行当前生效（与本机内核一致），[active] 表示用户显式选中了它。
/// 传入 [onSelect] 时左侧换成单选圆点，点圆点切换生效（与 GhostLock 选表一致）。
class KernelProfileImportedRow extends HookConsumerWidget {
  const KernelProfileImportedRow({
    super.key,
    required this.profile,
    this.showDelete = true,
    this.matched = false,
    this.active = false,
    this.editable = false,
    this.selected = false,
    this.mismatch = false,
    this.onSelect,
  });

  final KernelProfile profile;

  /// 内置表只读，不显示删除按钮。
  final bool showDelete;

  /// 当前生效的那份。
  final bool matched;

  /// 用户显式指定生效的文档。
  final bool active;

  /// 用户导入文档可在详情弹窗内编辑。
  final bool editable;

  /// 单选圆点是否选中；仅 [onSelect] 非空时有意义。
  final bool selected;

  /// 已选中但 release 与本机不一致：运行会被拒绝。
  final bool mismatch;

  /// 切换生效；为空时左侧只显示状态图标。
  final VoidCallback? onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final String subtitle = <String>[
      if (profile.detail.isNotEmpty) profile.detail,
      if (profile.name.isNotEmpty) profile.name,
    ].join(' · ');
    final bool hasSubtitle =
        matched || active || mismatch || subtitle.isNotEmpty;

    Future<void> remove() async {
      final bool? confirmed = await showKernelProfileRemoveDialog(
        context,
        release: profile.release,
      );
      if (confirmed != true) return;
      try {
        await ref.read(kernelProfileActionsProvider).remove(profile.name);
      } catch (error) {
        ToastMessage.error(error);
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Material(
        color: (selected || matched)
            ? scheme.primaryContainer.withValues(alpha: 0.45)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        child: InkWell(
          onTap: () => showKernelProfileDetailSheet(
            context,
            profile: profile,
            editable: editable,
          ),
          borderRadius: BorderRadius.circular(10.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
            child: Row(
              children: <Widget>[
                InkResponse(
                  onTap: onSelect,
                  radius: 18.r,
                  child: Icon(
                    onSelect == null
                        ? (matched
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined)
                        : (selected
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_unchecked_rounded),
                    size: 15.sp,
                    color: (selected || matched)
                        ? scheme.primary
                        : scheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        profile.release,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppFonts.code,
                          fontSize: 12.sp,
                          fontWeight: matched
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: matched ? scheme.primary : scheme.onSurface,
                        ),
                      ),
                      if (hasSubtitle) ...<Widget>[
                        SizedBox(height: 2.h),
                        Row(
                          children: <Widget>[
                            if (matched) ...<Widget>[
                              _MatchBadge(
                                text: active
                                    ? l10n.kernelProfileActiveBadge
                                    : l10n.kernelProfileMatchesDevice,
                              ),
                              if (subtitle.isNotEmpty) SizedBox(width: 6.w),
                            ] else if (mismatch) ...<Widget>[
                              _MatchBadge(
                                text: l10n.kernelProfileReviewMismatch,
                                error: true,
                              ),
                              if (subtitle.isNotEmpty) SizedBox(width: 6.w),
                            ],
                            if (subtitle.isNotEmpty)
                              Expanded(
                                child: Text(
                                  subtitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10.5.sp,
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 6.w),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18.sp,
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
                if (showDelete)
                  IconButton(
                    onPressed: remove,
                    tooltip: l10n.kernelProfileRemove,
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      size: 18.sp,
                      color: scheme.error,
                    ),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: 32.w,
                      minHeight: 32.h,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 生效标记：与 GhostLock 页签的选中态保持同一套主色语言。
class _MatchBadge extends StatelessWidget {
  const _MatchBadge({required this.text, this.error = false});

  final String text;

  /// 不一致等否定状态用错误色。
  final bool error;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    final Color tint = error ? scheme.error : scheme.primary;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9.5.sp,
          fontWeight: FontWeight.w600,
          color: tint,
        ),
      ),
    );
  }
}
