import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/dirty_frag_setting_row.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 专家模式开关：DirtyFrag 功能的入口开关。
///
/// 关闭时外层的其余设置项会收起，只保留这一行。
class ExpertModeSwitch extends HookConsumerWidget {
  const ExpertModeSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<bool> expert = ref.watch(dirtyFragExpertModeProvider);
    if (expert.hasError) {
      return RefError(
        onRetry: () => ref.invalidate(dirtyFragExpertModeProvider),
      );
    }

    return DirtyFragSettingRow(
      icon: Icons.build_circle_outlined,
      title: context.l10n.settingsExpertModeTitle,
      subtitle: context.l10n.settingsExpertModeDesc,
      value: expert.value ?? false,
      // 读取中不给点，避免拿旧值覆盖真实状态。
      onChanged: expert.isLoading ? null : (bool value) => _toggle(ref, value),
    );
  }

  Future<void> _toggle(WidgetRef ref, bool enabled) async {
    try {
      await ref.read(setDirtyFragExpertModeProvider(enabled: enabled).future);
    } catch (error) {
      ToastMessage.error(error);
    }
  }
}
