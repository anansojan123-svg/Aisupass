import 'package:pigeon/pigeon.dart';

/// GhostKey（CVE-2026-98260）一次运行的入参。
///
/// 不含内核 release 与 profile：两者由原生侧通过 `uname -r` 与内置表解析，
/// 308 字节 profile blob 也全程留在 Kotlin 侧，不过 Pigeon。
class Cve98260Request {
  Cve98260Request({
    required this.managerPackage,
    required this.runKsu,
    required this.acceptFallbackPageOffset,
  });

  /// KernelSU 管理器的包名，仅用于 Dart 侧展示与「是否已装管理器」的提示。
  ///
  /// **原生不消费该字段**：`ksu.c:find_ksud()` 只认 `CVE98260_KSUD` /
  /// `<CVE98260_HOME>/ksud` / `/data/local/tmp/ksud` / `/data/adb/ksud` 四条路径，
  /// 且本任务（G8）改用内置 `jniLibs/arm64-v8a/libksud.so`，ksud 路径由 Kotlin 侧
  /// 从 `nativeLibraryDir` 取出后经 `CVE98260_KSUD` 传入，与 `managerPackage` 无关。
  /// 空串表示不指定管理器。
  String managerPackage;

  /// 是否在第 5 阶段执行 `ksu-takeover`。
  bool runKsu;

  /// 是否接受 `calibrate-b` 的 `fallback` 置信度。
  ///
  /// false 时该阶段状态记为 `failed` 并中止；true 时记 `degraded` 继续。
  bool acceptFallbackPageOffset;
}

/// 运行前自检快照。
///
/// 只回证据，不做结论：为什么不能跑由 Dart 侧按这些字段翻译。
class Cve98260Preflight {
  Cve98260Preflight({
    required this.adbConnected,
    required this.shellUid,
    required this.seccomp,
    required this.release,
    required this.profileMatched,
    required this.binaryPresent,
  });

  /// ADB 连接是否活着。
  bool adbConnected;

  /// shell 身份 uid：`2000` = shell，`0` = root，`-1` = 取不到。
  int shellUid;

  /// `/proc/$$/status` 的 `Seccomp` 字段：`0` = 无过滤器。
  ///
  /// `0` 是 GhostKey 能跑起来的硬条件；非 `0` 时注入阶段的 syscall 会被拒。
  /// `-1` = 取不到。
  int seccomp;

  /// 设备内核 release（`uname -r` 原样输出）；空串表示取不到。
  String release;

  /// 该 release 是否命中内置 profile 表。
  bool profileMatched;

  /// `nativeLibraryDir/libcve98260.so` 是否存在。
  bool binaryPresent;
}

/// 受理结果。
class Cve98260StartResult {
  Cve98260StartResult({
    required this.accepted,
    required this.sessionId,
    required this.reason,
  });

  /// 是否受理。
  bool accepted;

  /// 受理后的会话标识；被拒时为空串。
  String sessionId;

  /// 被拒原因码：`alreadyRunning` / `noAdb` / `notShell` / `seccompFiltered` /
  /// `missingBinary` / `noProfile` / `badRequest`；空串表示受理。
  String reason;
}

/// 一次阶段状态变化。
///
/// 只有码，没有可读文案：中文由 Dart 侧 `context.l10n` 按 `stage` + `status`
/// 映射，避免把 UI 文案写进原生。
class Cve98260StageEvent {
  Cve98260StageEvent({
    required this.stage,
    required this.status,
  });

  /// 阶段码：`calib_a` / `calib_b` / `inject` / `verify` / `ksu`。
  String stage;

  /// 状态码：`running` / `ok` / `degraded` / `failed` / `skipped`。
  String status;
}

/// 会话的一次快照。
class Cve98260Chunk {
  Cve98260Chunk({
    required this.sessionId,
    required this.events,
    required this.log,
    required this.finished,
    required this.exitCode,
    required this.timedOut,
    required this.durationMs,
    required this.failure,
  });

