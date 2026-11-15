import 'package:Aisupass/features/update/domain/models/app_update.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_update_dto.freezed.dart';
part 'app_update_dto.g.dart';

/// 微验更新接口的响应体。
///
/// 期望结构：
/// `{"code":200,"msg":{"version":"611","app_update_url":"...",
/// "app_update_show":"...","app_update_must":""}}`。
@freezed
abstract class AppUpdateDto with _$AppUpdateDto {
  const AppUpdateDto._();

  const factory AppUpdateDto({
    @Default(AppUpdateMsgDto()) AppUpdateMsgDto msg,
  }) = _AppUpdateDto;

  factory AppUpdateDto.fromJson(Map<String, dynamic> json) =>
      _$AppUpdateDtoFromJson(json);

  AppUpdate toEntity() => AppUpdate(
    version: msg.version,
    downloadUrl: msg.appUpdateUrl,
    notes: msg.appUpdateShow,
    force: msg.isForced,
  );
}

/// 更新信息主体，对应响应里的 `msg` 节点。
@freezed
abstract class AppUpdateMsgDto with _$AppUpdateMsgDto {
  const AppUpdateMsgDto._();

  const factory AppUpdateMsgDto({
    @JsonKey(fromJson: _asString) @Default('') String version,
    @JsonKey(name: 'app_update_url', fromJson: _asString)
    @Default('') String appUpdateUrl,
    @JsonKey(name: 'app_update_show', fromJson: _asString)
    @Default('') String appUpdateShow,
    @JsonKey(name: 'app_update_must', fromJson: _asString)
    @Default('') String appUpdateMust,
  }) = _AppUpdateMsgDto;

  factory AppUpdateMsgDto.fromJson(Map<String, dynamic> json) =>
      _$AppUpdateMsgDtoFromJson(json);

  /// `app_update_must` 为 1 / true / yes 时视为强制更新。
  bool get isForced {
    final String value = appUpdateMust.trim().toLowerCase();
    return value == '1' || value == 'true' || value == 'yes';
  }
}

String _asString(Object? value) => value?.toString().trim() ?? '';
