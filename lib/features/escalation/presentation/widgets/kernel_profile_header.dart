import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_active_source.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// 顶部信息区：当前生效来源 + 三步进度。
class KernelProfileHeader extends StatelessWidget {
  const KernelProfileHeader({
    super.key,
    required this.current,
    required this.labels,
    required this.source,
  });

  final int current;
  final List<String> labels;
  final GhostLockActiveSource source;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final bool isUser = source.user.isNotEmpty;
    final String sourceName = isUser
        ? l10n.escalationGhostLockProfileSourceUser
        : source.builtin.isNotEmpty
        ? l10n.escalationGhostLockProfileSourceBuiltin
        : l10n.escalationGhostLockProfileSourceDevice;
    final String sourceDetail = isUser ? source.user : source.builtin;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        border: Border(
          bottom: BorderSide(color: scheme.outline.withValues(alpha: 0.15)),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.check_circle_rounded,
                size: 15.sp,
                color: scheme.primary,
              ),
              SizedBox(width: 6.w),
              Text(
                l10n.escalationGhostLockProfileSourceLabel,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  sourceDetail.isEmpty
                      ? sourceName
                      : '$sourceName · $sourceDetail',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: sourceDetail.isEmpty ? null : AppFonts.code,
                    color: scheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: <Widget>[
              for (int i = 0; i < labels.length; i++) ...<Widget>[
                if (i > 0)
                  Expanded(
                    child: Container(
                      height: 1.h,
                      margin: EdgeInsets.symmetric(horizontal: 6.w),
                      color: i <= current
                          ? scheme.primary.withValues(alpha: 0.5)
                          : scheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                _StepDot(
                  index: i,
                  label: labels[i],
                  done: i < current,
                  active: i == current,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// 单个步骤：序号圆点 + 名称；已完成的步骤显示对勾。
class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.index,
    required this.label,
    required this.done,
    required this.active,
  });

  final int index;
  final String label;
  final bool done;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    final bool reached = done || active;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 18.w,
          height: 18.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: reached ? scheme.primary : scheme.surfaceContainerHighest,
          ),
          child: done
              ? Icon(Icons.check_rounded, size: 12.sp, color: scheme.onPrimary)
              : Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: reached ? scheme.onPrimary : scheme.onSurfaceVariant,
                  ),
                ),
        ),
        SizedBox(height: 3.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            color: reached ? scheme.onSurface : scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
