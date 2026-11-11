import 'package:flutter/material.dart';

import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// 删除一份已导入 profile 的确认弹窗。
///
/// 返回 `true` 表示确认删除，`null` 表示取消。
Future<bool?> showKernelProfileRemoveDialog(
  BuildContext context, {
  required KernelProfile profile,
}) => showDialog<bool>(
  context: context,
  builder: (BuildContext dialogContext) {
    final AppLocalizations l10n = dialogContext.l10n;
    return AlertDialog(
      title: Text(l10n.kernelProfileRemoveConfirmTitle),
      content: Text(l10n.kernelProfileRemoveConfirmBody(profile.release)),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(l10n.aiCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(l10n.kernelProfileRemove),
        ),
      ],
    );
  },
);
