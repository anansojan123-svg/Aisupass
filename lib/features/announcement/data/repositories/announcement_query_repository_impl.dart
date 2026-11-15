import 'package:Aisupass/features/announcement/data/datasources/announcement_query_datasource.dart';
import 'package:Aisupass/features/announcement/domain/models/announcement.dart';
import 'package:Aisupass/features/announcement/domain/repositories/announcement_query_repository.dart';

/// 公告查询仓储实现：DTO → Entity 的唯一转换点。
class AnnouncementQueryRepositoryImpl implements AnnouncementQueryRepository {
  const AnnouncementQueryRepositoryImpl({required this._datasource});

  final AnnouncementQueryDatasource _datasource;

  @override
  Future<Announcement> fetchLatest() async =>
      (await _datasource.fetchLatest()).toEntity();
}
