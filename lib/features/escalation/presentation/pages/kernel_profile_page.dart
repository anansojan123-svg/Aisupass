import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/escalation/domain/enums/kernel_profile_import_target.dart';
import 'package:Aisupass/features/escalation/presentation/pages/tabs/kernel_profile/kernel_profile_ghost_key_tab.dart';
import 'package:Aisupass/features/escalation/presentation/pages/tabs/kernel_profile/kernel_profile_ghost_lock_tab.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_import_panel.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

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
                KernelProfileGhostLockTab(
                  onImported: (KernelProfileImportTarget target) =>
                      _showTab(tabController, target),
                ),
                KernelProfileGhostKeyTab(onImport: openImport),
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
