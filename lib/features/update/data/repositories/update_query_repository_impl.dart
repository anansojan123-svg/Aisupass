import 'package:Aisupass/features/update/data/datasources/update_query_datasource.dart';
import 'package:Aisupass/features/update/domain/models/app_update.dart';
import 'package:Aisupass/features/update/domain/repositories/update_query_repository.dart';

/// 更新查询仓储实现：DTO → Entity 的唯一转换点。
class UpdateQueryRepositoryImpl implements UpdateQueryRepository {
  const UpdateQueryRepositoryImpl({required this._datasource});

  final UpdateQueryDatasource _datasource;

  @override
  Future<AppUpdate> fetchLatest() async =>
      (await _datasource.fetchLatest()).toEntity();
}
