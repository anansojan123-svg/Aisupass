import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/core/utils/escalation_result_lines.dart';
import 'package:Aisupass/features/escalation/domain/models/device_identity.dart';
import 'package:Aisupass/features/escalation/domain/models/run_log_meta.dart';
import 'package:Aisupass/features/escalation/domain/enums/run_log_result.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/run_log_action_provider.dart';

/// 一轮运行日志的写盘会话。
///
/// 负责「开轮 → 追加 → 收尾」的顺序，以及本轮的累积缓冲；切片与游标在
/// 仓储层。写屏由调用方以 [writeLine] 注入，本类不依赖终端实现。
class RunLogSession {
  RunLogSession({
    required this.ref,
    required this.writeLine,
  });

  final WidgetRef ref;
  final EscalationLineWriter writeLine;

  /// 本轮日志文件名；`null` 表示当前没有在写盘的运行。
  String? _file;

  /// 本侧累积输出：原生每块只给增量，落盘按累积文本切片。
  String _acc = '';

  /// 是否正在写盘。
  bool get active => _file != null;

  /// 开一轮日志。失败不阻断提权。
  Future<void> begin({required String profile}) async {
    try {
      final DeviceIdentity device = await ref.read(
        currentDeviceIdentityProvider.future,
      );
      final RunLogMeta meta = await ref
          .read(runLogActionsProvider)
          .begin(
            device: device.model,
            kernel: device.kernelRelease,
            profile: profile,
          );
      _file = meta.fileName;
      _acc = '';
    } catch (_) {
      _file = null;
    }
  }

  /// 追加本块；终局时落盘并收尾。
  ///
  /// 顺序严格为「写屏 → 落盘 → finish」，不可换。
  Future<void> append({
    required String output,
    required bool isFinal,
    required int exitCode,
    required int durationMs,
    required RunLogResult result,
  }) async {
    final String? fileName = _file;
    if (fileName == null) return;
    _acc += output;
    final String full = _acc;
    final RunLogActions logs = ref.read(runLogActionsProvider);

    try {
      await logs.appendChunk(fileName: fileName, fullText: full);
      if (!isFinal) return;

      await logs.finishChunk(
        fileName: fileName,
        result: result,
        exitCode: exitCode,
        durationMs: durationMs,
      );
    } catch (_) {
      // 静默：日志故障不影响提权结果。
    } finally {
      if (isFinal) {
        _file = null;
        _acc = '';
      }
    }
  }
}
