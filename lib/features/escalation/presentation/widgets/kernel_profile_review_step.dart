import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_user_profile.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// 第二步：只读确认将要生效的是哪份表。
class KernelProfileReviewStep extends HookConsumerWidget {
  const KernelProfileReviewStep({
    super.key,
    required this.deviceRelease,
    required this.pickedUser,
    required this.pickedBuiltin,
  });

  final String deviceRelease;
  final String pickedUser;
  final String pickedBuiltin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final List<GhostLockUserProfile> profiles =
        ref.watch(ghostLockImportedProfilesProvider).value ??
        const <GhostLockUserProfile>[];

    final bool isUser = pickedUser.isNotEmpty;
    final String declared = isUser
        ? profiles
                  .where((GhostLockUserProfile p) => p.name == pickedUser)
                  .firstOrNull
                  ?.release ??
              ''
        : pickedBuiltin;
    final String sourceText = isUser
        ? '${l10n.escalationGhostLockProfileSourceUser} · $pickedUser'
        : '${l10n.escalationGhostLockProfileSourceBuiltin} · $pickedBuiltin';
    final bool matched = declared.isNotEmpty && declared == deviceRelease;

    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 24.h),
      children: <Widget>[
        Text(
          l10n.kernelProfileReviewHint,
          style: TextStyle(
            fontSize: 11.5.sp,
            height: 1.45,
            color: scheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 14.h),
        KernelProfileInfoCard(
          rows: <Widget>[
            KernelProfileInfoRow(
              label: l10n.escalationGhostLockProfileSourceLabel,
              value: sourceText,
            ),
            KernelProfileInfoRow(
              label: l10n.kernelProfileDeclaredKernel,
              value: declared.isEmpty
                  ? l10n.escalationGhostLockValueUnknown
                  : declared,
              mono: true,
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
        SizedBox(height: 14.h),
        _Banner(
          ok: matched,
          text: matched
              ? l10n.kernelProfileReviewMatch
              : l10n.kernelProfileReviewMismatch,
        ),
        SizedBox(height: 14.h),
        Text(
          l10n.kernelProfileEditAfterApplyHint,
          style: TextStyle(
            fontSize: 11.sp,
            height: 1.45,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// 左标签右值的一行。
class KernelProfileInfoRow extends StatelessWidget {
  const KernelProfileInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.mono = false,
  });

  final String label;
  final String value;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 72.w,
          child: Text(
            label,
            style: TextStyle(fontSize: 11.5.sp, color: scheme.onSurfaceVariant),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 11.5.sp,
              height: 1.35,
              fontFamily: mono ? AppFonts.code : null,
              color: scheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

/// 信息卡片：多行「标签 + 值」，行间用细线分隔。
class KernelProfileInfoCard extends StatelessWidget {
  const KernelProfileInfoCard({super.key, required this.rows});

  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: <Widget>[
          for (int i = 0; i < rows.length; i++) ...<Widget>[
            if (i > 0)
              Divider(
                height: 1.h,
                color: scheme.outline.withValues(alpha: 0.12),
              ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 9.h),
              child: rows[i],
            ),
          ],
        ],
      ),
    );
  }
}

/// 校验提示条：通过为绿（主色），不通过为错误色。
class _Banner extends StatelessWidget {
  const _Banner({required this.ok, required this.text});

  final bool ok;
  final String text;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    final Color color = ok ? scheme.primary : scheme.error;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            ok
                ? Icons.check_circle_outline_rounded
                : Icons.error_outline_rounded,
            size: 15.sp,
            color: color,
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 11.5.sp, height: 1.4, color: color),
            ),
          ),
        ],
      ),
    );
  }
}
