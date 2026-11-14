import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/run_log_format.dart';
import 'package:Aisupass/core/utils/run_log_save.dart';
import 'package:Aisupass/features/escalation/domain/models/run_log_meta.dart';
import 'package:Aisupass/features/escalation/presentation/providers/run_log_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/run_log_query_provider.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 运行记录二级详情：环境信息 + 正文 + 复制 / 另存为 / 删除。
class RunLogDetail extends HookConsumerWidget {
  const RunLogDetail({super.key, required this.meta});

  final RunLogMeta meta;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final AsyncSnapshot<List<String>> body = useFuture(
      useMemoized(
        () => ref.read(runLogBodyProvider(fileName: meta.fileName).future),
        <Object?>[meta.fileName],
      ),
    );

    Future<void> copy() async {
      final List<String> lines = body.data ?? const <String>[];
      await Clipboard.setData(ClipboardData(text: lines.join('\n')));
      if (!context.mounted) return;
      ToastMessage.success(l10n.ghostKeyRunLogCopied);
    }

    Future<void> saveAs() async {
      final List<String> lines = body.data ?? const <String>[];
      if (!context.mounted) return;
      try {
        final bool saved = await saveRunLogToFile(
          text: lines.join('\n'),
          fileName: meta.fileName,
          dialogTitle: l10n.ghostKeyRunLogSaveAs,
        );
        if (saved && context.mounted) {
          ToastMessage.success(l10n.ghostKeyRunLogSaved);
        }
      } catch (error) {
        ToastMessage.error(error);
      }
    }

    Future<void> deleteThis() async {
      try {
        await ref.read(runLogActionsProvider).delete(meta);
      } catch (error) {
        ToastMessage.error(error);
        return;
      }
      if (!context.mounted) return;
      context.pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ghostKeyRunLogDetailTitle(meta.runId)),
        actions: <Widget>[
          TextButton(
            onPressed: body.hasData ? copy : null,
            child: Text(l10n.ghostKeyRunLogCopy),
          ),
          TextButton(
            onPressed: body.hasData ? saveAs : null,
            child: Text(l10n.ghostKeyRunLogSaveAs),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${runLogResultLabel(l10n, meta.result)}'
                  ' · ${runLogDuration(l10n, meta.durationMs)}'
                  ' · ${meta.hasExitCode ? "exit ${meta.exitCode}" : "exit --"}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: runLogResultColor(scheme, meta.result),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${meta.device} · ${meta.kernel}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: scheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'profile: ${meta.profile.isEmpty ? "-" : meta.profile}'
                  ' · ${runLogDateTime(meta.startedAtTime)}'
                  ' · ${meta.hasLineCount ? "${meta.lineCount} lines" : "--"}',
                  style: TextStyle(fontSize: 11.sp, color: scheme.outline),
                ),
              ],
            ),
          ),
          Divider(height: 1, indent: 16.w, endIndent: 16.w),
          Expanded(
            child: _Body(
              body: body,
              onRetry: () =>
                  ref.invalidate(runLogBodyProvider(fileName: meta.fileName)),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 12.h),
              child: TextButton(
                onPressed: deleteThis,
                child: Text(
                  l10n.ghostKeyRunLogDeleteThis,
                  style: TextStyle(fontSize: 13.sp, color: scheme.error),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 正文三态：等待 / 出错 / 有内容。
class _Body extends HookWidget {
  const _Body({required this.body, required this.onRetry});

  final AsyncSnapshot<List<String>> body;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (body.hasError) return RefError(onRetry: onRetry);
    if (body.connectionState == ConnectionState.waiting) return const Loading();
    final List<String> lines = body.data ?? const <String>[];
    final ColorScheme scheme = context.colorScheme;
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
      itemCount: lines.length,
      itemBuilder: (BuildContext context, int index) {
        final String line = lines[index];
        return Text(
          line,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 11.sp,
            height: 16 / 11,
            color: runLogLineColor(scheme, line),
          ),
        );
      },
    );
  }
}
