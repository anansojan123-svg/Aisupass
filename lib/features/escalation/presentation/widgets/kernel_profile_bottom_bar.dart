import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:Aisupass/core/extensions/context_extensions.dart';

/// 底部动作条：只放当前步允许的动作。
class KernelProfileBottomBar extends StatelessWidget {
  const KernelProfileBottomBar({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: scheme.outline.withValues(alpha: 0.2)),
          ),
        ),
        child: Row(
          children: <Widget>[
            for (int i = 0; i < children.length; i++) ...<Widget>[
              if (i > 0) SizedBox(width: 10.w),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}
