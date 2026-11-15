import 'package:freezed_annotation/freezed_annotation.dart';

part 'announcement.freezed.dart';

/// 服务端下发的公告内容。
@freezed
abstract class Announcement with _$Announcement {
  const Announcement._();

  const factory Announcement({required String content}) = _Announcement;

  /// 内容为空时不值得打扰用户。
  bool get isBlank => content.trim().isEmpty;
}
