import 'package:pigeon/pigeon.dart';

/// 一次 GhostLock 运行的入参。
class GhostLockRequest {
  GhostLockRequest({required this.managerPackage, required this.safeMode});

  /// 选中的 root 管理器包名，仅用于在缺内置 ksud 时定位 `libksud.so`。
  ///
  /// 空串表示没有选中管理器：Kotlin 侧只用内置 `libksud.so`，
  /// 没有内置时 KSU 阶段必然失败，但临时 root 仍可用。
  String managerPackage;

  /// 是否在执行前把 `/data/adb/modules` 下的模块标记为 disabled。
  ///
  /// 由上游 root 脚本消费；GLK1 的 `meta.safe_mode` 会被改写为 1。
  bool safeMode;
}

/// 运行前自检结果。
class GhostLockPreflight {
  GhostLockPreflight({
    required this.adbConnected,
    required this.shellUid,
    required this.seccomp,
    required this.release,
    required this.profileRelease,
    required this.route,
    required this.binaryPresent,
    required this.ksudPath,
    required this.profileError,
  });

  /// wire-ADB 是否已连接。
  bool adbConnected;

  /// shell 身份；`2000` 是可用值，`-1` 表示没取到。
  int shellUid;

  /// `/proc/$$/status` 的 `Seccomp`；`-1` 表示没取到。
  ///
  /// 非 0 时原生会尝试 W3 清 seccomp，失败则拿不到 KSU；`start` 会直接拒绝。
  int seccomp;

  /// 设备 `uname -r` 全串；取不到为空串。
  String release;

  /// 命中的 profile release；未命中为空串。
  String profileRelease;

  /// 命中的路由 token（`select_stack` / `tcp_zerocopy` / `multicast_waiter`）。
  String route;

  /// `nativeLibraryDir/libghostlock.so` 是否存在。
  bool binaryPresent;

  /// 将传给 `GHOSTLOCK_KSUD` 的路径；空串表示没有可用 ksud。
  String ksudPath;

  /// profile 编码失败的原因码；成功为空串。
  String profileError;
}

/// 受理结果。
class GhostLockStartResult {
  GhostLockStartResult({
    required this.accepted,
    required this.sessionId,
    required this.reason,
  });

  /// 是否受理。
  bool accepted;

  /// 受理后的会话标识；被拒时为空串。
  String sessionId;

  /// 被拒原因码：`alreadyRunning` / `noAdb` / `notShell` / `seccompFiltered` /
  /// `missingBinary` / `noProfile` / `profileInvalid`；空串表示受理。
  String reason;
}

/// 运行会话的一次快照。
///
/// 与 ADB 的 `ExecChunk` 同构：`output` 是**增量**，重复轮询不会重复拿到。
class GhostLockChunk {
  GhostLockChunk({
    required this.sessionId,
    required this.output,
    required this.finished,
    required this.exitCode,
    required this.timedOut,
    required this.durationMs,
    required this.failure,
  });

  /// 会话标识。
  String sessionId;

  /// 自上次轮询以来新增的输出（stdout 与 stderr 合并）。
  String output;

  /// 是否已结束。结束后原生侧回收会话。
  bool finished;

  /// 退出码；仅 [finished] 为 true 时有意义。
  ///
  /// `0` 完成，`1` 失败，`255` 原生 `pr_error`，`70` 脏竞争。
  int exitCode;

  /// 是否因本侧取消或超时停止读取。
  ///
  /// **不代表设备侧进程已停止**：攻击进程可能仍在跑。
  bool timedOut;

  /// 从受理到本次轮询的耗时（毫秒），单调时钟。
  int durationMs;

  /// 原生侧异常类名或本侧诊断码；空串表示无异常。
  String failure;
}

