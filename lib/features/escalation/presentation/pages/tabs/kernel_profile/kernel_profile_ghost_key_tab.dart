import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/kernel_profile_query_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_empty_hint.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_imported_row.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_row_card.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// GhostKey 生效来源：显式选中的用户文档 → 最近修改的同 release 文档 → 内置表。
enum _KeySource { user, builtin, none }

/// GhostKey 内核表页签：我的配置与内置表两个页签，各占一屏独立滚动。
///
/// GhostKey 按 `uname -r` 精确匹配；同一 release 可以有多份用户文档，
/// 由「我的配置」里显式选择生效，未选择时取最近修改的一份。
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
    final List<KernelProfile> imported =
        ref.watch(kernelProfileListProvider).value ?? const <KernelProfile>[];
    final List<KernelProfile> builtin =
        ref.watch(kernelProfileBuiltinListProvider).value ??
        const <KernelProfile>[];
    final String activeName =
        ref.watch(kernelProfileActiveNameProvider).value ?? '';

    /* 显式选择优先；未选择时列表已按最近修改倒序，第一条匹配即实际生效。 */
    final KernelProfile? userHit = activeName.isNotEmpty
        ? imported
              .where(
                (KernelProfile p) =>
                    p.name == activeName && p.release == deviceRelease,
              )
              .firstOrNull
        : imported
              .where((KernelProfile p) => p.release == deviceRelease)
              .firstOrNull;
    final bool builtinHit =
        userHit == null &&
        deviceRelease.isNotEmpty &&
        builtin.any((KernelProfile p) => p.release == deviceRelease);
    final _KeySource source = userHit != null
        ? _KeySource.user
        : builtinHit
        ? _KeySource.builtin
        : _KeySource.none;

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
                userHit: userHit,
                activeName: activeName,
                onImport: onImport,
              ),
              _BuiltinTab(deviceRelease: deviceRelease, source: source),
            ],
          ),
        ),
      ],
    );
  }
}

/// 我的配置：独立滚动列表。
class _ImportedTab extends HookConsumerWidget {
  const _ImportedTab({
    required this.userHit,
    required this.activeName,
    required this.onImport,
  });

  final KernelProfile? userHit;
  final String activeName;
  final VoidCallback? onImport;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final AsyncValue<List<KernelProfile>> listAsync = ref.watch(
      kernelProfileListProvider,
    );

    return listAsync.when(
      loading: () => SizedBox(height: 60.h, child: const Loading()),
      error: (Object error, StackTrace stackTrace) =>
          RefError(onRetry: () => ref.invalidate(kernelProfileListProvider)),
      data: (List<KernelProfile> list) {
        return ListView(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
          children: <Widget>[
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
                      active: profile.name == activeName,
                      matched: profile.name == userHit?.name,
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
  const _BuiltinTab({required this.deviceRelease, required this.source});

  final String deviceRelease;
  final _KeySource source;

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
            source: source,
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
    required this.source,
  });

  final List<KernelProfile> profiles;
  final String deviceRelease;
  final _KeySource source;

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
                          KernelProfileImportedRow(
                            profile: profile,
                            showDelete: false,
                            matched:
                                source == _KeySource.builtin &&
                                profile.release == deviceRelease,
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
