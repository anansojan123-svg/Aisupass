import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/features/escalation/domain/models/dirty_frag_run_defaults.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/dirty_frag_setting_row.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 运行默认值里的一项开关：成功后软重启 / VR 反制 / 自动解析。
///
/// 三项共用同一份偏好，写入时整体覆盖，所以每次点击都基于当前整体值改一项。
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
    final AsyncValue<DirtyFragRunDefaults> defaults = ref.watch(
      dirtyFragRunDefaultsProvider,
    );

    if (defaults.hasError) {
      return RefError(
        onRetry: () => ref.invalidate(dirtyFragRunDefaultsProvider),
      );
    }

    final DirtyFragRunDefaults? current = defaults.value;
    final bool unlocked =
        current != null &&
        !defaults.isLoading &&
        (unlock?.call(current) ?? true);

    return DirtyFragSettingRow(
      icon: icon,
      title: title,
      subtitle: subtitle,
      value: current != null && read(current),
      onChanged: unlocked && current != null
          ? (bool value) => _save(ref, write(current, value))
          : null,
    );
  }

  /// 写运行参数。四个字段整体覆盖，原生侧 `writeRunDefaults` 是一次 edit。
  Future<void> _save(WidgetRef ref, DirtyFragRunDefaults defaults) async {
    try {
      await ref.read(
        saveDirtyFragRunDefaultsProvider(defaults: defaults).future,
      );
    } catch (error) {
      ToastMessage.error(error);
    }
  }
}
