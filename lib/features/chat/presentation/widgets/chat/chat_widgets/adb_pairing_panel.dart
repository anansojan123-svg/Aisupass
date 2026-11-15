import 'package:Aisupass/common/widgets/adb_pairing_code_input.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/providers/adb_shell_provider.dart';
import 'package:Aisupass/core/providers/system_status_provider.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/chat_widgets/chat_user_action_gate.dart';
import 'package:Aisupass/generated/adb_shell.g.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

/// 对话内的无线调试连接组件，由 `adb_pairing_request` 触发渲染。
///
/// 只负责渲染与按钮动作；挂起、轮询与续跑交给 [ChatUserActionGate]，
/// 判定完成的依据就是这条 shell 连接是否活着。
class AdbPairingPanel extends HookConsumerWidget {
  const AdbPairingPanel({
    super.key,
    required this.turnId,
    required this.isLastTurn,
  });

  /// 所属轮次，挂起判定按轮次精确匹配。
  final String turnId;

  /// 是否为最新一轮；只有最新一轮的面板在未完成时持续轮询。
  final bool isLastTurn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 只有 Android 有无线调试，其他平台整块不渲染。
    if (!isAndroidPlatform) return const SizedBox.shrink();

    final AsyncValue<ShellConnection> link = ref.watch(shellConnectionProvider);
    final ShellPairingState pairing = ref.watch(shellPairingProvider);
    // 卡片输入模式：通知栏弹不出输入框的机型由这里接管输入。
    final bool cardInput = ref.watch(shellPairingModeProvider).isCard;
    // 已点过按钮但还没连上：界面进入等待形态，不再催促。
    final ValueNotifier<bool> suspended = useState<bool>(false);

    final ShellConnection? connection = link.value;
    final bool connected = connection?.connected ?? false;
    final int uid = connection?.uid ?? -1;

    // 连上即解除等待，并让首页 ADB 卡片读到同一份最新开关状态。
    useEffect(() {
      if (!connected) return null;
      suspended.value = false;
      ref.invalidate(adbStatusProvider);
      return null;
    }, <Object?>[connected]);

    return ChatUserActionGate(
      turnId: turnId,
      done: connected,
      pollWhileIncomplete: isLastTurn,
      onPoll: () {
        ref.invalidate(shellConnectionProvider);
        ref.invalidate(adbStatusProvider);
      },
      child: _buildCard(
        context,
        ref,
        link: link,
        pairing: pairing,
        connected: connected,
        uid: uid,
        suspended: suspended,
        cardInput: cardInput,
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    WidgetRef ref, {
    required AsyncValue<ShellConnection> link,
    required ShellPairingState pairing,
    required bool connected,
    required int uid,
    required ValueNotifier<bool> suspended,
    required bool cardInput,
  }) {
    final bool isDesktop = isDesktopPlatform;
    final ColorScheme colors = context.colorScheme;
    final AppLocalizations l10n = context.l10n;

    late final IconData icon;
    late final String statusText;
    late final Color statusColor;
    String? actionLabel;
    IconData actionIcon = Icons.wifi_tethering_rounded;
    VoidCallback? action;

    if (connected) {
      icon = Icons.link_rounded;
      statusText = l10n.shellConnectedUid(uid);
      statusColor = colors.primary;
    } else if (cardInput && pairing.active) {
      // 卡片模式下码已提交：只有阶段可显示，输入框先收起来。
      icon = Icons.sync_rounded;
      statusText = switch (pairing.stage) {
        PairingStage.pairing => l10n.shellPairingPairing,
        PairingStage.connecting => l10n.shellPairingConnecting,
        _ => l10n.shellPairingWaitingCode,
      };
      statusColor = colors.onSurfaceVariant;
    } else if (pairing.failed) {
      icon = Icons.link_off_rounded;
      statusText = l10n.chatAdbPairingFailed;
      statusColor = colors.error;
      // 卡片模式下失败的码已经作废，直接让用户重输，不再给「重试」按钮。
      if (!cardInput) {
        actionLabel = l10n.shellPairingRetry;
        actionIcon = Icons.refresh_rounded;
        action = () => _connect(ref, suspended);
      }
    } else if (suspended.value) {
      // 已跳到系统页：只说明下一步，保留一个恢复入口。
      icon = Icons.pause_circle_outline_rounded;
      statusText = l10n.chatAdbPairingPending;
      statusColor = colors.onSurfaceVariant;
      if (!cardInput) {
        actionLabel = l10n.shellPairingStart;
        action = () => _connect(ref, suspended);
      }
    } else if (!link.hasValue) {
      icon = Icons.link_off_rounded;
      statusText = l10n.statusDetecting;
      statusColor = colors.onSurfaceVariant;
    } else {
      icon = Icons.link_off_rounded;
      statusText = l10n.shellDisconnected;
      statusColor = colors.onSurfaceVariant;
      if (!cardInput) {
        actionLabel = l10n.shellPairingStart;
        action = () => _connect(ref, suspended);
      }
    }

    return Container(
      margin: EdgeInsets.only(
        left: isDesktop ? 8 : 8.w,
        bottom: isDesktop ? 8 : 8.h,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 12 : 12.w,
        vertical: isDesktop ? 10 : 10.h,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(isDesktop ? 10 : 10.r),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.developer_mode_rounded,
                size: isDesktop ? 15 : 15.sp,
                color: colors.onSurfaceVariant,
              ),
              SizedBox(width: isDesktop ? 6 : 6.w),
              Text(
                l10n.chatAdbPanelTitle,
                style: TextStyle(
                  fontSize: isDesktop ? 12 : 12.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: isDesktop ? 8 : 8.h),
          Row(
            children: <Widget>[
              Icon(icon, size: isDesktop ? 15 : 15.sp, color: statusColor),
              SizedBox(width: isDesktop ? 6 : 6.w),
              Expanded(
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: isDesktop ? 12.5 : 12.5.sp,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          // 卡片输入模式且还没开始配对：输入框就是这一步唯一的动作。
          if (cardInput && !connected && !pairing.active) ...<Widget>[
            SizedBox(height: isDesktop ? 8 : 8.h),
            const AdbPairingCodeInput(),
          ] else if (actionLabel != null) ...<Widget>[
            SizedBox(height: isDesktop ? 8 : 8.h),
            SizedBox(
              height: isDesktop ? 36 : 36.h,
              child: OutlinedButton.icon(
                onPressed: action,
                icon: Icon(actionIcon, size: isDesktop ? 15 : 15.sp),
                label: Text(
                  actionLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isDesktop ? 12.5 : 12.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.primary,
                  side: BorderSide(
                    color: colors.primary.withValues(alpha: 0.45),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(isDesktop ? 10 : 12.r),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 发起配对并把用户送到系统「无线调试」页，随即进入等待形态。
  ///
  /// 通知权限不给也照常发起：原生会立刻以失败收尾，好过点了按钮毫无反应。
  /// 跳转失败同样不影响已发起的配对，用户可自行打开设置页。
  Future<void> _connect(WidgetRef ref, ValueNotifier<bool> suspended) async {
    await Permission.notification.request();
    await ref.read(shellPairingProvider.notifier).start();
    suspended.value = true;
    try {
      await ref.read(adbShellNativeProvider).openWirelessDebuggingSettings();
    } catch (_) {
      // 原生未注册或 ROM 拒绝跳转。
    }
  }
}