  /// 会话标识。
  String sessionId;

  /// 自上次轮询以来新增的阶段事件，按发生顺序排列。
  List<Cve98260StageEvent> events;

  /// 自上次轮询以来新增的原始输出（原生 stdout/stderr 合并，增量）。
  ///
  /// 原样透传，不做解析：判定逻辑留在 Kotlin 的会话层，Dart 只当终端显示。
  String log;

  /// 是否已结束。结束后原生侧回收会话。
  bool finished;

  /// 会话级退出码；仅 `finished` 为 true 时有意义。
  ///
  /// 沿用上游的分段码：`0` 成功 / `2` calib_a 失败 / `3` calib_b 失败 /
  /// `4` 注入失败 / `5` 提权校验失败 / `-1` 没拿到。KSU 阶段失败不影响
  /// 这个码（该阶段是可选的），只体现在 `events` 里。
  int exitCode;

  /// 是否因超时或本侧取消而掐断了某个阶段。
  bool timedOut;

  /// 从受理到本次轮询的耗时（毫秒），单调时钟。
  int durationMs;

  /// 原生侧异常类名，或 `"<stage>: exit frame missing"`；空串表示无异常。
  String failure;
}

/// GhostKey（CVE-2026-98260）的原生接口。
///
/// 契约原则：
/// 1. 五个阶段全部在 Kotlin 会话线程里串行编排，**Dart 不逐条发 ADB 命令**；
/// 2. `start` 只做自检与受理，真正执行在后台线程；
/// 3. 输出与阶段事件由 `poll` 增量取走，最长 30 秒的注入阶段也能边跑边显示；
/// 4. 不抛异常，失败一律走结构化返回值。
@HostApi()
abstract class Cve98260Native {
  /// 运行前自检：ADB 连接、shell 身份、seccomp、release、profile 命中、二进制在位。
  ///
  /// 零副作用（只跑 `id -u` / `grep Seccomp` / `uname -r` 与一次本地文件存在性
  /// 检查），可在页面进入时反复调用。
  @async
  Cve98260Preflight preflight();

  /// 受理一次运行。
  @async
  Cve98260StartResult start(Cve98260Request request);

  /// 取走自上次轮询以来新增的阶段事件与输出。
  @async
  Cve98260Chunk poll(String sessionId);

  /// 取消运行。
  ///
  /// 只做两件事：停止本侧读取、调 `rootd-stop` 让临时 root 优雅退出。
  /// **不对任何原生进程发信号**——它们钉住的页里有伪造 cred。
  @async
  void cancel(String sessionId);
}

/// 一条已导入的 profile。
class KernelProfile {
  KernelProfile({required this.release, required this.detail});

  /// 内核 release，与 `uname -r` 精确比对。
  String release;

  /// 导入来源描述（如 `img:boot.img`）；解析不到时为空串。
  String detail;
}

/// 一次导入的结果。
class KernelProfileImportResult {
  KernelProfileImportResult({
    required this.ok,
    required this.release,
    required this.missing,
    required this.errorCode,
    required this.error,
  });

  /// 是否成功落盘。
  bool ok;

  /// 生成的 release；失败时为空串。
  String release;

  /// 仍缺的必填字段路径（**非空表示没有落盘**）。
  List<String> missing;

  /// 错误码，见文档第 5.4 节；成功时为空串。
  String errorCode;

  /// 原生侧异常类名或原文，仅供排查，不直接展示。
  String error;
}

/// 用户 profile 的原生接口。
///
/// 契约原则：
/// 1. 只收路径字符串，boot.img 字节不过 Pigeon；
/// 2. 解析与落盘都在 Kotlin 侧的后台线程，`importBootImage` 完成才回调；
/// 3. 进度用 `"<phase> <done> <total>"` 三元组串，与 `DirtyFrag` 的 VR 提取一致；
/// 4. 不抛异常，失败一律走结构化返回值。
@HostApi()
abstract class Cve98260ProfileNative {
  /// 列出用户导入的全部 profile（不含 13 份内置）。
  @async
  List<KernelProfile> listImportedProfiles();

