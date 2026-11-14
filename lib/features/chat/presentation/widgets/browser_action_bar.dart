import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 底部操作栏。
///
/// 主按钮是「把页面交给 AI」（连同源码），下方三个等宽次级动作：
/// 只回传网址、选已下载文件、改用系统浏览器打开。
class BrowserActionBar extends StatelessWidget {
  const BrowserActionBar({
    super.key,
    required this.onHandoffSource,
    required this.onHandoffUrl,
    required this.onHandoffFile,
    required this.onOpenExternal,
  });

  final VoidCallback onHandoffSource;
  final VoidCallback onHandoffUrl;
  final VoidCallback onHandoffFile;
  final VoidCallback onOpenExternal;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme colors = context.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(
            color: colors.outlineVariant.withValues(alpha: 0.55),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: 42.h,
                child: FilledButton.icon(
                  onPressed: onHandoffSource,
                  icon: Icon(Icons.send_rounded, size: 16.sp),
                  label: Text(
                    l10n.chatBrowserHandoffSource,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _ActionTile(
                      icon: Icons.link_rounded,
                      label: l10n.chatBrowserHandoffUrl,
                      onTap: onHandoffUrl,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _ActionTile(
                      icon: Icons.attach_file_rounded,
                      label: l10n.chatBrowserHandoffFile,
                      onTap: onHandoffFile,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _ActionTile(
                      icon: Icons.open_in_new_rounded,
                      label: l10n.chatBrowserOpen,
                      onTap: onOpenExternal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 次级动作：上方图标、下方单行标签，整体是一个描边按钮。
class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    return SizedBox(
      height: 50.h,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          foregroundColor: colors.onSurface.withValues(alpha: 0.82),
          side: BorderSide(
            color: colors.outlineVariant.withValues(alpha: 0.8),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 15.sp),
            SizedBox(height: 3.h),
            Text(
              label,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 10.5.sp, height: 1.15),
            ),
          ],
        ),
      ),
    );
  }
}
