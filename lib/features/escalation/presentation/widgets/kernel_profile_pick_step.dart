import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_active_source.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_user_profile.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/ghost_lock_imported_list.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/ghost_lock_profile_detail_sheet.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_pick_row.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// 第一步：选一份内核表。两组候选各自独立滚动，不再上下叠在一屏。
class KernelProfilePickStep extends HookWidget {
  const KernelProfilePickStep({
    super.key,
    required this.deviceRelease,
    required this.source,
    required this.pickedUser,
    required this.pickedBuiltin,
    required this.onImport,
  });

  final String deviceRelease;
  final GhostLockActiveSource source;
  final ValueNotifier<String> pickedUser;
  final ValueNotifier<String> pickedBuiltin;
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final TabController tabController = useTabController(initialLength: 2);

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
          child: Text(
            l10n.kernelProfilePickHint,
            style: TextStyle(
              fontSize: 11.5.sp,
              height: 1.45,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
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
              _UserPickList(
                activeName: source.user,
                pickedUser: pickedUser,
                pickedBuiltin: pickedBuiltin,
                onImport: onImport,
              ),
              _BuiltinPickSection(
                deviceRelease: deviceRelease,
                activeBuiltin: source.builtin,
                pickedBuiltin: pickedBuiltin,
                pickedUser: pickedUser,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 我的配置：可滚动列表，点行即选中该文档作为覆盖层。
class _UserPickList extends HookWidget {
  const _UserPickList({
    required this.activeName,
    required this.pickedUser,
    required this.pickedBuiltin,
    required this.onImport,
  });

  final String activeName;
  final ValueNotifier<String> pickedUser;
  final ValueNotifier<String> pickedBuiltin;
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    /* 选中态存在 ValueNotifier 里，必须监听才会重画圆点。 */
    final String selected = useValueListenable(pickedUser);
    return ListView(
      padding: EdgeInsets.only(bottom: 24.h),
      children: <Widget>[
        GhostLockImportedList(
          activeName: activeName,
          selectedName: selected,
          onImport: onImport,
          onSelect: (GhostLockUserProfile profile) {
            pickedUser.value = profile.name;
            /* 两组候选互斥，选中用户文档就清掉内置表的选择。 */
            pickedBuiltin.value = '';
          },
        ),
      ],
    );
  }
}

/// 内置表：搜索固定在顶部，清单在下方独立滚动。
class _BuiltinPickSection extends HookConsumerWidget {
  const _BuiltinPickSection({
    required this.deviceRelease,
    required this.activeBuiltin,
    required this.pickedBuiltin,
    required this.pickedUser,
  });

  final String deviceRelease;
  final String activeBuiltin;
  final ValueNotifier<String> pickedBuiltin;
  final ValueNotifier<String> pickedUser;

  /// 每次展开的条目数：内置表有 80+ 行，一次全建会拖慢展开。
  static const int _pageSize = 30;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final AsyncValue<List<String>> async = ref.watch(
      ghostLockBuiltinReleasesProvider,
    );

    if (async.isLoading) {
      return SizedBox(height: 60.h, child: const Loading());
    }
    if (async.hasError) {
      return RefError(
        onRetry: () => ref.invalidate(ghostLockBuiltinReleasesProvider),
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
            releases: async.value ?? const <String>[],
            deviceRelease: deviceRelease,
            activeBuiltin: activeBuiltin,
            pickedBuiltin: pickedBuiltin,
            pickedUser: pickedUser,
            pageSize: _pageSize,
          ),
        ),
      ],
    );
  }
}

/// 内置表可滚清单：搜索过滤 + 分批。
class _BuiltinPickList extends HookWidget {
  const _BuiltinPickList({
    required this.releases,
    required this.deviceRelease,
    required this.activeBuiltin,
    required this.pickedBuiltin,
    required this.pickedUser,
    required this.pageSize,
  });

  final List<String> releases;
  final String deviceRelease;
  final String activeBuiltin;
  final ValueNotifier<String> pickedBuiltin;
  final ValueNotifier<String> pickedUser;
  final int pageSize;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final TextEditingController controller = useTextEditingController();
    final ValueNotifier<String> keyword = useState<String>('');
    final ValueNotifier<int> limit = useState<int>(pageSize);

    /* 过滤条件变化时回到第一批，避免沿用上一次的展开量。 */
    useEffect(() {
      limit.value = pageSize;
      return null;
    }, <Object?>[keyword.value]);

    final String lower = keyword.value.trim().toLowerCase();
    /* 点行只改 ValueNotifier，订阅后才能重画选中态。 */
    final String selectedBuiltin = useValueListenable(pickedBuiltin);
    final List<String> matches = lower.isEmpty
        ? releases
        : releases
              .where((String item) => item.toLowerCase().contains(lower))
              .toList();
    final List<String> visible = matches.take(limit.value).toList();
    final int rest = matches.length - visible.length;
    final List<String> regular = visible
        .where((String item) => !item.endsWith('-template'))
        .toList();
    final List<String> templates = visible
        .where((String item) => item.endsWith('-template'))
        .toList();

    Widget row(String release) => KernelProfilePickRow(
      key: ValueKey<String>(release),
      title: release,
      subtitle: release == deviceRelease && deviceRelease.isNotEmpty
          ? l10n.kernelProfileMatchesDevice
          : null,
      selected: selectedBuiltin == release,
      active: release == activeBuiltin,
      onTap: () {
        pickedBuiltin.value = release;
        pickedUser.value = '';
      },
    );

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
                  padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
                  child: Text(
                    l10n.kernelProfileBuiltinEmpty,
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                )
              : ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 24.h),
                  children: <Widget>[
                    for (final String release in regular) row(release),
                    if (templates.isNotEmpty) ...<Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10.h, 0, 2.h),
                        child: Text(
                          l10n.escalationGhostLockProfileSelectTemplates,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: Text(
                          l10n.kernelProfileTemplateHint,
                          style: TextStyle(
                            fontSize: 10.5.sp,
                            height: 1.35,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      /* 模板字段全为 null，永远解析不出可生效配置，只能看结构。 */
                      for (final String release in templates)
                        KernelProfilePickRow(
                          key: ValueKey<String>(release),
                          title: release,
                          leading: Icon(
                            Icons.description_outlined,
                            size: 16.sp,
                            color: scheme.onSurfaceVariant,
                          ),
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            size: 18.sp,
                            color: scheme.onSurfaceVariant,
                          ),
                          onTap: () => showGhostLockBuiltinDetailSheet(
                            context,
                            release: release,
                            editable: false,
                          ),
                        ),
                    ],
                    if (rest > 0)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () => limit.value += pageSize,
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
