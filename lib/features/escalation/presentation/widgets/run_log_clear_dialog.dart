import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// 清空全部运行记录的确认弹窗。
///
/// 返回 `true` 表示确认清空，`null` 表示取消。
Future<bool?> showRunLogClearDialog(BuildContext context) => showDialog<bool>(
  context: context,
  builder: (BuildContext dialogContext) {
    final AppLocalizations l10n = dialogContext.l10n;
    return AlertDialog(
      title: Text(l10n.ghostKeyRunLogClearAll),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(l10n.aiCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(l10n.ghostKeyRunLogClearAll),
        ),
      ],
    );
  },
);
