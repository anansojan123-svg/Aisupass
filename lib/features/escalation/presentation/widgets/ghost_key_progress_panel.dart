import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/core/utils/ghost_key_text.dart';
import 'package:Aisupass/features/escalation/domain/enums/ghost_key_stage.dart';
import 'package:Aisupass/features/escalation/domain/enums/ghost_key_stage_status.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_outcome.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/terminal_key_bar.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xterm3/xterm.dart';

/// 终端下方的五阶段进度面板。
///
/// 配色与字形全部取终端那一套：底色是画布色，文字用等宽字体与终端前景色，
/// 状态色取 xterm 主题里的红 / 绿 / 黄，看起来是终端的一部分而不是另一块控件。
///
/// 数据全部来自 [GhostKeyOutcome] 的 `fraction` / `stageStatuses` /
/// `stageDurations`。面板不持有状态机：阶段状态由仓储实现的 `_StageTracker`
/// 决定，这里只渲染。
class GhostKeyProgressPanel extends HookWidget {
  const GhostKeyProgressPanel({super.key, required this.outcome});

  final GhostKeyOutcome outcome;

  /// 栏顶分隔线，与按键栏同一档。
  static const Color hairline = TerminalKeyBar.hairline;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final TerminalTheme theme = TerminalThemes.defaultTheme;
    final int percent = (outcome.fraction * 100).round();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.background,
        border: const Border(top: BorderSide(color: hairline)),
      ),
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 10.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  l10n.escalationGhostKeyProgressTitle,
                  style: _mono(11, theme.brightBlack),
                ),
              ),
              Text('$percent%', style: _mono(11, theme.foreground)),
            ],
          ),
          SizedBox(height: 5.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(2.r),
            child: LinearProgressIndicator(
              value: outcome.fraction,
              minHeight: 3.h,
              backgroundColor: TerminalKeyBar.keyColor,
              valueColor: AlwaysStoppedAnimation<Color>(theme.green),
            ),
          ),
          SizedBox(height: 8.h),
          for (final GhostKeyStage stage in GhostKeyStage.values)
            _StageRow(
              name: ghostKeyStageName(l10n, stage),
              hint: ghostKeyStageHint(l10n, stage),
              status: outcome.stageStatuses[stage.index],
              durationMs: outcome.stageDurations[stage.index],
            ),
        ],
      ),
    );
  }
}

/// 面板统一用终端等宽字体，行高压到 1 与前后的终端输出对齐。
TextStyle _mono(double size, Color color) => TextStyle(
  fontFamily: AppFonts.code,
  fontSize: size.sp,
  height: 1.2,
  color: color,
);

/// 一行：状态字形 + 阶段名 + 提示 + 耗时。
class _StageRow extends HookWidget {
  const _StageRow({
    required this.name,
    required this.hint,
    required this.status,
    required this.durationMs,
  });

  final String name;
  final String hint;
  final GhostKeyStageStatus status;
  final int durationMs;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final TerminalTheme theme = TerminalThemes.defaultTheme;
    final Color color = _statusColor(theme, status);
    final String duration = durationMs <= 0
        ? ''
        : l10n.escalationGhostKeyDurationSeconds(
            (durationMs / 1000).toStringAsFixed(1),
          );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 12.w,
            child: Text(_statusGlyph(status), style: _mono(11, color)),
          ),
          SizedBox(width: 4.w),
          SizedBox(
            width: 92.w,
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _mono(11, theme.foreground),
            ),
          ),
          Expanded(
            child: Text(
              status == GhostKeyStageStatus.running ? hint : '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _mono(10, theme.brightBlack),
            ),
          ),
          Text(duration, style: _mono(10, theme.brightBlack)),
        ],
      ),
    );
  }

  /// 单字符状态标记，宽度固定，行与行才对得齐。
  String _statusGlyph(GhostKeyStageStatus status) => switch (status) {
    GhostKeyStageStatus.pending => '·',
    GhostKeyStageStatus.running => '▸',
    GhostKeyStageStatus.success => '✓',
    GhostKeyStageStatus.degraded => '!',
    GhostKeyStageStatus.failed => '✗',
    GhostKeyStageStatus.skipped => '–',
  };

  Color _statusColor(TerminalTheme theme, GhostKeyStageStatus status) =>
      switch (status) {
        GhostKeyStageStatus.pending ||
        GhostKeyStageStatus.skipped => theme.brightBlack,
        GhostKeyStageStatus.running => theme.yellow,
        GhostKeyStageStatus.success => theme.green,
        GhostKeyStageStatus.degraded => theme.yellow,
        GhostKeyStageStatus.failed => theme.red,
      };
}
