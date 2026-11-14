import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';
import 'package:Aisupass/generated/root_manager.g.dart' as pigeon;

part 'root_manager_dto.freezed.dart';
part 'root_manager_dto.g.dart';

/// root 管理器 DTO，承接原生桥接扫描回来的原始取值。
///
/// 图标以 [List] 承载：`@Default(...)` 只接受常量，而 `Uint8List` 没有常量
/// 构造；转实体时才包成 [Uint8List]。
@freezed
abstract class RootManagerDto with _$RootManagerDto {
  const RootManagerDto._();

  const factory RootManagerDto({
    @Default('') String packageName,
    @Default('') String displayName,
    @Default(<int>[]) List<int> icon,
  }) = _RootManagerDto;

  factory RootManagerDto.fromJson(Map<String, dynamic> json) =>
      _$RootManagerDtoFromJson(json);

  /// 原生 `RootManagerInfo` -> 本 DTO：纯字段搬运。
  factory RootManagerDto.fromNative(pigeon.RootManagerInfo raw) =>
      RootManagerDto(
        packageName: raw.packageName,
        displayName: raw.displayName,
        icon: raw.icon,
      );

  /// 转成领域实体。
  RootManager toEntity() => RootManager(
    packageName: packageName,
    displayName: displayName,
    icon: Uint8List.fromList(icon),
  );
}