/// GhostLock（CVE-2026-43499）提权的原生接口。
///
/// 契约原则：
/// 1. `start` 只负责校验、编码与落位，真正跑起来在后台线程；
/// 2. 输出由 `poll` 增量取走；
/// 3. `cancel` 只停止本侧读取，不杀设备侧进程；
/// 4. 不抛异常，失败一律走结构化返回值。
@HostApi()
abstract class GhostLockNative {
  /// 读设备与资产状态，不解码 profile 之外的任何东西。
  @async
  GhostLockPreflight preflight();

  /// 受理一次运行。
  @async
  GhostLockStartResult start(GhostLockRequest request);

  /// 取走自上次轮询以来积累的输出。
  @async
  GhostLockChunk poll(String sessionId);

  /// 停止本侧读取。设备侧进程不受影响。
  @async
  void cancel(String sessionId);
}

/// 一份用户导入的 profile。
class GhostLockUserProfile {
  GhostLockUserProfile({
    required this.name,
    required this.release,
    required this.sizeBytes,
    required this.importedAtMs,
    required this.parseError,
  });

  /// 文件名，唯一标识。
  String name;

  /// 文档里声明的内核 release；解析失败为空串。
  String release;

  /// 文件字节数。
  int sizeBytes;

  /// 导入时间（毫秒时间戳）。
  int importedAtMs;

  /// 文本无法解析出 release。
  bool parseError;
}

/// 一次导入的结果。
class GhostLockImportResult {
  GhostLockImportResult({
    required this.ok,
    required this.release,
    required this.fileName,
    required this.reason,
    required this.requiresOverwrite,
  });

  /// 是否成功。
  bool ok;

  /// 生成的 profile 对应的内核 release。
  String release;

  /// 落盘文件名；失败为空串。
  String fileName;

  /// 失败原因码；成功为空串。
  String reason;

  /// 需要用户确认覆盖：`reason` 为 `alreadyExists` 时置 true。
  bool requiresOverwrite;
}

/// 一次解析（尚未落盘）的结果。
///
/// [conf] 是自包含的 GLK HOCON 全文，由 Dart 侧暂存；用户选完落点后原样回传
/// 给 `saveProfile`，避免二次提取。
class GhostLockProbeResult {
  GhostLockProbeResult({
    required this.ok,
    required this.release,
    required this.conf,
    required this.warnings,
    required this.bootPath,
    required this.reason,
  });

  /// 是否解析成功。
  bool ok;

  /// 内核 release，与 `uname -r` 逐字可比。
  String release;

  /// 自包含的 GLK profile 文本；失败为空串。
  String conf;

  /// 提取过程中的告警，不阻断。
  List<String> warnings;

  /// 实际参与解析的 boot 镜像路径。
  ///
  /// OTA / 直链输入时是解包后落在缓存里的文件；调用方可用它复用同一份镜像，
  /// 不必为另一套内核表再下载一次。
  String bootPath;

  /// 失败原因；成功为空串。
  String reason;
}

/// GhostLock profile 的解析、落盘与用户文档管理。
///
/// 提取在 Rust 侧（`libvrext.so`）完成。解析与落盘**分开**：`probeProfile`
/// 只返回文本不写文件，`saveProfile` 只写文件不再提取。
@HostApi()
abstract class GhostLockProfileNative {
  /// 解析内核表但不落盘；阻塞到结束。
  @async
  GhostLockProbeResult probeProfile(String input, bool insecure);

  /// 解析进度快照：`"<phase> <done> <total>"`。
  ///
  /// phase 0 = 下载（字节），1 = 解包与解析，2 = 完成；无总量时 `total` 为 0。
  @async
  String profileProgress();

  /// 把 [probeProfile] 返回的文本落盘；阻塞到结束。
  @async
  GhostLockImportResult saveProfile(
    String release,
    String conf,
    bool overwrite,
  );

  /// 从本地路径或 http(s) 直链提取并直接落盘；阻塞到结束。
  @async
  GhostLockImportResult importProfile(String input, bool insecure, bool overwrite);

  /// 列出用户导入的全部 profile，按导入时间倒序。
  @async
  List<GhostLockUserProfile> listImportedProfiles();

