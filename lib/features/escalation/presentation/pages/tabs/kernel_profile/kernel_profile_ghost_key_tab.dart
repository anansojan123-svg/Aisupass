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
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_pick_row.dart';
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

/// 内置表：搜索固定在顶部，清单在下方独立滚动。
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
          child: _BuiltinPickList(
            profiles: listAsync.value ?? const <KernelProfile>[],
            deviceRelease: deviceRelease,
            activeBuiltin: activeBuiltin,
          ),
        ),
      ],
    );
  }
}

/// 内置表可滚清单：搜索过滤 + 分批。
class _BuiltinPickList extends HookWidget {
  const _BuiltinPickList({
    required this.profiles,
    required this.deviceRelease,
    required this.activeBuiltin,
  });

  final List<KernelProfile> profiles;
  final String deviceRelease;
  final String activeBuiltin;

  /// 内置表可能上百行，分批渲染避免一次建完卡顿。
  static const int _pageSize = 30;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final TextEditingController controller = useTextEditingController();
    final ValueNotifier<String> keyword = useState<String>('');
    final ValueNotifier<int> limit = useState<int>(_pageSize);

    /* 过滤条件变化时回到第一批，避免沿用上一次的展开量。 */
    useEffect(() {
      limit.value = _pageSize;
      return null;
    }, <Object?>[keyword.value]);

    final String lower = keyword.value.trim().toLowerCase();
    final List<KernelProfile> matches = lower.isEmpty
        ? profiles
        : profiles
              .where(
                (KernelProfile item) =>
                    item.release.toLowerCase().contains(lower),
              )
              .toList();
    final List<KernelProfile> visible = matches.take(limit.value).toList();
    final int rest = matches.length - visible.length;

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
          child: TextField(
            controller: controller,
            onChanged: (String value) => keyword.value = value,
            style: TextStyle(fontSize: 12.sp),
            decoration: InputDecoration(
              isDense: true,
              hintText: l10n.escalationGhostLockProfileSelectSearch,
              hintStyle: TextStyle(fontSize: 11.5.sp),
              prefixIcon: Icon(Icons.search_rounded, size: 16.sp),
              border: const OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 8.h,
              ),
            ),
          ),
        ),
        Expanded(
          child: matches.isEmpty
              ? Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
                  child: KernelProfileEmptyHint(
                    text: l10n.kernelProfileBuiltinEmpty,
                  ),
                )
              : ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 24.h),
                  children: <Widget>[
                    KernelProfileRowCard(
                      children: <Widget>[
                        for (final KernelProfile profile in visible)
                          _BuiltinPickRow(
                            profile: profile,
                            deviceRelease: deviceRelease,
                            activeBuiltin: activeBuiltin,
                          ),
                      ],
                    ),
                    if (rest > 0)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () => limit.value += _pageSize,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            l10n.kernelProfileShowMore(rest),
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              color: scheme.primary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

/// 内置表单选行：选中即生效，与 GhostLock 的选表一致。
class _BuiltinPickRow extends HookConsumerWidget {
  const _BuiltinPickRow({
    required this.profile,
    required this.deviceRelease,
    required this.activeBuiltin,
  });

  final KernelProfile profile;
  final String deviceRelease;
  final String activeBuiltin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final bool selected = profile.release == activeBuiltin;

    Future<void> select() async {
      try {
        final bool ok = await ref
            .read(kernelProfileActionsProvider)
            .selectBuiltin(profile.release);
        if (!context.mounted) return;
        if (!ok ||
            (deviceRelease.isNotEmpty && profile.release != deviceRelease)) {
          ToastMessage.warning(l10n.kernelProfileApplyNotEffective);
        }
      } catch (error) {
        ToastMessage.error(error);
      }
    }

    /* 选中但与设备不一致时把风险写在副标题上，不必等运行被拒才知道。 */
    final bool matchesDevice =
        deviceRelease.isNotEmpty && profile.release == deviceRelease;
    final String? subtitle = matchesDevice
        ? l10n.kernelProfileMatchesDevice
        : selected
        ? l10n.kernelProfileReviewMismatch
        : null;

    return KernelProfilePickRow(
      key: ValueKey<String>(profile.release),
      title: profile.release,
      subtitle: subtitle,
      selected: selected,
      active: selected,
      onTap: select,
    );
  }
}
