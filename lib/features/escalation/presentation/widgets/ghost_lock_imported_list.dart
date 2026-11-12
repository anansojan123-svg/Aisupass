import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_user_profile.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/ghost_lock_profile_detail_sheet.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_remove_dialog.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// GhostLock 已导入内核表列表：release + 文件名 + 大小 + 解析失败标记 + 删除。
class GhostLockImportedList extends HookConsumerWidget {
  const GhostLockImportedList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final AsyncValue<List<GhostLockUserProfile>> async = ref.watch(
      ghostLockImportedProfilesProvider,
    );

    Future<void> remove(GhostLockUserProfile profile) async {
      final bool? confirmed = await showKernelProfileRemoveDialog(
        context,
        release: profile.parseError ? profile.name : profile.release,
      );
      if (confirmed != true) return;
      try {
        await ref
            .read(ghostLockProfileActionsProvider)
            .removeImportedProfile(name: profile.name);
      } catch (error) {
        ToastMessage.error(error);
      }
    }

    return async.when(
      loading: () => SizedBox(height: 80.h, child: const Loading()),
      error: (Object error, StackTrace stackTrace) => RefError(
        onRetry: () => ref.invalidate(ghostLockImportedProfilesProvider),
      ),
      data: (List<GhostLockUserProfile> profiles) {
        if (profiles.isEmpty) {
          return Text(
            l10n.escalationGhostLockImportedEmpty,
            style: TextStyle(fontSize: 12.sp, color: scheme.onSurfaceVariant),
          );
        }
        return Column(
          children: <Widget>[
            for (final GhostLockUserProfile profile in profiles)
              _GhostLockImportedRow(
                profile: profile,
                onRemove: () => remove(profile),
              ),
          ],
        );
      },
    );
  }
}

/// 单行：release + 文件名 + 大小 + 详情 + 删除。
///
/// 点行打开详情弹窗，与 GhostKey 的已导入列表一致。
class _GhostLockImportedRow extends HookWidget {
  const _GhostLockImportedRow({required this.profile, required this.onRemove});

  final GhostLockUserProfile profile;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final String release = profile.parseError
        ? l10n.escalationGhostLockImportedParseError
        : profile.release;

    return InkWell(
      onTap: () =>
          showGhostLockProfileDetailSheet(context, profile: profile),
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    release,
                    style: TextStyle(
                      fontFamily: AppFonts.code,
                      fontSize: 12.5.sp,
                      color: profile.parseError
                          ? scheme.error
                          : scheme.onSurface,
                    ),
                  ),
                  Text(
                    '${profile.name} · '
                    '${(profile.sizeBytes / 1024).toStringAsFixed(1)} KB',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 18.sp,
              color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            IconButton(
              onPressed: onRemove,
              tooltip: l10n.escalationGhostLockImportedRemove,
              icon: Icon(
                Icons.delete_outline_rounded,
                size: 20.r,
                color: scheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
