import 'dart:typed_data';

import 'package:Aisupass/features/escalation/domain/enums/handoff_kind.dart';
import 'package:Aisupass/features/escalation/domain/models/handoff_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'handoff_outcome_dto.freezed.dart';
part 'handoff_outcome_dto.g.dart';

/// 移交结果的 DTO，承接命令退出码与两路输出。
///
/// 管理器按字段摊平：`RootManager` 的图标是 `Uint8List`，没有常量构造，
/// 只能用 `List<int>` 承载缺省值。
@freezed
abstract class HandoffOutcomeDto with _$HandoffOutcomeDto {
  const HandoffOutcomeDto._();

  const factory HandoffOutcomeDto({
    @Default(HandoffKind.failed) HandoffKind kind,
    @Default('') String managerPackage,
    @Default('') String managerDisplayName,
    @Default(<int>[]) List<int> managerIcon,
    @Default('') String ksudPath,
    @Default(-1) int exitCode,
    @Default('') String output,
    @Default(0) int durationMs,
    @Default(false) bool timedOut,
  }) = _HandoffOutcomeDto;

  factory HandoffOutcomeDto.fromJson(Map<String, dynamic> json) =>
      _$HandoffOutcomeDtoFromJson(json);

  /// 转成领域实体。
  HandoffOutcome toEntity() => HandoffOutcome(
    kind: kind,
    manager: RootManager(
      packageName: managerPackage,
      displayName: managerDisplayName,
      icon: Uint8List.fromList(managerIcon),
    ),
    ksudPath: ksudPath,
    exitCode: exitCode,
    output: output,
    durationMs: durationMs,
    timedOut: timedOut,
  );
}
