import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_profile_config.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/ghost_lock_profile_tab_hint.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// 路由页：route 与 fallback 的选择，空串表示交还给 profile 声明。
class GhostLockProfileRouteTab extends HookConsumerWidget {
  const GhostLockProfileRouteTab({
    super.key,
    required this.config,
    required this.onUpdated,
  });

  final GhostLockProfileConfig config;
  final ValueChanged<GhostLockProfileConfig> onUpdated;

  /// 与 native `kRouteCatalog` 对齐的三条路由。
  static const List<String> _routes = <String>[
    'select_stack',
    'tcp_zerocopy',
    'multicast_waiter',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;

    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      children: <Widget>[
        GhostLockProfileTabHint(
          text: l10n.escalationGhostLockProfileTabRouteHint,
        ),
        /* 合并后的实际值；chip 只是 override 意图，这里才是要跑的那条。 */
        Text(
          '${l10n.escalationGhostLockProfileRouteCurrent}: '
          '${config.route.isEmpty ? l10n.escalationGhostLockProfileRouteAuto : config.route}'
          ' / ${config.fallbackTo.isEmpty ? l10n.escalationGhostLockProfileFallbackDeclared : config.fallbackTo}',
          style: TextStyle(
            fontFamily: AppFonts.code,
            fontSize: 11.sp,
            color: scheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          l10n.escalationGhostLockProfileRouteLabel,
          style: TextStyle(
            fontFamily: AppFonts.code,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: scheme.onSurface,
          ),
        ),
        SizedBox(height: 6.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 6.h,
          children: <Widget>[
            _chip(
              label: l10n.escalationGhostLockProfileRouteAuto,
              selected: config.route.isEmpty,
              onTap: () => _setRoute(ref, ''),
            ),
            for (final String route in _routes)
              _chip(
                label: route,
                selected: config.route == route,
                onTap: () => _setRoute(ref, route),
              ),
          ],
        ),
        SizedBox(height: 8.h),
        /* 切到表里没生成过的路由时，几何字段是 null，说清楚而不是让用户自己踩。 */
        GhostLockProfileTabHint(
          text: l10n.escalationGhostLockProfileRouteGeometryHint,
        ),
        SizedBox(height: 18.h),
        Text(
          l10n.escalationGhostLockProfileFallbackLabel,
          style: TextStyle(
            fontFamily: AppFonts.code,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: scheme.onSurface,
          ),
        ),
        SizedBox(height: 6.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 6.h,
          children: <Widget>[
            _chip(
              label: l10n.escalationGhostLockProfileFallbackDeclared,
              selected: config.fallbackTo.isEmpty,
              onTap: () => _setFallback(ref, ''),
            ),
            _chip(
              label: l10n.escalationGhostLockProfileFallbackNone,
              selected: config.fallbackTo == 'none',
              onTap: () => _setFallback(ref, 'none'),
            ),
            for (final String route in _routes)
              _chip(
                label: route,
                selected: config.fallbackTo == route,
                onTap: () => _setFallback(ref, route),
              ),
          ],
        ),
      ],
    );
  }

  Widget _chip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) => ChoiceChip(
    label: Text(label, style: TextStyle(fontSize: 12.sp)),
    selected: selected,
    onSelected: (bool _) => onTap(),
  );

  Future<void> _setRoute(WidgetRef ref, String route) async {
    try {
      final GhostLockProfileConfig next = await ref
          .read(ghostLockProfileActionsProvider)
          .updateRoute(release: config.release, route: route);
      onUpdated(next);
    } catch (error) {
      ToastMessage.error(error);
    }
  }

  Future<void> _setFallback(WidgetRef ref, String fallbackTo) async {
    try {
      final GhostLockProfileConfig next = await ref
          .read(ghostLockProfileActionsProvider)
          .updateFallback(release: config.release, fallbackTo: fallbackTo);
      onUpdated(next);
    } catch (error) {
      ToastMessage.error(error);
    }
  }
}
