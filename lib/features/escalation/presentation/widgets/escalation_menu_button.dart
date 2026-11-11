import 'dart:async';

import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/terminal_key_bar.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xterm3/xterm.dart';

/// 底栏最左侧的三点菜单键。
///
/// 外观与功能键同属一套键帽（[TerminalIconKey]），位置由按键栏固定在最左，
/// 不随功能键横向滚动。菜单项由本组件持有，点击后回调对应的 `on*`。
class EscalationMenuButton extends HookWidget {
  const EscalationMenuButton({
    super.key,
    required this.onExploit,
    required this.onDirtyFrag,
    required this.onGhostKey,
    required this.onHandoff,
    required this.onPayloadCatalog,
    required this.onClear,
  });

  /// 用户选择「提权」。
  final VoidCallback onExploit;

  /// 用户选择「DirtyFrag 提权」。
  final VoidCallback onDirtyFrag;

  /// 用户选择「GhostKey 提权」。
  final VoidCallback onGhostKey;

  /// 用户选择「移交给当前管理器」。
  final VoidCallback onHandoff;

  /// 用户选择「查看载荷清单」。
  final VoidCallback onPayloadCatalog;

  /// 用户选择「清屏」。
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;

    // 菜单键在底栏里，位置由布局决定，弹出锚点要自己按按钮的实际位置算。
    final GlobalKey anchorKey = useMemoized(GlobalKey.new, const <Object?>[]);

    Future<void> openMenu() async {
      final RenderObject? anchor = anchorKey.currentContext?.findRenderObject();
      final RenderObject? overlay = Overlay.maybeOf(
        context,
      )?.context.findRenderObject();
      if (anchor is! RenderBox || overlay is! RenderBox) return;

      final Rect anchorRect = Rect.fromPoints(
        anchor.localToGlobal(Offset.zero, ancestor: overlay),
        anchor.localToGlobal(
          anchor.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      );

      final _MenuAction? action = await showGeneralDialog<_MenuAction>(
        context: context,
        barrierDismissible: true,
        barrierLabel: l10n.escalationMenuTitle,
        barrierColor: const Color(0x59000000),
        transitionDuration: const Duration(milliseconds: 120),
        pageBuilder:
            (BuildContext _, Animation<double> _, Animation<double> _) =>
                _TerminalMenuPanel(
                  anchorTop: anchorRect.top,
                  entries: _menuEntries(l10n),
                ),
        transitionBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) => FadeTransition(opacity: animation, child: child),
      );
      // 菜单要等用户选完才回来，期间页面可能已经被销毁。
      if (action == null || !context.mounted) return;
      switch (action) {
        case _MenuAction.exploit:
          onExploit();
        case _MenuAction.dirtyFrag:
          onDirtyFrag();
        case _MenuAction.ghostKey:
          onGhostKey();
        case _MenuAction.handoff:
          onHandoff();
        case _MenuAction.payloadCatalog:
          onPayloadCatalog();
        case _MenuAction.clear:
          onClear();
      }
    }

