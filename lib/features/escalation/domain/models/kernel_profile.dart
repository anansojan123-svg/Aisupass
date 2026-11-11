import 'package:freezed_annotation/freezed_annotation.dart';

part 'kernel_profile.freezed.dart';

/// 一条已导入的用户 profile。
@freezed
abstract class KernelProfile with _$KernelProfile {
  const KernelProfile._();

  const factory KernelProfile({
    required String release,
    required String detail,
  }) = _KernelProfile;
}
