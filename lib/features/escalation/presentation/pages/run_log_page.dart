import 'package:Aisupass/features/escalation/domain/models/run_log_meta.dart';
import 'package:Aisupass/features/escalation/presentation/providers/run_log_query_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/run_log_detail.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/run_log_list.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 运行日志入口页。`openedFile == null` 是一级列表，非 null 是二级详情。
///
/// 一级 / 二级都拆在 `presentation/widgets/` 下，本页只做路由参数分派。
class RunLogPage extends HookConsumerWidget {
  const RunLogPage({super.key, this.openedFile});

  /// 要打开的日志文件名。null = 列表页。
  final String? openedFile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (openedFile == null) return const RunLogList();
    final AsyncValue<List<RunLogMeta>> async = ref.watch(runLogsProvider);
    final List<RunLogMeta> metas = async.value ?? const <RunLogMeta>[];
    final RunLogMeta? opened = _findByFile(metas, openedFile!);
    if (opened == null) return const RunLogList();
    return RunLogDetail(meta: opened);
  }
}

RunLogMeta? _findByFile(List<RunLogMeta> metas, String fileName) {
  for (final RunLogMeta meta in metas) {
    if (meta.fileName == fileName) return meta;
  }
  return null;
}
