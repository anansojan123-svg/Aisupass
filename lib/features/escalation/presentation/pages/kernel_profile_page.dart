import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/kernel_profile_query_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/ghost_lock_imported_list.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/ghost_lock_profile_detail_sheet.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_import_panel.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_imported_row.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 内核表页面：导入区与页签互不影响。
///
/// 导入 → 解析 → 选落点的流程全在 [KernelProfileImportPanel] 内部完成；
/// 下方页签只浏览「已导入 / 内置」两类内核表，切换页签不会改变任何导入行为。
class KernelProfilePage extends HookConsumerWidget {
  const KernelProfilePage({super.key, this.initialTab = 0});

  /// 初始浏览的页签：0 = GhostKey 已导入，1 = GhostKey 内置，
  /// 2 = GhostLock 已导入，3 = GhostLock 内置。
  final int initialTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final TabController tab = useTabController(
      initialLength: 4,
      initialIndex: initialTab.clamp(0, 3),
    );
    // TabBar 只改 controller，不重建页面；订阅一次拿到当前索引。
    useListenable(tab);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.kernelProfileTitle)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
        children: <Widget>[
          Text(
            l10n.kernelProfilePageDesc,
            style: TextStyle(
              fontSize: 12.sp,
              height: 1.5,
              color: scheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 16.h),
          const KernelProfileImportPanel(),
          SizedBox(height: 26.h),
          Text(
            l10n.kernelProfileImportedSection,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
          SizedBox(height: 4.h),
          TabBar(
            controller: tab,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelStyle: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: TextStyle(fontSize: 13.sp),
            tabs: <Widget>[
              Tab(text: l10n.kernelProfileTabGhostKey),
              Tab(text: l10n.kernelProfileTabGhostKeyBuiltin),
              Tab(text: l10n.kernelProfileTabGhostLock),
              Tab(text: l10n.kernelProfileTabGhostLockBuiltin),
            ],
          ),
          SizedBox(height: 10.h),
          switch (tab.index) {
            0 => const _GhostKeyList(),
            1 => const _GhostKeyBuiltinList(),
            2 => const GhostLockImportedList(),
            _ => const _GhostLockBuiltinList(),
          },
        ],
      ),
    );
  }
}

/// GhostKey 已导入 profile 列表。
class _GhostKeyList extends HookConsumerWidget {
  const _GhostKeyList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final AsyncValue<List<KernelProfile>> listAsync = ref.watch(
      kernelProfileListProvider,
    );

    return listAsync.when(
      loading: () => SizedBox(height: 120.h, child: const Loading()),
      error: (Object error, StackTrace stackTrace) => RefError(
        onRetry: () => ref.invalidate(kernelProfileListProvider),
      ),
      data: (List<KernelProfile> list) {
        if (list.isEmpty) {
          return Text(
            l10n.kernelProfileImportedEmpty,
            style: TextStyle(fontSize: 12.sp, color: scheme.onSurfaceVariant),
          );
        }
        return Column(
          children: <Widget>[
            for (final KernelProfile profile in list)
              KernelProfileImportedRow(profile: profile),
          ],
        );
      },
    );
  }
}

/// GhostKey 内置 profile 列表：只读，点行看详情。
class _GhostKeyBuiltinList extends HookConsumerWidget {
  const _GhostKeyBuiltinList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final AsyncValue<List<KernelProfile>> listAsync = ref.watch(
      kernelProfileBuiltinListProvider,
    );

    return listAsync.when(
      loading: () => SizedBox(height: 120.h, child: const Loading()),
      error: (Object error, StackTrace stackTrace) => RefError(
        onRetry: () => ref.invalidate(kernelProfileBuiltinListProvider),
      ),
      data: (List<KernelProfile> list) {
        if (list.isEmpty) {
          return Text(
            l10n.kernelProfileBuiltinEmpty,
            style: TextStyle(fontSize: 12.sp, color: scheme.onSurfaceVariant),
          );
        }
        return Column(
          children: <Widget>[
            for (final KernelProfile profile in list)
              KernelProfileImportedRow(profile: profile, showDelete: false),
          ],
        );
      },
    );
  }
}

/// GhostLock 内置 profile 列表：只读 release 清单。
class _GhostLockBuiltinList extends HookConsumerWidget {
  const _GhostLockBuiltinList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final AsyncValue<List<String>> listAsync = ref.watch(
      ghostLockBuiltinReleasesProvider,
    );

    return listAsync.when(
      loading: () => SizedBox(height: 120.h, child: const Loading()),
      error: (Object error, StackTrace stackTrace) => RefError(
        onRetry: () => ref.invalidate(ghostLockBuiltinReleasesProvider),
      ),
      data: (List<String> releases) {
        if (releases.isEmpty) {
          return Text(
            l10n.kernelProfileBuiltinEmpty,
            style: TextStyle(fontSize: 12.sp, color: scheme.onSurfaceVariant),
          );
        }
        return Column(
          children: <Widget>[
            for (final String release in releases)
              InkWell(
                onTap: () =>
                    showGhostLockBuiltinDetailSheet(context, release: release),
                borderRadius: BorderRadius.circular(8.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 5.h,
                    horizontal: 4.w,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          release,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: AppFonts.code,
                            color: scheme.onSurface,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 18.sp,
                        color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
