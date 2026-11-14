import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// 空状态：图标 + 提示，可选导入入口，对齐 GhostLock 已导入列表的空态。
class KernelProfileEmptyHint extends StatelessWidget {
  const KernelProfileEmptyHint({super.key, required this.text, this.onImport});

  final String text;
  final VoidCallback? onImport;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.inbox_outlined,
            size: 30.sp,
            color: scheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          SizedBox(height: 8.h),
          Text(
            text,
            style: TextStyle(fontSize: 11.5.sp, color: scheme.onSurfaceVariant),
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
}
