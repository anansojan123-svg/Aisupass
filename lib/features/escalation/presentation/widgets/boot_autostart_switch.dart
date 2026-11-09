import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/dirty_frag_setting_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 开机自启开关。仅在专家模式打开时由外层挂载。
class BootAutostartSwitch extends HookConsumerWidget {
  const BootAutostartSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<bool> boot = ref.watch(dirtyFragBootAutostartProvider);

    if (boot.hasError) {
      return RefError(
        onRetry: () => ref.invalidate(dirtyFragBootAutostartProvider),
      );
    }

    return DirtyFragSettingRow(
      icon: Icons.restart_alt_rounded,
      title: context.l10n.settingsBootAutostartTitle,
      subtitle: context.l10n.settingsBootAutostartDesc,
      value: boot.value ?? false,
      // 读取中不给点，避免拿旧值覆盖真实状态。
      onChanged: boot.isLoading
          ? null
          : (bool value) => _toggle(context, ref, value),
    );
  }

  /// 开启前问一次：开机阶段失败会把用户挡在只能刷机的路上。
  Future<void> _toggle(
    BuildContext context,
    WidgetRef ref,
    bool enabled,
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
      if (confirmed != true || !context.mounted) return;
    }

    try {
      await ref.read(
        setDirtyFragBootAutostartProvider(enabled: enabled).future,
      );
    } catch (error) {
      ToastMessage.error(error);
    }
  }
}
