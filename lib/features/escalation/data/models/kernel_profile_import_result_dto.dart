import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:Aisupass/features/escalation/domain/models/kernel_profile_import_result.dart';

part 'kernel_profile_import_result_dto.freezed.dart';
part 'kernel_profile_import_result_dto.g.dart';

/// [KernelProfileImportResult] 的传输形态。
@freezed
abstract class KernelProfileImportResultDto
    with _$KernelProfileImportResultDto {
  const KernelProfileImportResultDto._();

  const factory KernelProfileImportResultDto({
    @Default(false) bool ok,
    @Default('') String release,
    @Default(<String>[]) List<String> missing,
    @Default('') String errorCode,
    @Default('') String error,
  }) = _KernelProfileImportResultDto;

  factory KernelProfileImportResultDto.fromJson(Map<String, dynamic> json) =>
      _$KernelProfileImportResultDtoFromJson(json);

  KernelProfileImportResult toEntity() => KernelProfileImportResult(
    ok: ok,
    release: release,
    missing: missing,
    errorCode: errorCode,
    error: error,
  );
}
