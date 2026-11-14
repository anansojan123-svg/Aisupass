import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';

/// 按包名找已安装 root 管理器；包名为空时回落到用户已选项，未装时返回 null。
Future<RootManager?> resolveRootManager(Ref ref, String packageName) async {
  if (packageName.isEmpty) {
    return ref.read(selectedRootManagerProvider.future);
  }
  final List<RootManager> managers = await ref.read(
    installedRootManagersProvider.future,
  );
  for (final RootManager manager in managers) {
    if (manager.packageName == packageName) return manager;
  }
  return null;
}
