import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/kernel_profile_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/kernel_profile_query_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_empty_hint.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_imported_row.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_key_builtin_list.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_row_card.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// GhostKey 内核表页签：我的配置与内置表两个页签，各占一屏独立滚动。
///
/// 选表与 GhostLock 一致：两个来源互斥单选，选中即生效；都未指定时
/// 取最近导入的同 release 文档，再回退到内置表精确匹配。
class KernelProfileGhostKeyTab extends HookConsumerWidget {
  const KernelProfileGhostKeyTab({super.key, this.onImport});

  /// 空列表时的导入入口，由页面传入以复用同一个导入弹窗与页签切换。
  final VoidCallback? onImport;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final TabController tabController = useTabController(initialLength: 2);

    final String deviceRelease =
        ref.watch(currentDeviceIdentityProvider).value?.kernelRelease ?? '';
    final String activeName =
        ref.watch(kernelProfileActiveNameProvider).value ?? '';
    final String activeBuiltin =
        ref.watch(kernelProfileActiveBuiltinProvider).value ?? '';

    return Column(
      children: <Widget>[
        TabBar(
          controller: tabController,
          tabs: <Widget>[
            Tab(text: l10n.kernelProfileMyProfilesTitle),
            Tab(text: l10n.kernelProfileBuiltinTitle),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: <Widget>[
              _ImportedTab(
                deviceRelease: deviceRelease,
                activeName: activeName,
                onImport: onImport,
              ),
              _BuiltinTab(
                deviceRelease: deviceRelease,
                activeBuiltin: activeBuiltin,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 我的配置：独立滚动列表，点行左侧圆点指定生效文档。
class _ImportedTab extends HookConsumerWidget {
  const _ImportedTab({
    required this.deviceRelease,
    required this.activeName,
    required this.onImport,
  });

  final String deviceRelease;
  final String activeName;
  final VoidCallback? onImport;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final AsyncValue<List<KernelProfile>> listAsync = ref.watch(
      kernelProfileListProvider,
    );

    /* 选择即生效；release 与设备不符时如实提示，运行侧会拒绝。 */
    Future<void> select(String name, {required String release}) async {
      try {
        final bool ok = await ref
            .read(kernelProfileActionsProvider)
            .select(name);
        if (!context.mounted) return;
        if (!ok || (deviceRelease.isNotEmpty && release != deviceRelease)) {
          ToastMessage.warning(l10n.kernelProfileApplyNotEffective);
        }
      } catch (error) {
        ToastMessage.error(error);
      }
    }

    return listAsync.when(
      loading: () => SizedBox(height: 60.h, child: const Loading()),
      error: (Object error, StackTrace stackTrace) =>
          RefError(onRetry: () => ref.invalidate(kernelProfileListProvider)),
      data: (List<KernelProfile> list) {
        return ListView(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
          children: <Widget>[
            Text(
              l10n.kernelProfileKeySelectHint,
              style: TextStyle(
                fontSize: 11.sp,
                height: 1.45,
                color: scheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 6.h),
            if (list.isEmpty)
              KernelProfileEmptyHint(
                text: l10n.kernelProfileImportedEmpty,
                onImport: onImport,
              )
            else
              KernelProfileRowCard(
                children: <Widget>[
                  for (final KernelProfile profile in list)
                    KernelProfileImportedRow(
                      profile: profile,
                      editable: true,
                      selected: profile.name == activeName,
                      active: profile.name == activeName,
                      matched:
                          profile.name == activeName &&
                          (deviceRelease.isEmpty ||
                              profile.release == deviceRelease),
                      mismatch:
                          profile.name == activeName &&
                          deviceRelease.isNotEmpty &&
                          profile.release != deviceRelease,
                      onSelect: () =>
                          select(profile.name, release: profile.release),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }
}

/// 内置表：说明文字固定在顶部，清单在下方独立滚动。
class _BuiltinTab extends HookConsumerWidget {
  const _BuiltinTab({required this.deviceRelease, required this.activeBuiltin});

  final String deviceRelease;
  final String activeBuiltin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final AsyncValue<List<KernelProfile>> listAsync = ref.watch(
      kernelProfileBuiltinListProvider,
    );

    if (listAsync.isLoading) {
      return SizedBox(height: 60.h, child: const Loading());
    }
    if (listAsync.hasError) {
      return RefError(
        onRetry: () => ref.invalidate(kernelProfileBuiltinListProvider),
      );
    }

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
          child: Text(
            l10n.kernelProfileBuiltinHint,
            style: TextStyle(fontSize: 10.5.sp, color: scheme.onSurfaceVariant),
          ),
        ),
        Expanded(
          child: KernelProfileKeyBuiltinList(
            profiles: listAsync.value ?? const <KernelProfile>[],
            deviceRelease: deviceRelease,
            activeBuiltin: activeBuiltin,
          ),
        ),
      ],
    );
  }
}
