import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_profile_config.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/ghost_lock_profile_field_tree.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/ghost_lock_profile_tab_hint.dart';

/// 高级页：字段树，改动由保存按钮统一提交。
class GhostLockProfileAdvancedTab extends HookConsumerWidget {
  const GhostLockProfileAdvancedTab({
    super.key,
    required this.config,
    required this.draft,
  });

  final GhostLockProfileConfig config;
  final ProfileEditDraft draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: GhostLockProfileTabHint(
            text: context.l10n.escalationGhostLockProfileTabAdvancedHint,
          ),
        ),
        GhostLockProfileFieldTree(
          nodes: config.roots,
          invalidPaths: config.invalidPaths,
          draft: draft,
        ),
      ],
    );
  }
}
