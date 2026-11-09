import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/boot_autostart_switch.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/expert_mode_switch.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/run_defaults_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// DirtyFrag 设置组：专家模式 + 开机自启、软重启、VR 反制、自动解析。
///
/// 专家模式关着时，下面四行收起来不占位；打开后展开。
class DirtyFragBootSwitch extends HookConsumerWidget {
  const DirtyFragBootSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<bool> expert = ref.watch(dirtyFragExpertModeProvider);
    final bool expanded = expert.value ?? false;

    return Column(
      children: <Widget>[
        const ExpertModeSwitch(),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: expanded
              ? Column(
                  children: <Widget>[
                    const _RowDivider(),
                    const BootAutostartSwitch(),
                    const _RowDivider(),
                    RunDefaultsSwitch(
                      icon: Icons.power_settings_new_rounded,
                      title: context.l10n.escalationDirtyFragSoftRebootTitle,
                      subtitle: context.l10n.escalationDirtyFragSoftRebootDesc,
                      read: (defaults) => defaults.softReboot,
                      write: (defaults, value) =>
                          defaults.copyWith(softReboot: value),
                    ),
                    const _RowDivider(),
                    RunDefaultsSwitch(
                      icon: Icons.shield_outlined,
                      title: context.l10n.escalationDirtyFragVrDisarmTitle,
                      subtitle: context.l10n.escalationDirtyFragVrDisarmDesc,
                      read: (defaults) => defaults.vrDisarm,
                      write: (defaults, value) =>
                          defaults.copyWith(vrDisarm: value),
                    ),
                    const _RowDivider(),
                    RunDefaultsSwitch(
                      icon: Icons.tune_rounded,
                      title: context.l10n.escalationDirtyFragVrAutoTitle,
                      subtitle: context.l10n.escalationDirtyFragVrAutoDesc,
                      read: (defaults) => defaults.vrAuto,
                      write: (defaults, value) =>
                          defaults.copyWith(vrAuto: value),
                      // 没开 VR 反制时自动解析没有意义，跟着锁死。
                      unlock: (defaults) => defaults.vrDisarm,
                    ),
                  ],
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

/// 行间分隔线，缩进对齐到图标文字区。
class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) =>
      Divider(height: 1, indent: 62.w, endIndent: 16.w);
}
