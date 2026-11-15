import 'dart:async';

import 'package:Aisupass/common/widgets/app_setting_icon.dart';
import 'package:Aisupass/core/constants/app_links.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/routes/app_route.dart';
import 'package:Aisupass/core/utils/app_version.dart';
import 'package:Aisupass/features/update/presentation/widgets/update_check_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// 设置页「关于」分组：版本号、检查更新、官网、开源地址、开源协议、第三方声明。
class AboutSettingSection extends HookWidget {
  const AboutSettingSection({super.key});

  @override
  Widget build(BuildContext context) {
    // 版本号只取一次，避免每帧走平台通道。
    final PackageInfo? info = useFuture(
      useMemoized(AppVersion.load),
    ).data;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _AboutRow(
          icon: Icons.info_outline_rounded,
          title: context.l10n.settingsAboutVersionTitle,
          value: info == null ? null : AppVersion.display(info),
        ),
        const _AboutDivider(),
        const UpdateCheckRow(),
        const _AboutDivider(),
        _AboutRow(
          svgAsset: AppLinks.appIconAsset,
          title: context.l10n.settingsAboutWebsiteTitle,
          subtitle: AppLinks.websiteDisplay,
          onTap: () => unawaited(
            launchUrl(
              Uri.parse(AppLinks.website),
              mode: LaunchMode.externalApplication,
            ),
          ),
        ),
        const _AboutDivider(),
        _AboutRow(
          svgAsset: AppLinks.githubIconAsset,
          svgColor: context.colorScheme.onSurface.withValues(alpha: 0.85),
          title: context.l10n.settingsAboutRepoTitle,
          subtitle: AppLinks.repositoryDisplay,
          onTap: () => unawaited(
            launchUrl(
              Uri.parse(AppLinks.repository),
              mode: LaunchMode.externalApplication,
            ),
          ),
        ),
        const _AboutDivider(),
        _AboutRow(
          icon: Icons.description_outlined,
          title: context.l10n.settingsAboutLicenseTitle,
          subtitle: context.l10n.settingsAboutLicenseSubtitle,
          onTap: () => context.push(AppRoute.licenseDocPath(0)),
        ),
        const _AboutDivider(),
        _AboutRow(
          icon: Icons.inventory_2_outlined,
          title: context.l10n.settingsAboutThirdPartyTitle,
          subtitle: context.l10n.settingsAboutThirdPartySubtitle,
          onTap: () => context.push(
            AppRoute.licenseDocPath(AppLinks.thirdPartyNoticesDocIndex),
          ),
        ),
      ],
    );
  }
}

/// 分组内单行；[onTap] 为空时是只读行，右侧显示 [value] 而不是箭头。
class _AboutRow extends StatelessWidget {
  const _AboutRow({
    this.icon,
    this.svgAsset,
    this.svgColor,
    required this.title,
    this.subtitle,
    this.value,
    this.onTap,
  });

  final IconData? icon;
  final String? svgAsset;
  final Color? svgColor;
  final String title;
  final String? subtitle;
  final String? value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final String? sub = subtitle;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: <Widget>[
            AppSettingIcon(
              icon: icon,
              svgAsset: svgAsset,
              svgColor: svgColor,
            ),
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
            if (onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                size: 20.sp,
                color: context.colorScheme.onSurface.withValues(alpha: 0.72),
              )
            else
              Text(
                value ?? '',
                style: TextStyle(
                  fontSize: 12.5.sp,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 组内分隔线。
class _AboutDivider extends StatelessWidget {
  const _AboutDivider();

  @override
  Widget build(BuildContext context) => Divider(
    height: 1,
    indent: 62.w,
    endIndent: 16.w,
    color: context.colorScheme.outlineVariant.withValues(alpha: 0.5),
  );
}
