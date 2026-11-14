import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:Aisupass/core/extensions/context_extensions.dart';

/// 列表卡片：浅底圆角容器，行间细线分隔，与详情页的信息卡片同一套样式。
class KernelProfileRowCard extends StatelessWidget {
  const KernelProfileRowCard({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: <Widget>[
          for (int i = 0; i < children.length; i++) ...<Widget>[
            if (i > 0)
              Divider(
                height: 1.h,
                indent: 12.w,
                endIndent: 12.w,
                color: scheme.outline.withValues(alpha: 0.12),
              ),
            children[i],
          ],
        ],
      ),
    );
  }
}
