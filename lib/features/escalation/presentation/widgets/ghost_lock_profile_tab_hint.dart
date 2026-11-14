import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:Aisupass/core/extensions/context_extensions.dart';

/// 页签顶部说明：这一页改什么、什么时候生效。
class GhostLockProfileTabHint extends StatelessWidget {
  const GhostLockProfileTabHint({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    return Padding(
      padding: EdgeInsets.only(top: 4.h, bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.info_outline_rounded,
            size: 13.sp,
            color: scheme.onSurfaceVariant,
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11.sp,
                height: 1.35,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
