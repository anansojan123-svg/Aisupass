import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/core/utils/kernel_image_picker.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_import_result.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_preflight.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_probe.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/kernel_profile_action_provider.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// 面板提示等级；页面据此选择 `ToastMessage` 的对应方法。
enum ImportNotice { success, warning, error }

/// 一次解析的结果：成功时 `probe` 非空，失败时 `error` / `analysis` 带原因。
typedef KernelImportParseOutcome = ({
  GhostLockProbe? probe,
  String error,
  String analysis,
});

/// 一次落盘/导入的结果：`needConfirm` 表示同名文档已存在，需页面确认覆盖。
typedef KernelImportOutcome = ({
  bool ok,
  bool needConfirm,
  String release,
  String fileName,
  String reason,
});

/// 内核表导入面板的流程编排：选文件、解析、落盘、交给 GhostKey、收集镜像。
///
/// 只调 Provider 与文件选择器；Toast 与确认弹窗由页面以回调注入，
/// 面板状态（进度、结果文本）仍由页面持有。
class KernelProfileImportController {
  KernelProfileImportController({
    required this._ref,
    required this._l10n,
    required this._pickFiles,
    required this._confirmOverwrite,
    required this._notify,
  });

  final WidgetRef _ref;
  final AppLocalizations _l10n;

  /// 打开系统文件选择器；`withData` 为 true 时同时取回文本内容。
  final Future<List<PlatformFile>?> Function({
    required List<String> extensions,
    required bool allowMultiple,
    required bool withData,
  })
  _pickFiles;

  /// 同名文档覆盖确认；返回 true 表示覆盖。
  final Future<bool> Function() _confirmOverwrite;

  /// 轻提示出口；文案在 Controller 内按 l10n 拼好。
  final void Function(String text, ImportNotice notice) _notify;

  /// 选一个附件镜像（img/bin）；取消或不可读返回空串。
  Future<String> pickImage() => _pickPath(<String>['img', 'bin']);

  /// 选一个外部文本（kallsyms / iomem）；取消或不可读返回空串。
  Future<String> pickText() => _pickPath(<String>['txt', 'log', 'conf']);

  /// 解析镜像，只出文本、不落盘。
  ///
  /// 输入是否为空、是否可读由页面判断；真正调用原生经 [probe] 注入，
  /// 避免 Controller 依赖表现层的输入模型。
  Future<KernelImportParseOutcome> parse({
    required bool hasInput,
    required bool readable,
    required Future<GhostLockProbe> Function() probe,
  }) async {
    if (!hasInput) {
      _notify(_l10n.kernelProfileImportNeedInput, ImportNotice.warning);
      return (probe: null, error: '', analysis: '');
    }
    if (!readable) {
      _notify(_l10n.kernelProfileImportEmptyFile, ImportNotice.error);
      return (probe: null, error: '', analysis: '');
    }
    try {
      final GhostLockProbe result = await probe();
      if (result.ok) return (probe: result, error: '', analysis: '');
      return (probe: null, error: result.reason, analysis: result.analysis);
    } catch (error) {
      return (probe: null, error: '$error', analysis: '');
    }
  }

  /// 写入 GhostLock 内核表；同名已存在时先经注入的确认回调。
  Future<KernelImportOutcome> saveToGhostLock(GhostLockProbe result) =>
      _saveProfile(result, overwrite: false);

  /// 直接导入现成的 HOCON / JSON 文档。
  ///
  /// 支持多选：带 `include` 的当主文档，其余当依赖，先存依赖再存主文档。
  Future<KernelImportOutcome> importExisting() async {
    final List<PlatformFile>? picked;
    try {
      picked = await _pickFiles(
        extensions: kernelProfileExtensions.toList(),
        allowMultiple: true,
        withData: true,
      );
    } catch (error) {
      _notify('$error', ImportNotice.error);
      return _emptyOutcome();
    }
    final Map<PlatformFile, String> texts = <PlatformFile, String>{};
    for (final PlatformFile file in picked ?? const <PlatformFile>[]) {
      final String? text = readKernelProfileText(file);
      if (text != null) texts[file] = text;
    }
    if (texts.isEmpty) {
      _notify(_l10n.escalationGhostLockImportUnsupported, ImportNotice.error);
      return _emptyOutcome();
    }
    /* 依赖文档必须先落盘，主文档的 include 才解析得到。 */
    final List<PlatformFile> usable = texts.keys.toList();
    final List<PlatformFile> mains = usable
        .where((PlatformFile file) => texts[file]!.contains('include '))
        .toList();
    final List<PlatformFile> ordered = mains.isEmpty
        ? usable
        : <PlatformFile>[
            ...usable.where((PlatformFile file) => !mains.contains(file)),
            ...mains,
          ];

    final List<PlatformFile> needOverwrite = <PlatformFile>[];
    GhostLockImportResult? last;
    try {
      for (final PlatformFile file in ordered) {
        final GhostLockImportResult result = await _ref
            .read(ghostLockProfileActionsProvider)
            .importProfileText(text: texts[file]!, fileName: file.name);
        if (result.ok) {
          last = result;
        } else if (result.requiresOverwrite) {
          needOverwrite.add(file);
        } else {
          _notify(
            _l10n.escalationGhostLockImportFailed(result.reason),
            ImportNotice.error,
          );
        }
      }
      if (needOverwrite.isNotEmpty && await _confirmOverwrite()) {
        for (final PlatformFile file in needOverwrite) {
          final GhostLockImportResult result = await _ref
              .read(ghostLockProfileActionsProvider)
              .importProfileText(
                text: texts[file]!,
                fileName: file.name,
                overwrite: true,
              );
          if (result.ok) last = result;
        }
      }
    } catch (error) {
      _notify('$error', ImportNotice.error);
      return _emptyOutcome();
    }
    /* 依赖文档的 release 为空，只有主文档才算导入成功。 */
    final GhostLockImportResult? primary = last;
    if (primary == null || primary.release.isEmpty) return _emptyOutcome();
    return (
      ok: true,
      needConfirm: false,
      release: primary.release,
      fileName: primary.fileName,
      reason: '',
    );
  }

