import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';

/// 候选行：左侧圆点表示选中，右侧「生效中」表示当前正在使用。
///
/// [leading] 可换成别的图标，用于不可选的只读条目（如参考模板）。
class KernelProfilePickRow extends StatelessWidget {
  const KernelProfilePickRow({
    super.key,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.selected = false,
    this.active = false,
    this.leading,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final bool selected;
  final bool active;
  final VoidCallback onTap;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    /* 生效行与选中行都用主题色，靠左侧圆点区分「当前选中」。 */
    final bool highlighted = selected || active;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Material(
        color: selected
            ? scheme.primaryContainer.withValues(alpha: 0.45)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            child: Row(
              children: <Widget>[
                leading ??
                    Icon(
                      selected
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_unchecked_rounded,
                      size: 16.sp,
                      color: selected
                          ? scheme.primary
                          : scheme.onSurfaceVariant,
                    ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppFonts.code,
                          fontSize: 12.sp,
                          fontWeight: highlighted
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: highlighted
                              ? scheme.primary
                              : scheme.onSurface,
                        ),
                      ),
                      if (subtitle != null) ...<Widget>[
                        SizedBox(height: 1.h),
                        Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.5.sp,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
