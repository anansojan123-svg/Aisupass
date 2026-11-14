import 'package:freezed_annotation/freezed_annotation.dart';

part 'ghost_lock_probe.freezed.dart';

/// 一次内核表解析结果，尚未落盘。
///
/// [conf] 是自包含的 GLK profile 全文，由 UI 暂存；用户选定落点后原样回传给
/// 落盘接口，避免二次提取。
@freezed
abstract class GhostLockProbe with _$GhostLockProbe {
  const GhostLockProbe._();

  const factory GhostLockProbe({
    /// 是否解析成功。
    required bool ok,

    /// 内核 release，与 `uname -r` 逐字可比。
    required String release,

    /// 自包含的 GLK profile 文本；失败为空串。
    required String conf,

    /// 提取过程中的告警，不阻断。
    required List<String> warnings,

    /// 实际参与解析的 boot 镜像路径；OTA / 直链输入时为解包后的缓存文件。
    required String bootPath,

    /// 失败原因码；成功为空串。
    required String reason,

    /// `kernel_phys_load` 的十六进制字面量；空串表示未取到。
    required String kernelPhysLoad,

    /// `kernel_phys_offset` 的十六进制字面量；空串表示未取到。
    required String kernelPhysOffset,

    /// `kernel_phys_load` 的来源（如 `xbl_config FDT`）；空串表示未取到。
    required String physSource,

    /// 内核审查报告全文；解析早期失败时为空串。
    required String analysis,
  }) = _GhostLockProbe;

  /// `kernel_phys_load` 是否取到；决定附加镜像是否真正生效。
  bool get hasKernelPhysLoad => kernelPhysLoad.isNotEmpty;
}
