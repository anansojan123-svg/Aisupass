import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/escalation/domain/models/run_log_meta.dart';
import 'package:Aisupass/features/escalation/presentation/providers/run_log_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/run_log_query_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/run_log_clear_dialog.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/run_log_row.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/run_log_save.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 运行记录一级列表：条数提示 + 列表 + 导出全部 + 清空全部。
class RunLogList extends HookConsumerWidget {
  const RunLogList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final AsyncValue<List<RunLogMeta>> async = ref.watch(runLogsProvider);
    final List<RunLogMeta> metas = async.value ?? const <RunLogMeta>[];

    Future<void> exportAll() async {
      final String text;
      try {
        text = await ref.read(exportAllRunLogsProvider.future);
      } catch (error) {
        ToastMessage.error(error);
        return;
      }
      if (!context.mounted) return;
      try {
        await saveRunLogAs(
          context,
          l10n,
          text,
          l10n.ghostKeyRunLogExportAllFileName,
        );
      } catch (error) {
        ToastMessage.error(error);
      }
    }

    Future<void> askClearAll() async {
      final bool? confirmed = await showRunLogClearDialog(context);
      if (confirmed != true) return;
      try {
        await ref.read(runLogActionsProvider).clear();
      } catch (error) {
        ToastMessage.error(error);
        return;
      }
      if (!context.mounted) return;
      ToastMessage.success(l10n.ghostKeyRunLogCleared);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ghostKeyRunLogTitle),
        actions: <Widget>[
          TextButton(
            onPressed: metas.isEmpty ? null : exportAll,
            child: Text(l10n.ghostKeyRunLogExportAll),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Loading(),
        error: (Object error, StackTrace stackTrace) => RefError(
          onRetry: () => ref.invalidate(runLogsProvider),
        ),
        data: (List<RunLogMeta> list) {
          if (list.isEmpty) {
            return Center(
              child: Text(
                l10n.ghostKeyRunLogEmpty,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            itemCount: list.length + 1,
            separatorBuilder: (BuildContext context, int index) =>
                Divider(height: 1, indent: 16.w, endIndent: 16.w),
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 10.h),
                  child: Text(
                    l10n.ghostKeyRunLogCount(list.length),
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                );
              }
              return RunLogRow(meta: list[index - 1]);
            },
          );
        },
      ),
      bottomNavigationBar: metas.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 12.h),
                child: TextButton(
                  onPressed: askClearAll,
                  child: Text(
                    l10n.ghostKeyRunLogClearAll,
                    style: TextStyle(fontSize: 13.sp, color: scheme.error),
                  ),
                ),
              ),
            ),
    );
  }
}
