import 'package:Aisupass/common/widgets/app_setting_icon.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/providers/adb_shell_provider.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 配对码输入位置设置项。
///
/// 通知栏内联回复在部分 ROM（如 MIUI/HyperOS）上点不开，把选择权交给用户，
/// 不按机型做硬判断。
class AppAdbPairingModeSwitch extends HookConsumerWidget {
  const AppAdbPairingModeSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 配对只存在于 Android 的无线调试，其他平台整行不渲染。
    if (!isAndroidPlatform) return const SizedBox.shrink();

    final AppLocalizations l10n = context.l10n;
    final ColorScheme colors = context.colorScheme;
    final ShellPairingInputMode mode = ref.watch(shellPairingModeProvider);

    void select(String value) {
      ref
          .read(shellPairingModeProvider.notifier)
          .setMode(
            value == ShellPairingInputMode.card.name
                ? ShellPairingInputMode.card
                : ShellPairingInputMode.notification,
          );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: <Widget>[
          const AppSettingIcon(icon: Icons.keyboard_alt_outlined),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.settingsShellPairingModeTitle,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  l10n.settingsShellPairingModeDesc,
                  style: TextStyle(
                    fontSize: 11.sp,
                    height: 1.3,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          SegmentedButton<String>(
            segments: <ButtonSegment<String>>[
              ButtonSegment<String>(
                value: ShellPairingInputMode.notification.name,
                label: Text(l10n.shellPairingModeNotification),
              ),
              ButtonSegment<String>(
                value: ShellPairingInputMode.card.name,
                label: Text(l10n.shellPairingModeCard),
              ),
            ],
            selected: <String>{mode.name},
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              textStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
            ),
            onSelectionChanged: (Set<String> selection) =>
                select(selection.first),
          ),
        ],
      ),
    );
  }
}
