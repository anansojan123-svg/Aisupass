import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile.dart';
import 'package:Aisupass/features/escalation/presentation/providers/kernel_profile_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_detail_sheet.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_remove_dialog.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// 单行 profile：release + 来源说明 + 可选删除按钮。
///
/// 点行打开详情弹窗；[showDelete] 为 true 时删除前弹二次确认，
/// 确认后调 `kernelProfileActions`，列表由 Provider 刷新。
class KernelProfileImportedRow extends HookConsumerWidget {
  const KernelProfileImportedRow({
    super.key,
    required this.profile,
    this.showDelete = true,
  });

  final KernelProfile profile;

  /// 内置表只读，不显示删除按钮。
  final bool showDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;

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

    return InkWell(
      onTap: () => showKernelProfileDetailSheet(context, profile: profile),
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    profile.release,
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      color: scheme.onSurface,
                    ),
                  ),
                  if (profile.detail.isNotEmpty)
                    Text(
                      profile.detail,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
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
                  size: 20.r,
                  color: scheme.error,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
