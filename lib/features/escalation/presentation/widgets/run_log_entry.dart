import 'package:Aisupass/common/widgets/app_setting_icon.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/routes/app_route.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 设置页「提权」分组里的日志入口。整行可点，二级页面。
///
/// 入口不做实时状态：不在行内读列表、不显示条数，避免设置页每帧扫盘。
class RunLogEntry extends HookConsumerWidget {
  const RunLogEntry({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    return InkWell(
      onTap: () => context.push(AppRoute.runLog),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: <Widget>[
            const AppSettingIcon(icon: Icons.receipt_long_rounded),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    l10n.ghostKeyRunLogTitle,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    l10n.ghostKeyRunLogEntrySubtitle,
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.chevron_right_rounded,
              size: 20.sp,
              color: context.colorScheme.onSurface.withValues(alpha: 0.72),
            ),
          ],
        ),
      ),
    );
  }
}
