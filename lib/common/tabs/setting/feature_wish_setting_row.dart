import 'dart:async';
import 'dart:math' as math;

import 'package:Aisupass/common/widgets/app_setting_icon.dart';
import 'package:Aisupass/core/constants/app_links.dart';
import 'package:Aisupass/core/constants/community_links.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

/// 设置页「通用」分组-功能许愿：打赏二维码 + GitHub Issue 入口。
class FeatureWishSettingRow extends HookWidget {
  const FeatureWishSettingRow({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showFeatureWishDialog(context),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: <Widget>[
            const AppSettingIcon(icon: Icons.auto_awesome_rounded),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    context.l10n.settingsFeatureWishTitle,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    context.l10n.settingsFeatureWishSubtitle,
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

  Future<void> _showFeatureWishDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(context.l10n.settingsFeatureWishTitle),
          content: SizedBox(
            width: math.min(context.screenWidth * 0.8, 480.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    context.l10n.featureWishDialogDesc,
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      height: 1.5,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.asset(
                        CommunityLinks.donateQrAsset,
                        width: 200.w,
                        height: 200.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  FilledButton.icon(
                    onPressed: () => unawaited(
                      launchUrl(
                        Uri.parse(AppLinks.newIssue),
                        mode: LaunchMode.externalApplication,
                      ),
                    ),
                    icon: Icon(Icons.open_in_new_rounded, size: 16.sp),
                    label: Text(context.l10n.featureWishIssueButton),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    context.l10n.featureWishNetworkTip,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(context.l10n.aiCancel),
            ),
          ],
        );
      },
    );
  }
}
