import 'package:Aisupass/core/utils/app_version.dart';
import 'package:Aisupass/features/announcement/data/datasources/announcement_query_datasource.dart';
import 'package:Aisupass/features/announcement/domain/models/announcement.dart';
import 'package:Aisupass/features/announcement/presentation/providers/announcement_query_provider.dart';
import 'package:Aisupass/features/announcement/presentation/widgets/announcement_prompt_sheet.dart';
import 'package:Aisupass/features/update/data/datasources/update_query_datasource.dart';
import 'package:Aisupass/features/update/domain/models/app_update.dart';
import 'package:Aisupass/features/update/presentation/controllers/update_check_controller.dart';
import 'package:Aisupass/features/update/presentation/widgets/update_prompt_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 启动编排：先弹公告，用户关闭后再检查更新，避免两个弹层叠在一起。
///
/// 未配置接口、网络失败与内容为空都不打扰用户。
class AppStartupCheck extends HookConsumerWidget {
  const AppStartupCheck({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!context.mounted) return;
        await _showAnnouncement(context, ref);
        if (!context.mounted) return;
        await _checkUpdate(context, ref);
      });
      return null;
    }, const <Object?>[]);

    return const SizedBox.shrink();
  }

  /// 拉取公告并弹层；失败或内容为空时直接跳过。
  Future<void> _showAnnouncement(BuildContext context, WidgetRef ref) async {
    final Announcement announcement;
    try {
      announcement = await ref.read(latestAnnouncementProvider.future);
    } on AnnouncementFetchException {
      return;
    }
    if (!context.mounted || announcement.isBlank) return;
    await showAnnouncementPrompt(context, announcement: announcement);
  }

  /// 静默检查更新；发现新版本才弹窗。
  Future<void> _checkUpdate(BuildContext context, WidgetRef ref) async {
    final PackageInfo info = await AppVersion.load();
    final AppUpdate? latest;
    try {
      latest = await UpdateCheckController(
        ref: ref,
        version: info.version,
        buildNumber: info.buildNumber,
      ).check();
    } on UpdateCheckException {
      return;
    }
    if (!context.mounted || latest == null) return;
    await showUpdatePromptDialog(context, update: latest);
  }
}
