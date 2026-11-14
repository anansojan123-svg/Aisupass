import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/routes/app_route.dart';
import 'package:Aisupass/features/escalation/domain/enums/kernel_profile_import_target.dart';
import 'package:Aisupass/features/escalation/domain/models/device_identity.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_active_source.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_profile_config.dart';
import 'package:Aisupass/features/escalation/presentation/controllers/kernel_profile_controller.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_apply_step.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_bottom_bar.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_header.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_import_panel.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_pick_step.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_review_step.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// GhostLock 页签：选表 → 确认来源 → 应用。
class KernelProfileGhostLockTab extends HookConsumerWidget {
  const KernelProfileGhostLockTab({super.key, required this.onImported});

  /// 导入落到其他表时由页面切页签。
  final ValueChanged<KernelProfileImportTarget> onImported;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ValueNotifier<int> step = useState<int>(0);
    final ValueNotifier<String> pickedUser = useState<String>('');
    final ValueNotifier<String> pickedBuiltin = useState<String>('');
    final ValueNotifier<bool> applied = useState<bool>(false);
    final ValueNotifier<bool> busy = useState<bool>(false);
    final KernelProfileController flow = useMemoized(
      () => KernelProfileController(ref: ref),
      const <Object?>[],
    );

    final AsyncValue<DeviceIdentity> identityAsync = ref.watch(
      currentDeviceIdentityProvider,
    );
    final String deviceRelease = identityAsync.value?.kernelRelease ?? '';
    final GhostLockActiveSource source =
        ref.watch(ghostLockActiveSourceProvider).value ??
        const GhostLockActiveSource(builtin: '', user: '');

    /* 选中态在 ValueNotifier 里，订阅后本页才知道能不能进下一步。 */
    final String pickedUserName = useValueListenable(pickedUser);
    final String pickedBuiltinName = useValueListenable(pickedBuiltin);

    /* 生效来源到位后作为初始选中项，避免「字体是生效色、圆点却空着」。 */
    final ObjectRef<bool> seeded = useRef<bool>(false);
    useEffect(() {
      if (seeded.value) return null;
      if (source.user.isEmpty && source.builtin.isEmpty) return null;
      seeded.value = true;
      if (source.user.isNotEmpty) {
        pickedUser.value = source.user;
      } else {
        pickedBuiltin.value = source.builtin;
      }
      return null;
    }, <Object?>[source.user, source.builtin]);

    final bool hasPick =
        pickedUserName.isNotEmpty || pickedBuiltinName.isNotEmpty;

    Future<void> apply() async {
      if (deviceRelease.isEmpty || !hasPick) return;
      busy.value = true;
      try {
        final GhostLockProfileConfig result = await flow.applyProfile(
          deviceRelease: deviceRelease,
          pickedUser: pickedUser.value,
          pickedBuiltin: pickedBuiltin.value,
        );
        /* 文档声明的内核与设备不一致时原生解析为空，不能报成功。 */
        applied.value = result.hasProfile;
        if (context.mounted) {
          if (result.hasProfile) {
            ToastMessage.success(l10n.kernelProfileApplied);
          } else {
            ToastMessage.error(l10n.kernelProfileApplyNotEffective);
          }
        }
      } catch (error) {
        ToastMessage.error(error);
      } finally {
        busy.value = false;
      }
    }

    void reset() {
      step.value = 0;
      applied.value = false;
      pickedUser.value = '';
      pickedBuiltin.value = '';
    }

    Future<void> openImport() async {
      final KernelProfileImportTarget? written =
          await showKernelProfileImportSheet(
            context,
            initialTarget: KernelProfileImportTarget.ghostLock,
          );
      if (written == null || !context.mounted) return;
      if (written != KernelProfileImportTarget.ghostLock) {
        onImported(written);
      }
    }

    return Column(
      children: <Widget>[
        KernelProfileHeader(
          current: step.value,
          labels: <String>[
            l10n.kernelProfileStepPick,
            l10n.kernelProfileStepReview,
            l10n.kernelProfileStepApply,
          ],
          source: source,
        ),
        Expanded(
          child: switch (step.value) {
            0 => KernelProfilePickStep(
              deviceRelease: deviceRelease,
              source: source,
              pickedUser: pickedUser,
              pickedBuiltin: pickedBuiltin,
              onImport: openImport,
            ),
            1 => KernelProfileReviewStep(
              deviceRelease: deviceRelease,
              pickedUser: pickedUserName,
              pickedBuiltin: pickedBuiltinName,
            ),
            _ => KernelProfileApplyStep(
              deviceRelease: deviceRelease,
              pickedUser: pickedUserName,
              pickedBuiltin: pickedBuiltinName,
              applied: applied.value,
            ),
          },
        ),
        KernelProfileBottomBar(
          children: <Widget>[
            if (step.value > 0 && !applied.value)
              Expanded(
                child: OutlinedButton(
                  onPressed: busy.value
                      ? null
                      : () => step.value = step.value - 1,
                  child: Text(l10n.kernelProfileStepBack),
                ),
              ),
            if (step.value == 0)
              Expanded(
                child: FilledButton(
                  onPressed: hasPick ? () => step.value = 1 : null,
                  child: Text(l10n.kernelProfileStepNext),
                ),
              ),
            if (step.value == 1)
              Expanded(
                child: FilledButton(
                  onPressed: () => step.value = 2,
                  child: Text(l10n.kernelProfileStepNext),
                ),
              ),
            if (step.value == 2 && !applied.value)
              Expanded(
                child: FilledButton(
                  onPressed: busy.value || !hasPick ? null : apply,
                  child: busy.value
                      ? SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Text(l10n.kernelProfileApplyAction),
                ),
              ),
            if (step.value == 2 && applied.value) ...<Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: reset,
                  child: Text(l10n.kernelProfilePickAgain),
                ),
              ),
              Expanded(
                child: FilledButton(
                  onPressed: () =>
                      context.push(AppRoute.ghostLockProfilePath(source.user)),
                  child: Text(l10n.kernelProfileEditAfterApply),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
