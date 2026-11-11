import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/dirty_frag_setting_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 专家模式开关：DirtyFrag 功能的入口开关。
///
/// 关闭时外层的其余设置项会收起，只保留这一行。
class ExpertModeSwitch extends HookConsumerWidget {
  const ExpertModeSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<bool> async = ref.watch(dirtyFragExpertModeProvider);
    // 落盘后的即时值；null 表示还没点过，用读到的值。
    final ValueNotifier<bool?> local = useState<bool?>(null);

    if (async.hasError) {
      return RefError(
        onRetry: () => ref.invalidate(dirtyFragExpertModeProvider),
      );
    }

    final bool shown = local.value ?? async.value ?? false;

    Future<void> save(bool enabled) async {
      local.value = enabled;
      try {
        await ref
            .read(dirtyFragActionsProvider)
            .setExpertMode(enabled: enabled);
      } catch (error) {
        local.value = null;
        ToastMessage.error(error);
      }
    }

    return DirtyFragSettingRow(
      icon: Icons.build_circle_outlined,
      title: context.l10n.settingsExpertModeTitle,
      subtitle: context.l10n.settingsExpertModeDesc,
      value: shown,
      // 只挡「一次都没读到过」的初始态；重载期间照常可点。
      onChanged: async.value == null && local.value == null ? null : save,
    );
  }
}
