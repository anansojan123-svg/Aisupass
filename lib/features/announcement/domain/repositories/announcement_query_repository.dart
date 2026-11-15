import 'package:Aisupass/features/announcement/domain/models/announcement.dart';

/// 公告查询操作仓储接口。
abstract class AnnouncementQueryRepository {
  /// 拉取服务端当前公告。
  Future<Announcement> fetchLatest();
}
