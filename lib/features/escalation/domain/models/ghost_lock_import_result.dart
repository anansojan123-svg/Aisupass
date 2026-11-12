import 'package:freezed_annotation/freezed_annotation.dart';

part 'ghost_lock_import_result.freezed.dart';

/// 一次 profile 导入的结果。
@freezed
abstract class GhostLockImportResult with _$GhostLockImportResult {
  const GhostLockImportResult._();

  const factory GhostLockImportResult({
    /// 是否成功。
    required bool ok,

    /// 生成的 profile 对应的内核 release。
    required String release,

    /// 落盘文件名；失败为空串。
    required String fileName,

    /// 失败原因码；成功为空串。
    required String reason,

    /// 需要用户确认覆盖。
    required bool requiresOverwrite,
  }) = _GhostLockImportResult;
}
