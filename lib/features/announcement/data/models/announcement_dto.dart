import 'package:Aisupass/features/announcement/domain/models/announcement.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'announcement_dto.freezed.dart';
part 'announcement_dto.g.dart';

/// 微验公告接口的响应体。
///
/// 期望结构：`{"code":200,"msg":{"app_gg":"公告正文"}}`。
@freezed
abstract class AnnouncementDto with _$AnnouncementDto {
  const AnnouncementDto._();

  const factory AnnouncementDto({
    @Default(AnnouncementMsgDto()) AnnouncementMsgDto msg,
  }) = _AnnouncementDto;

  factory AnnouncementDto.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementDtoFromJson(json);

  Announcement toEntity() => Announcement(content: msg.content);
}

/// 公告主体，对应响应里的 `msg` 节点。
@freezed
abstract class AnnouncementMsgDto with _$AnnouncementMsgDto {
  const AnnouncementMsgDto._();

  const factory AnnouncementMsgDto({
    @JsonKey(name: 'app_gg', fromJson: _asString) @Default('') String content,
  }) = _AnnouncementMsgDto;

  factory AnnouncementMsgDto.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementMsgDtoFromJson(json);
}

String _asString(Object? value) => value?.toString().trim() ?? '';
