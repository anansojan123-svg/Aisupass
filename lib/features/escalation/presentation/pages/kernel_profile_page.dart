import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/routes/app_route.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/features/escalation/domain/models/device_identity.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_active_source.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_profile_config.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_user_profile.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/ghost_key_profile_tab.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/ghost_lock_imported_list.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/ghost_lock_profile_detail_sheet.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_import_panel.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 内核表：GhostLock 与 GhostKey 两张表并列，各自独立生效。
///
/// 导入是页面级共享入口：一次解析（Rust 侧）得到 conf 与 boot，写入目标表后
/// 自动切到该页签；GhostKey 复用同一份 boot，不重复下载。
class KernelProfilePage extends HookConsumerWidget {
  const KernelProfilePage({super.key, this.initialTab = 0});

  /// 兼容旧路由参数（`?tab=ghostlock`），映射到对应页签。
  final int initialTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final TabController tabController = useTabController(
      initialLength: 2,
      initialIndex: initialTab.clamp(0, 1),
    );

    Future<void> openImport() async {
      /* 默认落到用户当前看的页签；弹窗内仍可切换。 */
      final KernelProfileImportTarget? written =
          await showKernelProfileImportSheet(
            context,
            initialTarget: tabController.index == 1
                ? KernelProfileImportTarget.ghostKey
                : KernelProfileImportTarget.ghostLock,
          );
      if (written == null || !context.mounted) return;
      _showTab(tabController, written);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.kernelProfileTitle),
        actions: <Widget>[
          IconButton(
            tooltip: l10n.kernelProfileImportEntry,
            onPressed: openImport,
            icon: const Icon(Icons.add_circle_outline_rounded),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          TabBar(
            controller: tabController,
            tabs: <Widget>[
              Tab(text: l10n.kernelProfileGhostLockEntry),
              Tab(text: l10n.kernelProfileGhostKeyEntry),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: <Widget>[
                _GhostLockTab(
                  onImported: (KernelProfileImportTarget target) =>
                      _showTab(tabController, target),
                ),
                GhostKeyProfileTab(onImport: openImport),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 写入落在哪张表就切到哪个页签。
  void _showTab(TabController controller, KernelProfileImportTarget target) =>
      controller.animateTo(
        target == KernelProfileImportTarget.ghostKey ? 1 : 0,
      );
}

/// GhostLock 页签：选表 → 确认来源 → 应用。
class _GhostLockTab extends HookConsumerWidget {
  const _GhostLockTab({required this.onImported});

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

    final AsyncValue<DeviceIdentity> identityAsync = ref.watch(
      currentDeviceIdentityProvider,
    );
    final String deviceRelease =
        identityAsync.value?.kernelRelease ?? '';
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
        final GhostLockProfileActions actions = ref.read(
          ghostLockProfileActionsProvider,
        );
        late GhostLockProfileConfig result;
        /* 两组候选互斥由原生保证：选文档会撤掉生效内置表，反之亦然。 */
        if (pickedUser.value.isNotEmpty) {
          result = await actions.selectUserProfile(
            release: deviceRelease,
            name: pickedUser.value,
          );
        } else {
          result = await actions.selectBuiltin(
            release: deviceRelease,
            profileRelease: pickedBuiltin.value,
          );
        }
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
        _Header(
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
            0 => _PickStep(
              deviceRelease: deviceRelease,
              source: source,
              pickedUser: pickedUser,
              pickedBuiltin: pickedBuiltin,
              onImport: openImport,
            ),
            1 => _ReviewStep(
              deviceRelease: deviceRelease,
              pickedUser: pickedUserName,
              pickedBuiltin: pickedBuiltinName,
            ),
            _ => _ApplyStep(
              deviceRelease: deviceRelease,
              pickedUser: pickedUserName,
              pickedBuiltin: pickedBuiltinName,
              applied: applied.value,
            ),
          },
        ),
        _BottomBar(
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
                  onPressed: () => context.push(
                    AppRoute.ghostLockProfilePath(source.user),
                  ),
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

/// 顶部信息区：当前生效来源 + 三步进度。
class _Header extends StatelessWidget {
  const _Header({
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
                    color: reached
                        ? scheme.onPrimary
                        : scheme.onSurfaceVariant,
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

/// 第一步：选一份内核表。两组候选各自独立滚动，不再上下叠在一屏。
class _PickStep extends HookWidget {
  const _PickStep({
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

    Widget row(String release) => _PickRow(
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
                        _PickRow(
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

/// 第二步：只读确认将要生效的是哪份表。
class _ReviewStep extends HookConsumerWidget {
  const _ReviewStep({
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
        _InfoCard(
          rows: <Widget>[
            _InfoRow(
              label: l10n.escalationGhostLockProfileSourceLabel,
              value: sourceText,
            ),
            _InfoRow(
              label: l10n.kernelProfileDeclaredKernel,
              value: declared.isEmpty
                  ? l10n.escalationGhostLockValueUnknown
                  : declared,
              mono: true,
            ),
            _InfoRow(
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

/// 第三步：应用，或已应用后的收尾。
class _ApplyStep extends StatelessWidget {
  const _ApplyStep({
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
        _InfoCard(
          rows: <Widget>[
            _InfoRow(
              label: l10n.escalationGhostLockProfileSourceLabel,
              value: sourceText,
            ),
            _InfoRow(
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

/// 候选行：左侧圆点表示选中，右侧「生效中」表示当前正在使用。
///
/// [leading] 可换成别的图标，用于不可选的只读条目（如参考模板）。
class _PickRow extends StatelessWidget {
  const _PickRow({
    super.key,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.selected = false,
    this.active = false,
    this.leading,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final bool selected;
  final bool active;
  final VoidCallback onTap;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    /* 生效行与选中行都用主题色，靠左侧圆点区分「当前选中」。 */
    final bool highlighted = selected || active;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Material(
        color: selected
            ? scheme.primaryContainer.withValues(alpha: 0.45)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            child: Row(
              children: <Widget>[
                leading ??
                    Icon(
                      selected
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_unchecked_rounded,
                      size: 16.sp,
                      color: selected ? scheme.primary : scheme.onSurfaceVariant,
                    ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppFonts.code,
                          fontSize: 12.sp,
                          fontWeight: highlighted
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: highlighted
                              ? scheme.primary
                              : scheme.onSurface,
                        ),
                      ),
                      if (subtitle != null) ...<Widget>[
                        SizedBox(height: 1.h),
                        Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.5.sp,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 左标签右值的一行。
class _InfoRow extends StatelessWidget {
  const _InfoRow({
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
class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.rows});

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
            ok ? Icons.check_circle_outline_rounded : Icons.error_outline_rounded,
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

/// 底部动作条：只放当前步允许的动作。
class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: scheme.outline.withValues(alpha: 0.2)),
          ),
        ),
        child: Row(
          children: <Widget>[
            for (int i = 0; i < children.length; i++) ...<Widget>[
              if (i > 0) SizedBox(width: 10.w),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}
