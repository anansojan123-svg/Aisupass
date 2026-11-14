import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_review_step.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// 第三步：应用，或已应用后的收尾。
class KernelProfileApplyStep extends StatelessWidget {
  const KernelProfileApplyStep({
    super.key,
    required this.deviceRelease,
    required this.pickedUser,
    required this.pickedBuiltin,
    required this.applied,
  });

  final String deviceRelease;
  final String pickedUser;
  final String pickedBuiltin;
  final bool applied;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final bool isUser = pickedUser.isNotEmpty;
    final String sourceText = isUser
        ? '${l10n.escalationGhostLockProfileSourceUser} · $pickedUser'
        : '${l10n.escalationGhostLockProfileSourceBuiltin} · $pickedBuiltin';

    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
      children: <Widget>[
        _ResultBanner(
          applied: applied,
          text: applied
              ? l10n.kernelProfileApplied
              : l10n.kernelProfileApplyAction,
        ),
        SizedBox(height: 14.h),
        KernelProfileInfoCard(
          rows: <Widget>[
            KernelProfileInfoRow(
              label: l10n.escalationGhostLockProfileSourceLabel,
              value: sourceText,
            ),
            KernelProfileInfoRow(
              label: l10n.kernelProfileDeviceKernel,
              value: deviceRelease.isEmpty
                  ? l10n.escalationGhostLockValueUnknown
                  : deviceRelease,
              mono: true,
            ),
          ],
        ),
      ],
    );
  }
}

/// 第三步的结果状态块：已生效为主色，未生效为中性色。
class _ResultBanner extends StatelessWidget {
  const _ResultBanner({required this.applied, required this.text});

  final bool applied;
  final String text;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    final Color color = applied ? scheme.primary : scheme.onSurfaceVariant;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            applied
                ? Icons.check_circle_rounded
                : Icons.play_circle_outline_rounded,
            size: 20.sp,
            color: color,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w600,
                color: applied ? scheme.primary : scheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
