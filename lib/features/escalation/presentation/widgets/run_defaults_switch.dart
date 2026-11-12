import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/features/escalation/domain/models/dirty_frag_run_defaults.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/dirty_frag_setting_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 运行默认值里的一项开关：成功后软重启 / VR 反制 / 自动解析。
///
/// 三项共用同一份偏好，写入时整体覆盖。渲染用本地值，点击先翻界面再落盘。
/// 仅在专家模式打开时由外层挂载。
class RunDefaultsSwitch extends HookConsumerWidget {
  const RunDefaultsSwitch({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.read,
    required this.write,
    this.unlock,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  /// 取本项在当前整体值里的开关态。
  final bool Function(DirtyFragRunDefaults) read;

  /// 把本项的新值写回整体值。
  final DirtyFragRunDefaults Function(DirtyFragRunDefaults, bool) write;

  /// 本项在自己的值之外的放行条件，为空表示无附加条件。
  final bool Function(DirtyFragRunDefaults)? unlock;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<DirtyFragRunDefaults> async = ref.watch(
      dirtyFragRunDefaultsProvider,
    );
    // 落盘后的即时值；null 表示还没点过，用读到的值。
    final ValueNotifier<DirtyFragRunDefaults?> local =
        useState<DirtyFragRunDefaults?>(null);

    if (async.hasError) {
      return RefError(
        onRetry: () => ref.invalidate(dirtyFragRunDefaultsProvider),
      );
    }

    final DirtyFragRunDefaults? loaded = async.value;
    final DirtyFragRunDefaults? shown = local.value ?? loaded;
    final bool unlocked = shown != null && (unlock?.call(shown) ?? true);

    Future<void> save(DirtyFragRunDefaults next) async {
      // 先翻界面：等 provider 重载再翻，会有一帧回跳。
      local.value = next;
      try {
        await ref.read(dirtyFragActionsProvider).saveRunDefaults(next);
      } catch (error) {
        local.value = null;
        ToastMessage.error(error);
      }
    }

    return DirtyFragSettingRow(
      icon: icon,
      title: title,
      subtitle: subtitle,
      value: shown != null && read(shown),
      onChanged: unlocked
          ? (bool value) => save(write(shown, value))
          : null,
    );
  }
}
