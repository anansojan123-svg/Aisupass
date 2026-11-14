import 'package:freezed_annotation/freezed_annotation.dart';

part 'kernel_profile.freezed.dart';

/// 一条已导入的用户 profile。
@freezed
abstract class KernelProfile with _$KernelProfile {
  const KernelProfile._();

  const factory KernelProfile({
    /// 用户文档名（含 `.conf`）；内置表为空串。
    ///
    /// 同一 release 可以有多份文档，删除/编辑/生效选择都以它为准。
    @Default('') String name,

    required String release,
    required String detail,
  }) = _KernelProfile;

  /// 是否为用户导入文档（可编辑、可选中生效）。
  bool get isUserDocument => name.isNotEmpty;
}
