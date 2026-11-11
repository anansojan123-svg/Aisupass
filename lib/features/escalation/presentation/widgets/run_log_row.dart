import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/routes/app_route.dart';
import 'package:Aisupass/core/utils/run_log_format.dart';
import 'package:Aisupass/features/escalation/domain/models/run_log_meta.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// 运行记录列表的一行：序号 + 时间 + 结果 + 副标题。
class RunLogRow extends HookWidget {
  const RunLogRow({super.key, required this.meta});

  final RunLogMeta meta;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    return InkWell(
      onTap: () => context.push(AppRoute.runLogDetail(meta.fileName)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 11.h, 16.w, 11.h),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        '#${meta.runId}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        runLogDateTime(meta.startedAtTime),
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        runLogResultLabel(l10n, meta.result),
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w600,
                          color: runLogResultColor(scheme, meta.result),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    runLogSubtitle(l10n, meta),
                    style: TextStyle(fontSize: 11.sp, color: scheme.outline),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20.sp,
              color: scheme.onSurface.withValues(alpha: 0.72),
            ),
          ],
        ),
      ),
    );
  }
}
