import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/update/domain/models/app_update.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

/// 发现新版本时的提示弹窗。
///
/// [AppUpdate.force] 为 true 时不提供「稍后再说」，点击遮罩也不关闭。
Future<void> showUpdatePromptDialog(
  BuildContext context, {
  required AppUpdate update,
}) => showDialog<void>(
  context: context,
  barrierDismissible: !update.force,
  builder: (BuildContext dialogContext) => _UpdatePromptDialog(update: update),
);

class _UpdatePromptDialog extends HookWidget {
  const _UpdatePromptDialog({required this.update});

  final AppUpdate update;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final String notes = update.notes.trim().isEmpty
        ? l10n.updateNotesFallback
        : update.notes.trim();

    return AlertDialog(
      title: Text(l10n.updateAvailableTitle),
      content: SizedBox(
        width: 320.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              l10n.updateAvailableVersion(update.version),
              style: TextStyle(
                fontSize: 12.5.sp,
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              l10n.updateNotesTitle,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 6.h),
            Flexible(
              child: SingleChildScrollView(
                child: SelectableText(
                  notes,
                  style: TextStyle(
                    fontSize: 12.sp,
                    height: 1.6,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        if (!update.force)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.updateLater),
          ),
        FilledButton(
          onPressed: () async {
            final Uri? uri = Uri.tryParse(update.downloadUrl);
            if (uri != null) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
            if (context.mounted) Navigator.of(context).pop();
          },
          child: Text(l10n.updateNow),
        ),
      ],
    );
  }
}