  /// 列出内置 GhostLock 内核表的全部 release，升序。
  @async
  List<String> listBuiltinReleases();

  /// 读取一份用户 profile 的完整 HOCON 文本；不存在返回空串。
  @async
  String readImportedProfile(String name);

  /// 删除一份用户 profile；不存在返回 false。
  @async
  bool removeImportedProfile(String name);
}

/// profile 树的一个节点，按先序扁平排列。
///
/// 契约里不自引用（`children` 会让 pigeon 的类型展开不终止），层级由
/// [depth] 表达，Dart 侧按先序 + depth 还原成树。
class GhostLockFieldNode {
  GhostLockFieldNode({
    required this.path,
    required this.name,
    required this.depth,
    required this.value,
    required this.provided,
    required this.overridden,
  });

  /// 完整点分路径，如 `task_struct.cred`。
  String path;

  /// 末段键名，用于显示。
  String name;

  /// 相对根的层级；根节点为 0。
  int depth;

  /// 当前值；[provided] 为 false 时无意义，UI 显示为空。
  int value;

  /// profile 是否为该字段提供了值。
  bool provided;

  /// 该字段或任一子孙是否被本地 override。
  bool overridden;
}

/// 通用参数页的一行。
class GhostLockExecutionField {
  GhostLockExecutionField({
    required this.path,
    required this.value,
    required this.overridden,
  });

  String path;
  int value;
  bool overridden;
}

/// 一次 profile 解析结果。
class GhostLockProfileConfig {
  GhostLockProfileConfig({
    required this.release,
    required this.hasProfile,
    required this.roots,
    required this.general,
    required this.route,
    required this.fallbackTo,
    required this.invalidPaths,
    required this.builtinReleases,
  });

  /// 设备内核 release。
  String release;

  /// 是否解析到可用 profile。
  bool hasProfile;

  /// 高级字段树。
  List<GhostLockFieldNode> roots;

  /// 通用参数。
  List<GhostLockExecutionField> general;

  /// 当前 route；空串表示未声明。
  String route;

  /// fallback 目标；空串表示未声明，`none` 表示显式关闭。
  String fallbackTo;

  /// 违规字段路径；UI 标红。
  List<String> invalidPaths;

  /// 内置表里的全部 release，升序。
  List<String> builtinReleases;
}

/// profile 编辑：读取解析结果、写 sparse override、导出。
///
/// 所有编辑都落到 override 层，导入的 conf 原文不动。
@HostApi()
abstract class GhostLockProfileEditNative {
  /// 解析 builtin + imported + override 三层。
  @async
  GhostLockProfileConfig loadProfile(String release);

  /// 写通用参数（execution tuning）。
  @async
  GhostLockProfileConfig updateGeneralFields(String release, Map<String, int> values);

  /// 写高级字段（点分路径 → 值）。
  @async
  GhostLockProfileConfig updateAdvancedFields(String release, Map<String, int> values);

  /// 设置 route；空串恢复为 profile 声明。
  @async
  GhostLockProfileConfig updateRoute(String release, String route);

  /// 设置 fallback；`none` 关闭，空串移除声明。
  @async
  GhostLockProfileConfig updateFallback(String release, String fallbackTo);

  /// 清掉该 release 的全部 override。
  @async
  GhostLockProfileConfig resetProfile(String release);

  /// 指定生效的内置表；[profileRelease] 为空串表示回到设备自身 release。
  @async
  GhostLockProfileConfig selectBuiltin(String release, String profileRelease);

  /// 指定生效的用户文档；[name] 为空串表示不使用导入层。
  @async
  GhostLockProfileConfig selectUserProfile(String release, String name);

  /// 把当前生效配置导出到 [path]（本地文件路径）。
  @async
  bool exportProfile(String release, String path);

  /// 把当前生效配置另存为一份用户文档。
  @async
  bool saveModifiedProfile(String release);
}
