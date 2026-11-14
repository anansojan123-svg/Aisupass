import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_profile_config.dart';
import 'package:Aisupass/features/escalation/presentation/pages/tabs/ghost_lock_profile/ghost_lock_profile_advanced_tab.dart';
import 'package:Aisupass/features/escalation/presentation/pages/tabs/ghost_lock_profile/ghost_lock_profile_general_tab.dart';
import 'package:Aisupass/features/escalation/presentation/pages/tabs/ghost_lock_profile/ghost_lock_profile_route_tab.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/ghost_lock_profile_field_tree.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// 三个页签的骨架；违规字段在「高级」页签上挂红点。
class GhostLockProfileTabs extends HookWidget {
  const GhostLockProfileTabs({
    super.key,
    required this.config,
    required this.draft,
    required this.onUpdated,
  });

  final GhostLockProfileConfig config;
  final ProfileEditDraft draft;

  /// 每个写操作返回的新配置都回灌到页面，UI 不依赖 provider 失效刷新。
  final ValueChanged<GhostLockProfileConfig> onUpdated;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final bool hasInvalid = config.invalidPaths.isNotEmpty;
    /* 用 Hook 持有 controller：配置刷新时不能把页签弹回第一个。 */
    final TabController tabController = useTabController(initialLength: 3);

    return Column(
      children: <Widget>[
        TabBar(
          controller: tabController,
          tabs: <Widget>[
            Tab(text: l10n.escalationGhostLockProfileTabGeneral),
            Tab(text: l10n.escalationGhostLockProfileTabRoute),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(l10n.escalationGhostLockProfileTabAdvanced),
                  if (hasInvalid) ...<Widget>[
                    SizedBox(width: 4.w),
                    Icon(Icons.circle, size: 6.sp, color: scheme.error),
                  ],
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: <Widget>[
              GhostLockProfileGeneralTab(general: config.general, draft: draft),
              GhostLockProfileRouteTab(config: config, onUpdated: onUpdated),
              GhostLockProfileAdvancedTab(config: config, draft: draft),
            ],
          ),
        ),
      ],
    );
  }
}
