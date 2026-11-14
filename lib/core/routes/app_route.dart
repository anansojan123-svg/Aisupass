import 'package:Aisupass/common/pages/desktop_page.dart';
import 'package:Aisupass/common/pages/main_page.dart';
import 'package:Aisupass/features/ai/presentation/pages/ai_config_edit_page.dart';
import 'package:Aisupass/features/ai/presentation/pages/ai_config_page.dart';
import 'package:Aisupass/features/chat/presentation/pages/chat_page.dart';
import 'package:Aisupass/features/escalation/presentation/pages/ghost_lock_profile_page.dart';
import 'package:Aisupass/features/escalation/presentation/pages/kernel_profile_edit_page.dart';
import 'package:Aisupass/features/escalation/presentation/pages/kernel_profile_page.dart';
import 'package:Aisupass/features/escalation/presentation/pages/manual_escalation_page.dart';
import 'package:Aisupass/features/escalation/presentation/pages/run_log_page.dart';
import 'package:go_router/go_router.dart';

/// 全局路由路径常量。
///
/// 页面内跳转一律引用这里的常量，不要在业务代码里写死路径字符串。
class AppRoute {
  AppRoute._();

  // 移动端
  static const home = '/';
  static const chat = '/chat';

  // AI 配置
  static const aiConfig = '/aiConfig';
  static const aiConfigEdit = '/aiConfig/edit/:id';

  /// 新建 AI 配置时使用的占位 id。
  static const newConfigId = 'new';

  /// 拼接编辑页路径，[id] 传 [newConfigId] 表示新建。
  static String aiConfigEditPath(String id) => '/aiConfig/edit/$id';

  // 提权
  static const manualEscalation = '/escalation/manual';

  // 内核表（boot.img 导入，GhostKey / GhostLock 两个 Tab）
  static const kernelProfile = '/kernelProfile';

  /// 内核表页路径；[tab] 为 `ghostkey` 时直接落在 GhostKey 页签。
  static String kernelProfilePath({String tab = ''}) =>
      tab.isEmpty ? kernelProfile : '$kernelProfile?tab=$tab';

  // GhostKey 内核表字段编辑器
  static const kernelProfileEdit = '/kernelProfile/edit';

  /// 编辑器路径；[name] 是目标用户文档名（含 `.conf`）。
  static String kernelProfileEditPath(String name) =>
      '$kernelProfileEdit?name=${Uri.encodeComponent(name)}';

  // GhostLock 内核表编辑器
  static const ghostLockProfile = '/ghostLock/profile';

  /// 编辑器路径；[name] 为用户文档名，空串表示内置/设备态。
  static String ghostLockProfilePath([String name = '']) => name.isEmpty
      ? ghostLockProfile
      : '$ghostLockProfile?name=${Uri.encodeComponent(name)}';

  // 运行记录
  static const String runLog = '/runLog';

  /// 详情页路径。`fileName` 编码后作为 query 参数。
  static String runLogDetail(String fileName) =>
      '$runLog?file=${Uri.encodeComponent(fileName)}';

  // 桌面端
  static const desktopHome = '/desktop';

  /// 未匹配路径的兜底规则，放在路由表最后。
  static const notFound = '/:notFound(.*)';
}

/// 业务路由表。
///
/// 这里只放能正常打开的页面；兜底路由与错误页在 [appRouterProvider] 中追加。
final List<GoRoute> appRoutes = [
  GoRoute(
    path: AppRoute.home,
    builder: (context, state) => const MainPage(),
  ),
  GoRoute(
    path: AppRoute.chat,
    builder: (context, state) => const ChatPage(),
  ),
  GoRoute(
    path: AppRoute.aiConfig,
    builder: (context, state) => const AiConfigPage(),
    routes: <RouteBase>[
      GoRoute(
        path: 'edit/:id',
        builder: (context, state) => AiConfigEditPage(
          configId: state.pathParameters['id'] ?? AppRoute.newConfigId,
        ),
      ),
    ],
  ),
  GoRoute(
    path: AppRoute.manualEscalation,
    builder: (context, state) => const ManualEscalationPage(),
  ),
  GoRoute(
    path: AppRoute.kernelProfile,
    builder: (context, state) => KernelProfilePage(
      initialTab: state.uri.queryParameters['tab'] == 'ghostkey' ? 1 : 0,
    ),
  ),
  GoRoute(
    path: AppRoute.kernelProfileEdit,
    builder: (context, state) => KernelProfileEditPage(
      name: state.uri.queryParameters['name'] ?? '',
    ),
  ),
  GoRoute(
    path: AppRoute.ghostLockProfile,
    builder: (context, state) => GhostLockProfilePage(
      name: state.uri.queryParameters['name'] ?? '',
    ),
  ),
  GoRoute(
    path: AppRoute.runLog,
    builder: (context, state) => RunLogPage(
      openedFile: state.uri.queryParameters['file'],
    ),
  ),
  GoRoute(
    path: AppRoute.desktopHome,
    builder: (context, state) => const DesktopPage(),
  ),
];
