import 'package:Aisupass/common/widgets/app_setting_icon.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// DirtyFrag 设置组的一行：图标 + 标题/说明 + 开关，与设置页其它行同版式。
class DirtyFragSettingRow extends StatelessWidget {
  const DirtyFragSettingRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;

  /// 为 `null` 时整行置灰不可点。
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    final bool enabled = onChanged != null;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
                  style: context.textTheme.titleSmall?.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: enabled
                        ? scheme.onSurface
                        : scheme.onSurface.withValues(alpha: 0.38),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: scheme.onSurfaceVariant.withValues(
                      alpha: enabled ? 1 : 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
