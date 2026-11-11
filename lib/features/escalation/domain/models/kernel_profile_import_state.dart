import 'package:Aisupass/features/escalation/domain/models/kernel_profile_import_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'kernel_profile_import_state.freezed.dart';

/// 一次导入的进度与终态。
///
/// [result] 是必填非空字段：运行中一律填 [pendingResult]，结束时用
/// `copyWith(result: ...)` 覆盖；不用可空字段表达「尚未结束」。
@freezed
abstract class KernelProfileImportState with _$KernelProfileImportState {
  const KernelProfileImportState._();

  const factory KernelProfileImportState({
    required int phase,
    required int done,
    required int total,
    required KernelProfileImportResult result,
  }) = _KernelProfileImportState;

  /// 运行中的占位结果：`ok == false`、`errorCode == ''`，与「尚未结束」同义。
  static const KernelProfileImportResult pendingResult =
      KernelProfileImportResult(
        ok: false,
        release: '',
        missing: <String>[],
        errorCode: '',
        error: '',
      );

  /// 是否已结束：完成相位（4）或后续更高值。
  bool get finished => phase >= phaseDone;

  /// 是否失败：已结束且 `result.ok == false`。
  bool get failed => finished && !result.ok;

  /// 该相位是否有确定的总量（只有下载相位给出 done/total）。
  bool get determinate => phase == phaseDownload && total > 0;

  /// 各相位在整体进度中的区间，按「定位 5%、下载 75%、解析 15%、写入 5%」分配。
  double get fraction {
    final double inner = total <= 0
        ? 0
        : (done / total).clamp(0, 1).toDouble();
    return switch (phase.clamp(phaseLocate, phaseDone).toInt()) {
      phaseLocate => 0.05 * inner,
      phaseDownload => 0.05 + 0.75 * inner,
      phaseParse => 0.80 + 0.15 * inner,
      phaseSave => 0.95 + 0.05 * inner,
      _ => 1,
    };
  }

  static const int phaseLocate = 0;
  static const int phaseDownload = 1;
  static const int phaseParse = 2;
  static const int phaseSave = 3;
  static const int phaseDone = 4;
}
