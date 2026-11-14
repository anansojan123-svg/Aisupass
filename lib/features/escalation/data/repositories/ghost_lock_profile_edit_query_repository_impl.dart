import 'package:Aisupass/features/escalation/data/datasources/ghost_lock_profile_edit_query_datasource.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_active_source.dart';
import 'package:Aisupass/features/escalation/domain/repositories/ghost_lock_profile_edit_query_repository.dart';

/// GhostLock profile 编辑只读仓储实现。
class GhostLockProfileEditQueryRepositoryImpl
    implements GhostLockProfileEditQueryRepository {
  GhostLockProfileEditQueryRepositoryImpl({required this._datasource});

  final GhostLockProfileEditQueryDatasource _datasource;

  @override
  Future<GhostLockActiveSource> activeSource() async {
    final List<String> values = await Future.wait(<Future<String>>[
      _datasource.activeBuiltinRelease(),
      _datasource.activeUserProfile(),
    ]);
    return GhostLockActiveSource(builtin: values[0], user: values[1]);
  }
}
