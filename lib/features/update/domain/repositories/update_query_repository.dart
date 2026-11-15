import 'package:Aisupass/features/update/domain/models/app_update.dart';

/// 更新查询仓储：只读，把传输对象收敛成领域模型。
abstract class UpdateQueryRepository {
  /// 拉取服务端最新版本。
  ///
  /// 接口未配置、网络失败或响应无效时抛 `UpdateCheckException`。
  Future<AppUpdate> fetchLatest();
}
