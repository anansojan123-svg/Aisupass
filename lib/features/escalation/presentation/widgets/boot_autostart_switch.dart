import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/dirty_frag_setting_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 开机自启开关。仅在专家模式打开时由外层挂载。
class BootAutostartSwitch extends HookConsumerWidget {
  const BootAutostartSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<bool> async = ref.watch(dirtyFragBootAutostartProvider);
    // 落盘后的即时值；null 表示还没点过，用读到的值。
    final ValueNotifier<bool?> local = useState<bool?>(null);

    if (async.hasError) {
      return RefError(
        onRetry: () => ref.invalidate(dirtyFragBootAutostartProvider),
      );
    }

    final bool shown = local.value ?? async.value ?? false;

    Future<void> save(bool enabled) async {
      local.value = enabled;
      try {
        await ref
            .read(dirtyFragActionsProvider)
            .setBootAutostart(enabled: enabled);
      } catch (error) {
        local.value = null;
        ToastMessage.error(error);
      }
    }

    return DirtyFragSettingRow(
      icon: Icons.restart_alt_rounded,
      title: context.l10n.settingsBootAutostartTitle,
      subtitle: context.l10n.settingsBootAutostartDesc,
      value: shown,
      // 只挡「一次都没读到过」的初始态；重载期间照常可点。
      onChanged: async.value == null && local.value == null
          ? null
          : (bool enabled) => _confirmThenSave(context, enabled, save),
    );
  }

  /// 开启前问一次：开机阶段失败会把用户挡在只能刷机的路上。
  Future<void> _confirmThenSave(
    BuildContext context,
    bool enabled,
    Future<void> Function(bool) save,
  ) async {
    if (enabled) {
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
          title: Text(context.l10n.settingsBootAutostartConfirmTitle),
          content: Text(
            context.l10n.settingsBootAutostartConfirmBody,
            style: TextStyle(
              fontSize: 12.sp,
              height: 1.5,
              color: dialogContext.colorScheme.onSurfaceVariant,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(context.l10n.aiCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(context.l10n.settingsBootAutostartConfirmAction),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    await save(enabled);
  }
}
