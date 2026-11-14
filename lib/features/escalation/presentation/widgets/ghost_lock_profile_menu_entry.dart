import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:Aisupass/core/extensions/context_extensions.dart';

/// 菜单项：图标 + 标题 + 副说明，避免三项名字相近分不清。
///
/// [enabled] 为 false 时置灰但仍展示，让用户看到「该动作存在，当前不适用」。
PopupMenuItem<T> ghostLockProfileMenuEntry<T>(
  BuildContext context, {
  required T value,
  required IconData icon,
  required String title,
  required String subtitle,
  bool enabled = true,
}) {
  final ColorScheme scheme = context.colorScheme;
  final Color foreground = enabled
      ? scheme.onSurface
      : scheme.onSurface.withValues(alpha: 0.38);
  final Color secondary = enabled
      ? scheme.onSurfaceVariant
      : scheme.onSurface.withValues(alpha: 0.38);
  return PopupMenuItem<T>(
    value: value,
    enabled: enabled,
    height: 64.h,
    child: Row(
      children: <Widget>[
        Icon(icon, size: 18.sp, color: foreground),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontSize: 13.sp, color: foreground),
              ),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10.5.sp, color: secondary),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
