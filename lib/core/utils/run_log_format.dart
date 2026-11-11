import 'package:flutter/material.dart';

import 'package:Aisupass/features/escalation/domain/enums/run_log_result.dart';
import 'package:Aisupass/features/escalation/domain/models/run_log_meta.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

// 运行记录的展示映射：只做「数据 → 可读文本/颜色」的纯映射，不含判定与副作用。
// 颜色函数接收 ColorScheme 而不接收 BuildContext，便于任意层复用。

/// 两位数补零。
String runLogTwo(int value) => value.toString().padLeft(2, '0');

/// `MM-dd HH:mm:ss`。项目未引入 `intl`，手写同格式。
String runLogDateTime(DateTime time) =>
    '${runLogTwo(time.month)}-${runLogTwo(time.day)} '
    '${runLogTwo(time.hour)}:${runLogTwo(time.minute)}:${runLogTwo(time.second)}';

/// 时长展示：`ms <= 0` 回 `—`；否则「N分N秒」或「N秒」。
String runLogDuration(AppLocalizations l10n, int ms) {
  if (ms <= 0) return '—';
  final int totalSeconds = ms ~/ 1000;
  final int minutes = totalSeconds ~/ 60;
  final int seconds = totalSeconds % 60;
  if (minutes <= 0) return l10n.ghostKeyDurationSeconds(seconds);
  return l10n.ghostKeyDurationMinutesSeconds(minutes, seconds);
}

/// 结果状态的可读文案。
String runLogResultLabel(AppLocalizations l10n, RunLogResult result) =>
    switch (result) {
      RunLogResult.running => l10n.ghostKeyRunResultRunning,
      RunLogResult.success => l10n.ghostKeyRunResultSuccess,
      RunLogResult.failed => l10n.ghostKeyRunResultFailed,
      RunLogResult.stopped => l10n.ghostKeyRunResultStopped,
      RunLogResult.interrupted => l10n.ghostKeyRunResultInterrupted,
    };

/// 结果状态色：成功主色 / 失败 error / 其余次要文字。
Color runLogResultColor(ColorScheme scheme, RunLogResult result) =>
    switch (result) {
      RunLogResult.success => scheme.primary,
      RunLogResult.failed => scheme.error,
      _ => scheme.onSurfaceVariant,
    };

/// 正文单行颜色：只对含 `error` / `fail` 的行标红。
Color runLogLineColor(ColorScheme scheme, String line) {
  final String lower = line.toLowerCase();
  if (lower.contains('error') || lower.contains('fail')) {
    return scheme.error;
  }
  return scheme.onSurface;
}

/// 列表行副标题：时长 · 退出码 · 行数。
String runLogSubtitle(AppLocalizations l10n, RunLogMeta meta) {
  final String exit = meta.hasExitCode ? 'exit ${meta.exitCode}' : 'exit --';
  final String lines = meta.hasLineCount
      ? '${meta.lineCount} lines'
      : '-- lines';
  return '${runLogDuration(l10n, meta.durationMs)} · $exit · $lines';
}
