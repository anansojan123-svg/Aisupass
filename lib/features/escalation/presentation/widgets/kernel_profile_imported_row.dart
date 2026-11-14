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

/// 单行 profile：release + 来源说明 + 可选删除按钮。
///
/// [matched] 表示该行与设备内核一致（GhostKey 按内核精确匹配生效），
/// 用主题色高亮并加一枚「与本机内核一致」标记。
class KernelProfileImportedRow extends HookConsumerWidget {
  const KernelProfileImportedRow({
    super.key,
    required this.profile,
    this.showDelete = true,
    this.matched = false,
  });

  final KernelProfile profile;

  /// 内置表只读，不显示删除按钮。
  final bool showDelete;

  /// 与设备内核一致，即当前会生效的那份。
  final bool matched;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final bool hasSubtitle = matched || profile.detail.isNotEmpty;

    Future<void> remove() async {
      final bool? confirmed = await showKernelProfileRemoveDialog(
        context,
        release: profile.release,
      );
      if (confirmed != true) return;
      try {
        await ref.read(kernelProfileActionsProvider).remove(profile.release);
      } catch (error) {
        ToastMessage.error(error);
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Material(
        color: matched
            ? scheme.primaryContainer.withValues(alpha: 0.45)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        child: InkWell(
          onTap: () => showKernelProfileDetailSheet(context, profile: profile),
          borderRadius: BorderRadius.circular(10.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
            child: Row(
              children: <Widget>[
                Icon(
                  matched
                      ? Icons.check_circle_rounded
                      : Icons.circle_outlined,
                  size: 15.sp,
                  color: matched
                      ? scheme.primary
                      : scheme.onSurfaceVariant.withValues(alpha: 0.6),
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
                              _MatchBadge(text: l10n.kernelProfileMatchesDevice),
                              if (profile.detail.isNotEmpty)
                                SizedBox(width: 6.w),
                            ],
                            if (profile.detail.isNotEmpty)
                              Expanded(
                                child: Text(
                                  profile.detail,
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
  const _MatchBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9.5.sp,
          fontWeight: FontWeight.w600,
          color: scheme.primary,
        ),
      ),
    );
  }
}