  /// 把解析过的镜像交给 GhostKey，返回应发起的导入源（路径或 URL）。
  ///
  /// GhostKey 走自己的 Kotlin 解析链路，复用 probe 已解出的 boot 文件，
  /// 避免再下载一次整个 OTA。
  ({String path, String url}) importToGhostKey({
    required GhostLockProbe result,
    required String fallbackPath,
    required String url,
  }) {
    final String local = result.bootPath.isNotEmpty
        ? result.bootPath
        : fallbackPath;
    if (local.isEmpty) {
      final String target = url.trim();
      _ref.invalidate(importKernelProfileFromUrlProvider(url: target));
      return (path: '', url: target);
    }
    _ref.invalidate(importKernelProfileProvider(path: local));
    return (path: local, url: '');
  }

  /// 把刚落盘的文档设为生效来源。
  Future<void> autoLoadSaved(KernelImportOutcome outcome) async {
    if (outcome.fileName.isEmpty) return;
    try {
      final GhostLockPreflight preflight = await _ref.read(
        ghostLockPreflightProvider.future,
      );
      if (preflight.release.isEmpty) return;
      /* 选中新文档即撤销「指定生效内置表」，互斥由原生保证。 */
      await _ref
          .read(ghostLockProfileActionsProvider)
          .selectUserProfile(
            release: preflight.release,
            name: outcome.fileName,
          );
    } catch (_) {
      // 生效来源切换失败不影响已落盘的结果。
    }
  }

  /// 收集可导出镜像：本次解出的 boot、用户附加的镜像、缓存里上一次提取的产物。
  Future<List<String>> collectExportPaths({
    required String bootPath,
    required List<String> attachPaths,
  }) async {
    final Set<String> paths = <String>{};
    if (bootPath.isNotEmpty) paths.add(bootPath);
    for (final String path in attachPaths) {
      if (path.isNotEmpty) paths.add(path);
    }
    try {
      paths.addAll(
        await _ref.read(ghostLockProfileActionsProvider).listExtractedImages(),
      );
    } catch (_) {
      // 列目录失败不影响已收集到的那部分。
    }
    return paths.toList();
  }

  Future<String> _pickPath(List<String> extensions) async {
    final List<PlatformFile>? picked;
    try {
      picked = await _pickFiles(
        extensions: extensions,
        allowMultiple: false,
        withData: false,
      );
    } catch (error) {
      _notify('$error', ImportNotice.error);
      return '';
    }
    final String? path = (picked == null || picked.isEmpty)
        ? null
        : picked.first.path;
    if (path == null) return '';
    if (!isReadableFile(path)) {
      _notify(_l10n.kernelProfileImportEmptyFile, ImportNotice.error);
      return '';
    }
    return path;
  }

  /// 落盘一次；`overwrite` 为 false 时遇到同名先问页面。
  Future<KernelImportOutcome> _saveProfile(
    GhostLockProbe result, {
    required bool overwrite,
  }) async {
    try {
      final GhostLockImportResult saved = await _ref
          .read(ghostLockProfileActionsProvider)
          .saveProfile(
            release: result.release,
            conf: result.conf,
            overwrite: overwrite,
          );
      if (saved.ok) {
        return (
          ok: true,
          needConfirm: false,
          release: saved.release,
          fileName: saved.fileName,
          reason: '',
        );
      }
      if (!saved.requiresOverwrite) {
        _notify(
          _l10n.escalationGhostLockImportFailed(saved.reason),
          ImportNotice.error,
        );
        return (
          ok: false,
          needConfirm: false,
          release: '',
          fileName: '',
          reason: saved.reason,
        );
      }
      if (await _confirmOverwrite()) {
        return await _saveProfile(result, overwrite: true);
      }
      return (
        ok: false,
        needConfirm: true,
        release: '',
        fileName: '',
        reason: saved.reason,
      );
    } catch (error) {
      _notify('$error', ImportNotice.error);
      return (
        ok: false,
        needConfirm: false,
        release: '',
        fileName: '',
        reason: '',
      );
    }
  }

  KernelImportOutcome _emptyOutcome() =>
      (ok: false, needConfirm: false, release: '', fileName: '', reason: '');
}
