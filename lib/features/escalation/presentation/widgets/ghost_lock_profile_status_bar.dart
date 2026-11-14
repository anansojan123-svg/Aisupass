import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_execution_field.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_profile_config.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_profile_field_node.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// 顶部状态条：当前生效来源 + 本地修改条目数。
class GhostLockProfileStatusBar extends StatelessWidget {
  const GhostLockProfileStatusBar({
    super.key,
    required this.config,
    required this.builtin,
    required this.user,
  });

  final GhostLockProfileConfig config;
  final String builtin;
  final String user;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final String source = user.isNotEmpty
        ? '${l10n.escalationGhostLockProfileSourceUser} · $user'
        : builtin.isNotEmpty
        ? '${l10n.escalationGhostLockProfileSourceBuiltin} · $builtin'
        : l10n.escalationGhostLockProfileSourceDevice;
    final int changed = _countOverridden(config);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
      color: scheme.surfaceContainerHighest,
      child: Row(
        children: <Widget>[
          Icon(
            Icons.layers_outlined,
            size: 14.sp,
            color: scheme.onSurfaceVariant,
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              '${l10n.escalationGhostLockProfileSourceLabel}: $source',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11.sp, color: scheme.onSurfaceVariant),
            ),
          ),
          if (changed > 0)
            Text(
              l10n.escalationGhostLockProfileOverriddenCount(changed),
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: scheme.primary,
              ),
            ),
        ],
      ),
    );
  }
}

/// 本地 override 的叶子条目数；分组节点的标记代表子孙，不重复计。
int _countOverridden(GhostLockProfileConfig config) {
  int count = config.general
      .where((GhostLockExecutionField f) => f.overridden)
      .length;
  void walk(List<GhostLockProfileFieldNode> nodes) {
    for (final GhostLockProfileFieldNode node in nodes) {
      if (node.isGroup) {
        walk(node.children);
      } else if (node.overridden) {
        count++;
      }
    }
  }

  walk(config.roots);
  return count;
}
