import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_run_defaults.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/dirty_frag_setting_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// GhostKey 设置组：两个跨运行持久开关。
///
/// 渲染用本地值，点击先翻界面再落盘：等 provider 重载再翻，会有一帧回跳。
class GhostKeySettingSection extends HookConsumerWidget {
  const GhostKeySettingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<GhostKeyRunDefaults> async = ref.watch(
      ghostKeyRunDefaultsProvider,
    );
    // 落盘后的即时值；null 表示还没点过，用读到的值。
    final ValueNotifier<GhostKeyRunDefaults?> local =
        useState<GhostKeyRunDefaults?>(null);

    if (async.hasError) {
      return RefError(
        onRetry: () => ref.invalidate(ghostKeyRunDefaultsProvider),
      );
    }
    if (async.isLoading && !async.hasValue) {
      return const Loading();
    }

    final GhostKeyRunDefaults shown = local.value ?? async.requireValue;

    Future<void> save(GhostKeyRunDefaults next) async {
      // 先翻界面：等 provider 重载再翻，会有一帧回跳。
      local.value = next;
      try {
        await ref.read(ghostKeyActionsProvider).saveRunDefaults(next);
      } catch (error) {
        local.value = null;
        ToastMessage.error(error);
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DirtyFragSettingRow(
          icon: Icons.gavel_rounded,
          title: context.l10n.settingsGhostKeyRunKsuTitle,
          subtitle: context.l10n.settingsGhostKeyRunKsuDesc,
          value: shown.runKsu,
          onChanged: (bool value) =>
              save(shown.copyWith(runKsu: value)),
        ),
        const _RowDivider(),
        DirtyFragSettingRow(
          icon: Icons.tune_rounded,
          title: context.l10n.settingsGhostKeyAcceptFallbackTitle,
          subtitle: context.l10n.settingsGhostKeyAcceptFallbackDesc,
          value: shown.acceptFallbackPageOffset,
          onChanged: (bool value) =>
              save(shown.copyWith(acceptFallbackPageOffset: value)),
        ),
      ],
    );
  }
}

/// 组内分隔线。
class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) => Divider(
    height: 1,
    indent: 62.w,
    endIndent: 16.w,
    color: context.colorScheme.outlineVariant.withValues(alpha: 0.5),
  );
}