    return Tooltip(
      message: l10n.escalationMenuTitle,
      excludeFromSemantics: true,
      child: TerminalIconKey(
        key: anchorKey,
        semanticLabel: l10n.escalationMenuTitle,
        onTap: () => unawaited(openMenu()),
        // 图标是白色填充，换成键帽前景色，和文字键一个调子。
        icon: SvgPicture.asset(
          kMoreVertIconAsset,
          width: 18.r,
          height: 18.r,
          colorFilter: const ColorFilter.mode(
            TerminalKeyBar.keyForeground,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

/// 菜单项。只在本文件内流转，不对外暴露。
enum _MenuAction { exploit, dirtyFrag, ghostKey, handoff, payloadCatalog, clear }

/// 一条菜单项；[action] 为空时是分组分隔线。
class _MenuEntry {
  const _MenuEntry(this.action, this.icon, this.label);

  const _MenuEntry.separator() : action = null, icon = null, label = '';

  final _MenuAction? action;
  final IconData? icon;
  final String label;

  bool get separator => action == null;
}

List<_MenuEntry> _menuEntries(AppLocalizations l10n) => <_MenuEntry>[
  _MenuEntry(
    _MenuAction.exploit,
    Icons.security_rounded,
    l10n.escalationExploitButton,
  ),
  _MenuEntry(
    _MenuAction.dirtyFrag,
    Icons.memory_rounded,
    l10n.escalationDirtyFragTitle,
  ),
  _MenuEntry(
    _MenuAction.ghostKey,
    Icons.vpn_key_rounded,
    l10n.escalationGhostKeyTitle,
  ),
  const _MenuEntry.separator(),
  _MenuEntry(
    _MenuAction.handoff,
    Icons.verified_user_rounded,
    l10n.escalationHandoffCurrent,
  ),
  const _MenuEntry.separator(),
  _MenuEntry(
    _MenuAction.payloadCatalog,
    Icons.inventory_2_outlined,
    l10n.escalationMenuPayloadCatalog,
  ),
  _MenuEntry(
    _MenuAction.clear,
    Icons.cleaning_services_rounded,
    l10n.escalationMenuClear,
  ),
];

/// 浮在按键栏上方的操作面板：纵向排列的操作行，配色沿用终端画布。
///
/// 每行标题超宽时在本行内横向滚动，不换行也不截断；整列超出可用高度时
/// 面板自身纵向滚动。
class _TerminalMenuPanel extends StatelessWidget {
  const _TerminalMenuPanel({required this.anchorTop, required this.entries});

  /// 菜单键顶边在覆盖层坐标系里的位置；面板底部以它为基准。
  final double anchorTop;

  final List<_MenuEntry> entries;

  /// 面板与菜单键之间的间隙。
  static const double _gap = 8;

  /// 面板圆角。
  static const double _radius = 10;

  /// 面板与屏幕左右边缘的间距。
  static const double _horizontalInset = 10;

  /// 面板顶端留白，避免顶到状态栏。
  static const double _topInset = 24;

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.sizeOf(context);
    // 面板底边固定在菜单键上方，剩余空间才是它的最大高度。
    final double bottom = screen.height - anchorTop + _gap.h;
    final double maxHeight = (screen.height - bottom - _topInset).clamp(
      120.0,
      screen.height,
    );

    final List<Widget> rows = <Widget>[];
    for (final _MenuEntry entry in entries) {
      rows.add(entry.separator ? _separator() : _row(context, entry));
    }

    return Stack(
      children: <Widget>[
        Positioned(
          left: _horizontalInset.w,
          right: _horizontalInset.w,
          bottom: bottom,
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: BoxConstraints(maxHeight: maxHeight),
              decoration: BoxDecoration(
                color: TerminalThemes.defaultTheme.background,
                borderRadius: BorderRadius.circular(_radius.r),
                border: Border.all(color: TerminalKeyBar.keyBorder),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x66000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: rows,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 分组分隔线。
  Widget _separator() => Padding(
    padding: EdgeInsets.symmetric(vertical: 4.h),
    child: const Divider(
      height: 1,
      thickness: 1,
      color: TerminalKeyBar.keyBorder,
    ),
  );

  /// 一项操作：图标 + 等宽文字，外观与底栏键帽一致。
  Widget _row(BuildContext context, _MenuEntry entry) {
    final BorderRadius radius = BorderRadius.circular(8.r);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Material(
        color: TerminalKeyBar.keyColor,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: () => Navigator.of(context).pop(entry.action),
          child: Container(
            height: 38.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(color: TerminalKeyBar.keyBorder),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  entry.icon,
                  size: 14.r,
                  color: TerminalKeyBar.keyForeground,
                ),
                SizedBox(width: 8.w),
                // 标题只占一行，超出时在本行内横向滚动。
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      entry.label,
                      maxLines: 1,
                      softWrap: false,
                      style: TextStyle(
                        fontFamily: AppFonts.code,
                        fontSize: 11.sp,
                        height: 1,
                        letterSpacing: 0.2,
                        fontWeight: FontWeight.w600,
                        color: TerminalKeyBar.keyForeground,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
