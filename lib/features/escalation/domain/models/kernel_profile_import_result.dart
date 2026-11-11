import 'package:freezed_annotation/freezed_annotation.dart';

part 'kernel_profile_import_result.freezed.dart';

/// 一次 profile 导入的结果。
@freezed
abstract class KernelProfileImportResult with _$KernelProfileImportResult {
  const KernelProfileImportResult._();

  const factory KernelProfileImportResult({
    required bool ok,
    required String release,
    required List<String> missing,
    required String errorCode,
    required String error,
  }) = _KernelProfileImportResult;
}
