import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 设置项左侧图标胶囊，与设置卡片的圆角、主色保持一致。
///
/// [icon] 与 [svgAsset] 二选一：Material 图标按主色绘制，SVG 默认保留原色，
/// 需要跟随主题时传 [svgColor]。
class AppSettingIcon extends HookWidget {
  const AppSettingIcon({super.key, this.icon, this.svgAsset, this.svgColor})
    : assert(icon != null || svgAsset != null, 'icon 与 svgAsset 至少给一个');

  final IconData? icon;

  /// 资源里的 SVG 图标，替代 [icon]。
  final String? svgAsset;

  /// SVG 着色；null 时保留原色，用于彩色品牌图标。
  final Color? svgColor;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final Color? tint = svgColor;

    return Container(
      width: 34.w,
      height: 34.w,
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(11.r),
      ),
      child: Center(
        child: svgAsset == null
            ? Icon(icon, size: 18.sp, color: colorScheme.primary)
            : SvgPicture.asset(
                svgAsset!,
                width: 18.sp,
                height: 18.sp,
                colorFilter: tint == null
                    ? null
                    : ColorFilter.mode(tint, BlendMode.srcIn),
              ),
      ),
    );
  }
}
