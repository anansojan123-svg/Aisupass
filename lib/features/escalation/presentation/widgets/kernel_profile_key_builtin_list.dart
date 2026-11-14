import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile.dart';
import 'package:Aisupass/features/escalation/presentation/providers/kernel_profile_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_empty_hint.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_pick_row.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_row_card.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// GhostKey 内置表清单：搜索固定在顶部，清单在下方独立滚动，点行即生效。
///
/// 选中态与生效态都按 release 比对，与 GhostLock 的选表一致。
class KernelProfileKeyBuiltinList extends HookWidget {
  const KernelProfileKeyBuiltinList({
    super.key,
    required this.profiles,
    required this.deviceRelease,
    required this.activeBuiltin,
  });

  final List<KernelProfile> profiles;
  final String deviceRelease;

  /// 当前生效的内置表 release；空串表示未指定。
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

/// 内置表单选行：选中即生效，release 与本机不一致时在副标题里写明。
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