  /// 列出 13 份内置 profile（不含用户导入），顺序同 `index.conf`。
  @async
  List<KernelProfile> listBuiltinProfiles();

  /// 取导入进度快照。
  @async
  String importProgress();

  /// 解析 boot.img 并落盘；`path` 是 `file_picker` 给的临时路径。
  @async
  KernelProfileImportResult importBootImage(String path);

  /// 从 HTTP(S) 的 OTA 链接取 boot 分区并落盘。
  ///
  /// `url` 可以是整包 OTA zip（远端按 Range 只读 payload.bin 与 boot 分区）或
  /// 直接的 payload.bin 地址；写入与解析流程与 [importBootImage] 相同。
  @async
  KernelProfileImportResult importBootImageFromUrl(String url);

  /// 删除一份用户 profile；文件不存在返回 false。
  @async
  bool removeImportedProfile(String release);

  /// 读取一份用户 profile 的完整 HOCON 文本；文件不存在或解析失败返回空串。
  @async
  String readImportedProfile(String release);
}

/// 开一轮新日志。`runId` 由原生侧自算并回传，不要在这里传。
class RunLogBeginRequest {
  RunLogBeginRequest({
    required this.device,
    required this.kernel,
    required this.profile,
  });

  String device;
  String kernel;
  String profile;
}

/// 收尾一轮日志。`result` 用枚举名（RUNNING/SUCCESS/FAILED/STOPPED/INTERRUPTED）。
class RunLogFinishRequest {
  RunLogFinishRequest({
    required this.fileName,
    required this.result,
    this.exitCode,
    required this.durationMs,
  });

  String fileName;
  String result;
  int? exitCode;
  int durationMs;
}

/// 一条历史记录。`lineCount` 为 -1 表示文件里没写（中断）。
class RunLogMetaDto {
  RunLogMetaDto({
    required this.fileName,
    required this.runId,
    required this.startedAt,
    required this.result,
    this.exitCode,
    required this.durationMs,
    required this.lineCount,
    required this.device,
    required this.kernel,
    required this.profile,
  });

  String fileName;
  int runId;
  int startedAt;
  String result;
  int? exitCode;
  int durationMs;
  int lineCount;
  String device;
  String kernel;
  String profile;
}

/// 归因入参：本轮累计日志行 + 退出码。
class RunLogDiagnoseRequest {
  RunLogDiagnoseRequest({
    required this.lines,
    required this.exitCode,
  });

  List<String> lines;
  int exitCode;
}

/// 归因结果。只有规则码和原始证据行，没有可读文案。
class RunLogDiagnosisDto {
  RunLogDiagnosisDto({
    required this.ruleId,
    this.stage,
    required this.evidence,
  });

  String ruleId;
  String? stage;
  List<String> evidence;
}

/// 运行日志 + 失败归因。第三个 HostApi，与 Cve98260Native / Cve98260ProfileNative 并列。
///
/// 契约原则：
/// 1. 只回码和原始串，文案全部在 Dart 侧 l10n；
/// 2. 所有方法 `@async`，磁盘 IO 一律不回主线程；
/// 3. 文件名（`fileName`）是唯一句柄，Dart 侧不要自己拼路径；
/// 4. 例外一律不抛，失败回空列表 / 空串 / `ruleId = ""`。
@HostApi()
abstract class Cve98260RunLogNative {
  @async
  RunLogMetaDto beginRun(RunLogBeginRequest request);

  @async
  void appendLines(String fileName, List<String> lines);

  @async
  void finishRun(RunLogFinishRequest request);

  @async
  List<RunLogMetaDto> listRuns();

  @async
  List<String> readBody(String fileName);

  @async
  String exportAllText();

  @async
  void deleteRun(String fileName);

  @async
  void clearRuns();

  @async
  RunLogDiagnosisDto diagnose(RunLogDiagnoseRequest request);
}
