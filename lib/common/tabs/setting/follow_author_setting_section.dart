import 'dart:async';
import 'dart:math' as math;

import 'package:Aisupass/common/widgets/app_setting_icon.dart';
import 'package:Aisupass/core/constants/community_links.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

/// 设置页「关注作者」分组：作者各大平台入口与微信公众号二维码。
class FollowAuthorSettingSection extends HookWidget {
  const FollowAuthorSettingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _FollowAuthorRow(
          icon: Icons.menu_book_rounded,
          title: context.l10n.settingsTutorialTitle,
          subtitle: context.l10n.settingsTutorialSubtitle,
          onTap: () => _showCreatorPlatformsDialog(context),
        ),
        const _FollowAuthorDivider(),
        _FollowAuthorRow(
          icon: Icons.groups_rounded,
          title: context.l10n.settingsCommunityGroupTitle,
          subtitle: context.l10n.settingsCommunityGroupSubtitle,
          onTap: () => unawaited(
            launchUrl(
              Uri.parse(CommunityLinks.communityGroup),
              mode: LaunchMode.externalApplication,
            ),
          ),
        ),
        const _FollowAuthorDivider(),
        _FollowAuthorRow(
          icon: Icons.qr_code_rounded,
          title: context.l10n.settingsWechatTitle,
          onTap: () => _showWechatDialog(context),
        ),
      ],
    );
  }

  Future<void> _showCreatorPlatformsDialog(BuildContext context) {
    final List<_CreatorPlatform> platforms = <_CreatorPlatform>[
      _CreatorPlatform(
        title: context.l10n.platformDouyin,
        iconAsset: CommunityLinks.douyinIconAsset,
        url: CommunityLinks.douyin,
      ),
      _CreatorPlatform(
        title: context.l10n.platformBilibili,
        iconAsset: CommunityLinks.bilibiliIconAsset,
        url: CommunityLinks.bilibili,
      ),
      _CreatorPlatform(
        title: context.l10n.platformFacebook,
        iconAsset: CommunityLinks.facebookIconAsset,
        url: CommunityLinks.facebook,
      ),
      _CreatorPlatform(
        title: context.l10n.platformTiktok,
        iconAsset: CommunityLinks.tiktokIconAsset,
        url: CommunityLinks.tiktok,
      ),
      _CreatorPlatform(
        title: context.l10n.platformYoutube,
        iconAsset: CommunityLinks.youtubeIconAsset,
        url: CommunityLinks.youtube,
      ),
    ];

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(context.l10n.settingsCreatorPlatformsTitle),
          content: SizedBox(
            width: _dialogWidth(context),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    context.l10n.settingsCreatorPlatformsIntro,
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      height: 1.5,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                          final double spacing = 10.w;
                          final double itemWidth =
                              (constraints.maxWidth - spacing) / 2;
                          return Wrap(
                            spacing: spacing,
                            runSpacing: 10.h,
                            children: platforms
                                .map(
                                  (_CreatorPlatform platform) => SizedBox(
                                    width: itemWidth,
                                    child: _PlatformCard(platform: platform),
                                  ),
                                )
                                .toList(),
                          );
                        },
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

  Future<void> _showWechatDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(context.l10n.settingsWechatTitle),
          content: SizedBox(
            width: _dialogWidth(context),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: AspectRatio(
                aspectRatio: 1885 / 624,
                child: Image.asset(
                  CommunityLinks.wechatQrAsset,
                  fit: BoxFit.contain,
                ),
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

/// 弹窗宽度：移动端占屏宽八成，桌面端限制最大宽度。
double _dialogWidth(BuildContext context) =>
    math.min(context.screenWidth * 0.8, 480.w);

/// 作者平台条目。
class _CreatorPlatform {
  const _CreatorPlatform({
    required this.title,
    required this.iconAsset,
    required this.url,
  });

  final String title;
  final String iconAsset;
  final String url;
}

/// 平台入口卡片，点击后跳转对应平台主页。
class _PlatformCard extends HookWidget {
  const _PlatformCard({required this.platform});

  final _CreatorPlatform platform;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final BorderRadius radius = BorderRadius.circular(14.r);

    return Material(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.28),
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: () => unawaited(
          launchUrl(
            Uri.parse(platform.url),
            mode: LaunchMode.externalApplication,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.asset(
                  platform.iconAsset,
                  width: 22.w,
                  height: 22.w,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  platform.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.open_in_new_rounded,
                size: 15.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 分组内单行：左侧图标胶囊 + 标题/副标题 + 箭头。
class _FollowAuthorRow extends HookWidget {
  const _FollowAuthorRow({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final String? sub = subtitle;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: <Widget>[
            AppSettingIcon(icon: icon),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (sub != null) ...<Widget>[
                    SizedBox(height: 3.h),
                    Text(
                      sub,
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
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

/// 组内分隔线。
class _FollowAuthorDivider extends HookWidget {
  const _FollowAuthorDivider();

  @override
  Widget build(BuildContext context) => Divider(
    height: 1,
    indent: 62.w,
    endIndent: 16.w,
    color: context.colorScheme.outlineVariant.withValues(alpha: 0.5),
  );
}
