import 'dart:async';

import 'package:Aisupass/core/constants/app_links.dart';
import 'package:Aisupass/core/constants/community_links.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

/// 空会话引导：应用图标、标题、说明与两个可发送的建议问题，
/// 另附一个跳转交流群的「获取技术支持」入口。
class ChatEmptyState extends HookWidget {
  const ChatEmptyState({super.key, required this.onSuggestion});

  final ValueChanged<String> onSuggestion;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDesktopPlatform;
    final ColorScheme colors = context.colorScheme;
    final List<String> suggestions = <String>[
      context.l10n.chatSuggestionRom,
      context.l10n.chatSuggestionEscalation,
    ];

    Future<void> openSupport() => launchUrl(
      Uri.parse(CommunityLinks.communityGroup),
      mode: LaunchMode.externalApplication,
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 24 : 24.w),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SvgPicture.asset(
                      AppLinks.appIconAsset,
                      width: isDesktop ? 64 : 64.r,
                      height: isDesktop ? 64 : 64.r,
                    ),
                    SizedBox(height: isDesktop ? 16 : 16.h),
                    Text(
                      context.l10n.chatEmptyTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isDesktop ? 20 : 20.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: colors.onSurface,
                      ),
                    ),
                    SizedBox(height: isDesktop ? 8 : 8.h),
                    Text(
                      context.l10n.chatEmptyHint,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isDesktop ? 13.5 : 13.5.sp,
                        height: 1.55,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: isDesktop ? 22 : 22.h),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: isDesktop ? 8 : 8.w,
                      runSpacing: isDesktop ? 8 : 8.h,
                      children: <Widget>[
                        for (final String suggestion in suggestions)
                          _SuggestionChip(
                            text: suggestion,
                            onTap: () => onSuggestion(suggestion),
                          ),
                        _SuggestionChip(
                          text: context.l10n.chatSuggestionSupport,
                          icon: Icons.headset_mic_outlined,
                          highlighted: true,
                          onTap: () => unawaited(openSupport()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SuggestionChip extends HookWidget {
  const _SuggestionChip({
    required this.text,
    required this.onTap,
    this.icon = Icons.north_east_rounded,
    this.highlighted = false,
  });

  final String text;
  final VoidCallback onTap;
  final IconData icon;

  /// 强调色样式，用于跳转外部的特殊入口。
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;
    final bool isDark = context.isDark;
    final BorderRadius radius = BorderRadius.circular(999);
    final Color tint = highlighted ? colors.primary : colors.onSurfaceVariant;

    return Material(
      color: highlighted
          ? colors.primary.withValues(alpha: isDark ? 0.18 : 0.1)
          : colors.surfaceContainerHighest.withValues(
              alpha: isDark ? 0.4 : 0.55,
            ),
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 13 : 13.w,
            vertical: isDesktop ? 8 : 8.h,
          ),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: highlighted
                  ? colors.primary.withValues(alpha: 0.4)
                  : colors.outline.withValues(alpha: isDark ? 0.24 : 0.14),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: isDesktop ? 13 : 13.sp, color: tint),
              SizedBox(width: isDesktop ? 5 : 5.w),
              Text(
                text,
                style: TextStyle(
                  fontSize: isDesktop ? 12.5 : 12.5.sp,
                  fontWeight: highlighted ? FontWeight.w600 : FontWeight.w400,
                  color: highlighted
                      ? colors.primary
                      : colors.onSurface.withValues(alpha: 0.86),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
