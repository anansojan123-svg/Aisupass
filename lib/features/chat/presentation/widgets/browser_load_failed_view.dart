import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 加载失败态：图标、原因、以及「重试 / 改用系统浏览器」两个出口。
class BrowserLoadFailedView extends StatelessWidget {
  const BrowserLoadFailedView({
    super.key,
    required this.title,
    required this.message,
    required this.retryLabel,
    required this.externalLabel,
    required this.onRetry,
    required this.onExternal,
  });

  final String title;
  final String message;
  final String retryLabel;
  final String externalLabel;
  final VoidCallback onRetry;
  final VoidCallback onExternal;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 60.r,
              height: 60.r,
              decoration: BoxDecoration(
                color: colors.errorContainer.withValues(
                  alpha: context.isDark ? 0.4 : 0.55,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                size: 26.sp,
                color: colors.onErrorContainer,
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.5.sp,
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
              ),
            ),
            SizedBox(height: 6.h),
            SelectableText(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                height: 1.55,
                color: colors.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 18.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: Icon(Icons.refresh_rounded, size: 16.sp),
                  label: Text(
                    retryLabel,
                    style: TextStyle(fontSize: 12.5.sp),
                  ),
                ),
                SizedBox(width: 10.w),
                OutlinedButton.icon(
                  onPressed: onExternal,
                  icon: Icon(Icons.open_in_new_rounded, size: 16.sp),
                  label: Text(
                    externalLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.5.sp),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
