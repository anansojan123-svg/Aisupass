import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/kernel_image_picker.dart';
import 'package:Aisupass/core/utils/kernel_profile_text.dart';
import 'package:Aisupass/features/escalation/domain/enums/kernel_profile_import_target.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_import_result.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_preflight.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_probe.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_probe_progress.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile_import_state.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/kernel_profile_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/kernel_profile_query_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_image_input_section.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_image_export_sheet.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_attach_section.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_probe_result.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 打开导入弹层；写入成功后返回落点，供调用方切到对应页签。
///
/// [initialTarget] 是打开时默认选中的内核表，通常取当前页签。
Future<KernelProfileImportTarget?> showKernelProfileImportSheet(
  BuildContext context, {
  KernelProfileImportTarget initialTarget = KernelProfileImportTarget.ghostLock,
}) => showModalBottomSheet<KernelProfileImportTarget>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (BuildContext sheetContext) {
    final AppLocalizations l10n = sheetContext.l10n;
    final ColorScheme scheme = sheetContext.colorScheme;
    return FractionallySizedBox(
      heightFactor: 0.92,
      child: Column(
        children: <Widget>[
          /* 拖拽条，暗示弹层可上滑收起。 */
          Padding(
            padding: EdgeInsets.only(top: 8.h, bottom: 2.h),
            child: Container(
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: scheme.onSurfaceVariant.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 6.h, 8.w, 2.h),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    l10n.kernelProfileImportEntry,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  icon: Icon(Icons.close_rounded, size: 20.sp),
                ),
              ],
            ),
          ),
          Expanded(
            child: KernelProfileImportPanel(initialTarget: initialTarget),
          ),
        ],
      ),
    );
  },
);

/// 内核表导入面板：选目标 → 解析 → 写入所选内核表。
///
/// 目标为 GhostLock 时展示 xbl / uefi / vendor_boot / phys / kallsyms / iomem /
/// route 等只影响 GhostLock 推导的选项；目标为 GhostKey 时整块隐藏。
class KernelProfileImportPanel extends HookConsumerWidget {
  const KernelProfileImportPanel({
    super.key,
    this.initialTarget = KernelProfileImportTarget.ghostLock,
  });

  /// 打开时选中的内核表。
  final KernelProfileImportTarget initialTarget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;

    final ValueNotifier<KernelProfileImportTarget> target =
        useState<KernelProfileImportTarget>(initialTarget);

    final ValueNotifier<KernelImageInput> imageInput =
        useState<KernelImageInput>(const KernelImageInput());

    // 可选附加镜像：用于从 FDT / memory map 补齐 kernel_phys_load。
    final ValueNotifier<String?> xblPath = useState<String?>(null);
    final ValueNotifier<String?> uefiPath = useState<String?>(null);
    final ValueNotifier<String?> vendorBootPath = useState<String?>(null);
    final TextEditingController physController = useTextEditingController();
    final ValueNotifier<bool> attachExpanded = useState<bool>(false);

    // 上游 CLI 的解析选项：外部 kallsyms / iomem、强制路由、缺符号容忍、跳过反汇编。
    final ValueNotifier<String?> kallsymsPath = useState<String?>(null);
    final ValueNotifier<String?> iomemPath = useState<String?>(null);
    final ValueNotifier<String> forcedRoute = useState<String>('');
    final ValueNotifier<bool> allowMissing = useState<bool>(false);
    final ValueNotifier<bool> noDisasm = useState<bool>(false);
    final ValueNotifier<bool> advancedExpanded = useState<bool>(false);

    // 解析：只出文本，不落盘。
    final ValueNotifier<bool> probing = useState<bool>(false);
    final ValueNotifier<GhostLockProbe?> probe = useState<GhostLockProbe?>(
      null,
    );
    final ValueNotifier<String?> probeError = useState<String?>(null);
    final ValueNotifier<String?> failedAnalysis = useState<String?>(null);

    // 落盘与 GhostKey 导入。
    final ValueNotifier<bool> busy = useState<bool>(false);
    final ValueNotifier<String?> doneText = useState<String?>(null);
    final ValueNotifier<String?> ghostKeyPath = useState<String?>(null);
    final ValueNotifier<String?> ghostKeyUrl = useState<String?>(null);
    final ObjectRef<String> handledRelease = useRef<String>('');
    /* 落盘后 probe 会被清空，导出镜像仍需记住本次解出的 boot。 */
    final ObjectRef<String> lastBootPath = useRef<String>('');
    /* 本次是否已解析成功；导出图标只在解析完成后出现。 */
    final ValueNotifier<bool> parsed = useState<bool>(false);
    /* 可导出的镜像路径；为空时不显示导出入口。 */
    final ValueNotifier<List<String>> exportPaths = useState<List<String>>(
      const <String>[],
    );

    final AsyncValue<KernelProfileImportState>? ghostKeyImport =
        ghostKeyPath.value != null
        ? ref.watch(importKernelProfileProvider(path: ghostKeyPath.value!))
        : ghostKeyUrl.value != null
        ? ref.watch(importKernelProfileFromUrlProvider(url: ghostKeyUrl.value!))
        : null;

    // 只在解析期间轮询，结束即退订。
    final AsyncValue<GhostLockProbeProgress> probeProgress = probing.value
        ? ref.watch(ghostLockProbeProgressProvider)
        : const AsyncValue<GhostLockProbeProgress>.data(
            GhostLockProbeProgress(phase: 0, done: 0, total: 0),
          );

    useEffect(() {
      final KernelProfileImportState? state = ghostKeyImport?.value;
      if (state == null) return null;
      if (state.finished &&
          state.result.ok &&
          handledRelease.value != state.result.release) {
        handledRelease.value = state.result.release;
        ref.invalidate(kernelProfileListProvider);
        doneText.value = l10n.kernelProfileImportSuccess(state.result.release);
        /* 落点已确定，把结果回给页面切页签。 */
        if (context.mounted) {
          Navigator.of(context).pop(KernelProfileImportTarget.ghostKey);
        }
      }
      return null;
    }, <Object?>[ghostKeyImport]);

    /// 输入变化后作废上一次的解析结果，避免拿旧结果落盘。
    void invalidateProbe() {
      probe.value = null;
      probeError.value = null;
      failedAnalysis.value = null;
      doneText.value = null;
      parsed.value = false;
    }

    /// 选择可选的 xbl_config / uefi / vendor_boot 镜像。
    Future<void> pickAttach(ValueNotifier<String?> slot) async {
      final FilePickerResult? picked;
      try {
        picked = await FilePicker.pickFiles(
          type: FileType.custom,
          allowedExtensions: <String>['img', 'bin'],
          withData: false,
        );
      } catch (error) {
        ToastMessage.error(error);
        return;
      }
      final String? path = picked?.files.firstOrNull?.path;
      if (path == null) return;
      if (!isReadableFile(path)) {
        ToastMessage.error(l10n.kernelProfileImportEmptyFile);
        return;
      }
      slot.value = path;
      invalidateProbe();
    }

    /// 选择外部 kallsyms / iomem 文本文件。
    Future<void> pickText(ValueNotifier<String?> slot) async {
      final FilePickerResult? picked;
      try {
        picked = await FilePicker.pickFiles(
          type: FileType.custom,
          allowedExtensions: <String>['txt', 'log', 'conf'],
          withData: false,
        );
      } catch (error) {
        ToastMessage.error(error);
        return;
      }
      final String? path = picked?.files.firstOrNull?.path;
      if (path == null) return;
      if (!isReadableFile(path)) {
        ToastMessage.error(l10n.kernelProfileImportEmptyFile);
        return;
      }
      slot.value = path;
      invalidateProbe();
    }

    /// 落盘成功后把该文档设为生效来源。
    Future<void> autoLoadSaved(GhostLockImportResult saved) async {
      if (saved.fileName.isEmpty) return;
      try {
        final GhostLockPreflight preflight = await ref.read(
          ghostLockPreflightProvider.future,
        );
        if (preflight.release.isEmpty) return;
        /* 选中新文档即撤销「指定生效内置表」，互斥由原生保证。 */
        await ref
            .read(ghostLockProfileActionsProvider)
            .selectUserProfile(
              release: preflight.release,
              name: saved.fileName,
            );
      } catch (_) {
        // 生效来源切换失败不影响已落盘的结果。
      }
    }

    /// 收集可导出镜像：本次解出的 boot、用户附加的镜像、缓存里上一次提取的产物。
    Future<List<String>> collectExportPaths() async {
      final Set<String> paths = <String>{};
      final GhostLockProbe? current = probe.value;
      final String boot = current?.bootPath ?? lastBootPath.value;
      if (boot.isNotEmpty) paths.add(boot);
      for (final String? path in <String?>[
        xblPath.value,
        uefiPath.value,
        vendorBootPath.value,
      ]) {
        if (path != null && path.isNotEmpty) paths.add(path);
      }
      try {
        paths.addAll(
          await ref.read(ghostLockProfileActionsProvider).listExtractedImages(),
        );
      } catch (_) {
        // 列目录失败不影响已收集到的那部分。
      }
      return paths.toList();
    }

    /* 每次解析完成后才刷新可导出列表。 */
    useEffect(() {
      if (!parsed.value) {
        exportPaths.value = const <String>[];
        return null;
      }
      bool cancelled = false;
      collectExportPaths().then((List<String> paths) {
        if (!cancelled) exportPaths.value = paths;
      });
      return () => cancelled = true;
    }, <Object?>[parsed.value, probe.value, lastBootPath.value]);

    Future<void> exportImages() async {
      final List<String> paths = await collectExportPaths();
      if (!context.mounted) return;
      exportPaths.value = paths;
      await showKernelImageExportSheet(context, paths: paths);
    }

    /// 直接导入现成的 HOCON / JSON 内核表。
    ///
    /// 支持多选：带 `include` 的当主文档，其余当依赖，先存依赖再存主文档。
    Future<void> importExisting() async {
      final FilePickerResult? picked;
      try {
        picked = await FilePicker.pickFiles(
          type: FileType.custom,
          allowedExtensions: kernelProfileExtensions.toList(),
          withData: true,
          allowMultiple: true,
        );
      } catch (error) {
        ToastMessage.error(error);
        return;
      }
      final Map<PlatformFile, String> texts = <PlatformFile, String>{};
      for (final PlatformFile file in picked?.files ?? const <PlatformFile>[]) {
        final String? text = readKernelProfileText(file);
        if (text != null) texts[file] = text;
      }
      if (texts.isEmpty) {
        ToastMessage.error(l10n.escalationGhostLockImportUnsupported);
        return;
      }
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

      busy.value = true;
      doneText.value = null;
      try {
        final List<PlatformFile> needOverwrite = <PlatformFile>[];
        GhostLockImportResult? last;
        for (final PlatformFile file in ordered) {
          final GhostLockImportResult result = await ref
              .read(ghostLockProfileActionsProvider)
              .importProfileText(text: texts[file]!, fileName: file.name);
          if (result.ok) {
            last = result;
          } else if (result.requiresOverwrite) {
            needOverwrite.add(file);
          } else {
            ToastMessage.error(
              l10n.escalationGhostLockImportFailed(result.reason),
            );
          }
        }
        if (needOverwrite.isNotEmpty && context.mounted) {
          final bool? confirmed = await _confirmOverwrite(context);
          if (confirmed == true) {
            for (final PlatformFile file in needOverwrite) {
              final GhostLockImportResult result = await ref
                  .read(ghostLockProfileActionsProvider)
                  .importProfileText(
                    text: texts[file]!,
                    fileName: file.name,
                    overwrite: true,
                  );
              if (result.ok) last = result;
            }
          }
        }
        /* 依赖文档的 release 为空，只有主文档才提示成功并自动生效。 */
        final GhostLockImportResult? primary = last;
        if (primary != null && primary.release.isNotEmpty) {
          doneText.value = l10n.escalationGhostLockImportDone(primary.release);
          await autoLoadSaved(primary);
        }
      } catch (error) {
        ToastMessage.error(error);
      } finally {
        busy.value = false;
      }
    }

    Future<void> parse() async {
      final KernelImageInput input = imageInput.value;
      if (input.isEmpty) {
        ToastMessage.warning(l10n.kernelProfileImportNeedInput);
        return;
      }
      if (input.path != null && !isReadableFile(input.path!)) {
        ToastMessage.error(l10n.kernelProfileImportEmptyFile);
        return;
      }
      FocusScope.of(context).unfocus();
      probing.value = true;
      probe.value = null;
      probeError.value = null;
      failedAnalysis.value = null;
      doneText.value = null;
      try {
        final GhostLockProbe result = await ref
            .read(ghostLockProfileActionsProvider)
            .probeProfile(
              input: input.value,
              insecure: input.insecure,
              xblPath: xblPath.value ?? '',
              uefiPath: uefiPath.value ?? '',
              vendorBootPath: vendorBootPath.value ?? '',
              phys: physController.text.trim(),
              kallsymsPath: kallsymsPath.value ?? '',
              iomemPath: iomemPath.value ?? '',
              route: forcedRoute.value,
              allowMissing: allowMissing.value,
              noDisasm: noDisasm.value,
            );
        if (result.ok) {
          probe.value = result;
          lastBootPath.value = result.bootPath;
          /* 只有解析成功才亮出导出图标。 */
          parsed.value = true;
        } else {
          probeError.value = result.reason;
          failedAnalysis.value = result.analysis.isEmpty
              ? null
              : result.analysis;
        }
      } catch (error) {
        probeError.value = error.toString();
      } finally {
        probing.value = false;
      }
    }

    /// 写入 GhostLock 内核表；返回是否成功落盘。
    Future<bool> saveToGhostLock(GhostLockProbe result) async {
      busy.value = true;
      try {
        final GhostLockImportResult saved = await ref
            .read(ghostLockProfileActionsProvider)
            .saveProfile(release: result.release, conf: result.conf);
        if (saved.ok) {
          doneText.value = l10n.escalationGhostLockImportDone(saved.release);
          probe.value = null;
          await autoLoadSaved(saved);
          return true;
        }
        if (saved.requiresOverwrite && context.mounted) {
          final bool? confirmed = await _confirmOverwrite(context);
          if (confirmed == true) {
            final GhostLockImportResult retry = await ref
                .read(ghostLockProfileActionsProvider)
                .saveProfile(
                  release: result.release,
                  conf: result.conf,
                  overwrite: true,
                );
            if (retry.ok) {
              doneText.value = l10n.escalationGhostLockImportDone(
                retry.release,
              );
              probe.value = null;
              await autoLoadSaved(retry);
              return true;
            }
            ToastMessage.error(
              l10n.escalationGhostLockImportFailed(retry.reason),
            );
          }
          return false;
        }
        ToastMessage.error(l10n.escalationGhostLockImportFailed(saved.reason));
        return false;
      } catch (error) {
        ToastMessage.error(error);
        return false;
      } finally {
        busy.value = false;
      }
    }

    /// 把解析过的镜像交给 GhostKey。
    ///
    /// GhostKey 走自己的 Kotlin 解析链路（表结构不同），复用 probe 已解出的
    /// boot 文件，避免再下载一次整个 OTA。
    void importToGhostKey(GhostLockProbe result) {
      final String local = result.bootPath.isNotEmpty
          ? result.bootPath
          : imageInput.value.path ?? '';
      handledRelease.value = '';
      doneText.value = null;
      probe.value = null;
      ghostKeyUrl.value = null;
      ghostKeyPath.value = local.isEmpty ? null : local;
      if (local.isEmpty) {
        ghostKeyUrl.value = imageInput.value.url.trim();
        ref.invalidate(
          importKernelProfileFromUrlProvider(url: ghostKeyUrl.value!),
        );
        return;
      }
      ref.invalidate(importKernelProfileProvider(path: local));
    }

    Future<void> saveToTarget(GhostLockProbe result) async {
      if (!context.mounted) return;
      switch (target.value) {
        case KernelProfileImportTarget.ghostLock:
          if (await saveToGhostLock(result) && context.mounted) {
            Navigator.of(context).pop(KernelProfileImportTarget.ghostLock);
          }
        case KernelProfileImportTarget.ghostKey:
          importToGhostKey(result);
      }
    }

    final GhostLockProbe? probed = probe.value;
    final KernelProfileImportState? keyState = ghostKeyImport?.value;
    /* GhostKey 流式导入期间也视作忙碌，避免重复提交。 */
    final bool importingKey =
        ghostKeyImport != null && !(keyState?.finished ?? false);
    final bool anyBusy = probing.value || busy.value || importingKey;
    final bool ghostLockTarget =
        target.value == KernelProfileImportTarget.ghostLock;

    final String targetName = ghostLockTarget
        ? l10n.kernelProfileGhostLockEntry
        : l10n.kernelProfileGhostKeyEntry;

    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // ---- 导入目标 ----
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<KernelProfileImportTarget>(
                    segments: <ButtonSegment<KernelProfileImportTarget>>[
                      ButtonSegment<KernelProfileImportTarget>(
                        value: KernelProfileImportTarget.ghostLock,
                        icon: Icon(Icons.lock_rounded, size: 15.r),
                        label: Text(l10n.kernelProfileImportTargetGhostLock),
                      ),
                      ButtonSegment<KernelProfileImportTarget>(
                        value: KernelProfileImportTarget.ghostKey,
                        icon: Icon(Icons.vpn_key_rounded, size: 15.r),
                        label: Text(l10n.kernelProfileImportTargetGhostKey),
                      ),
                    ],
                    selected: <KernelProfileImportTarget>{target.value},
                    showSelectedIcon: false,
                    style: const ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onSelectionChanged: anyBusy
                        ? null
                        : (Set<KernelProfileImportTarget> picked) {
                            target.value = picked.first;
                            /* 目标切换后旧结果不再对应当前表。 */
                            invalidateProbe();
                          },
                  ),
                ),
                SizedBox(height: 14.h),
                // ---- 公共输入层 ----
                KernelImageInputSection(
                  input: imageInput.value,
                  enabled: !anyBusy,
                  onChanged: (KernelImageInput next) {
                    imageInput.value = next;
                    invalidateProbe();
                  },
                  onImportExisting: importExisting,
                  onSubmit: parse,
                ),
                /* 附件与高级选项影响解析参数，必须排在解析动作之前。 */
                if (ghostLockTarget) ...<Widget>[
                  SizedBox(height: 12.h),
                  KernelProfileAttachSection(
                    expanded: attachExpanded.value,
                    onToggle: anyBusy
                        ? null
                        : () => attachExpanded.value = !attachExpanded.value,
                    anyBusy: anyBusy,
                    xblPath: xblPath,
                    uefiPath: uefiPath,
                    vendorBootPath: vendorBootPath,
                    physController: physController,
                    onPick: pickAttach,
                    onCleared: invalidateProbe,
                    fromPackage: imageInput.value.fromPackage,
                  ),
                  SizedBox(height: 8.h),
                  KernelProfileAdvancedSection(
                    expanded: advancedExpanded.value,
                    onToggle: anyBusy
                        ? null
                        : () =>
                              advancedExpanded.value = !advancedExpanded.value,
                    anyBusy: anyBusy,
                    kallsymsPath: kallsymsPath,
                    iomemPath: iomemPath,
                    forcedRoute: forcedRoute,
                    allowMissing: allowMissing,
                    noDisasm: noDisasm,
                    onPick: pickText,
                    onChanged: invalidateProbe,
                  ),
                ],
                if (probing.value) ...<Widget>[
                  SizedBox(height: 16.h),
                  KernelProfileProbeProgress(
                    state:
                        probeProgress.value ??
                        const GhostLockProbeProgress(
                          phase: 0,
                          done: 0,
                          total: 0,
                        ),
                  ),
                ],
                if (probeError.value != null && !probing.value) ...<Widget>[
                  SizedBox(height: 12.h),
                  _CopyableError(
                    text: l10n.kernelProfileProbeFailed(probeError.value!),
                  ),
                  if (failedAnalysis.value != null) ...<Widget>[
                    SizedBox(height: 6.h),
                    KernelProfileAnalysisButton(
                      text: failedAnalysis.value!,
                      enabled: !anyBusy,
                    ),
                  ],
                ],
                if (probed != null && !probing.value) ...<Widget>[
                  SizedBox(height: 16.h),
                  KernelProfileProbeCard(
                    probe: probed,
                    enabled: !anyBusy,
                    /* GhostKey 没有 route 概念，隐藏 GhostLock 的几何诊断。 */
                    routeDiagnostics: ghostLockTarget,
                  ),
                ],
                if (busy.value) ...<Widget>[
                  SizedBox(height: 14.h),
                  SizedBox(
                    height: 36.h,
                    child: const LinearProgressIndicator(),
                  ),
                ],
                if (ghostKeyImport != null) ...<Widget>[
                  SizedBox(height: 14.h),
                  _ImportProgress(state: keyState),
                  if (ghostKeyImport.hasError) ...<Widget>[
                    SizedBox(height: 8.h),
                    _CopyableError(
                      text:
                          '${l10n.kernelProfileImportFailed}: '
                          '${ghostKeyImport.error}',
                    ),
                  ],
                  if (keyState != null && keyState.finished) ...<Widget>[
                    SizedBox(height: 8.h),
                    _ImportResult(state: keyState),
                  ],
                ],
                if (doneText.value != null && !anyBusy) ...<Widget>[
                  SizedBox(height: 10.h),
                  Text(
                    doneText.value!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      height: 1.4,
                      color: scheme.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        // ---- 固定底部操作栏 ----
        Container(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: scheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              height: 44.h,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: probed == null
                        ? FilledButton.icon(
                            onPressed: anyBusy || imageInput.value.isEmpty
                                ? null
                                : parse,
                            icon: probing.value
                                ? SizedBox(
                                    width: 16.r,
                                    height: 16.r,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Icon(
                                    Icons.playlist_add_check_rounded,
                                    size: 18.r,
                                  ),
                            label: Text(l10n.kernelProfileImportParseAction),
                          )
                        : FilledButton.icon(
                            onPressed: anyBusy
                                ? null
                                : () => saveToTarget(probed),
                            icon: Icon(Icons.save_alt_rounded, size: 18.r),
                            label: Text(
                              l10n.kernelProfileWriteToTarget(targetName),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                  ),
                  /* 解析完成后才出现的导出图标。 */
                  if (ghostLockTarget && parsed.value) ...<Widget>[
                    SizedBox(width: 8.w),
                    IconButton.filledTonal(
                      onPressed: anyBusy ? null : exportImages,
                      tooltip: l10n.kernelImageExport,
                      icon: Icon(Icons.download_rounded, size: 20.r),
                      style: IconButton.styleFrom(
                        minimumSize: Size(44.r, 44.r),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<bool?> _confirmOverwrite(BuildContext context) => showDialog<bool>(
    context: context,
    builder: (BuildContext dialogContext) {
      final AppLocalizations l10n = dialogContext.l10n;
      return AlertDialog(
        title: Text(l10n.escalationGhostLockImportTitle),
        content: Text(l10n.escalationGhostLockImportOverwrite),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.aiCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.escalationGhostLockImportOverwriteAction),
          ),
        ],
      );
    },
  );
}

/// 阶段名 + 字节进度 + 进度条；非下载相位用不确定进度条。
class _ImportProgress extends HookWidget {
  const _ImportProgress({required this.state});

  final KernelProfileImportState? state;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    final KernelProfileImportState? current = state;
    final int phase = current?.phase ?? KernelProfileImportState.phaseLocate;
    final String? bytes = current == null
        ? null
        : kernelProfileByteProgress(context.l10n, current);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                kernelProfilePhaseLabel(context.l10n, phase),
                style: TextStyle(
                  fontSize: 11.5.sp,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
            Text(
              bytes ??
                  (current?.finished ?? false
                      ? '100%'
                      : '${((current?.fraction ?? 0) * 100).round()}%'),
              style: TextStyle(
                fontSize: 11.5.sp,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(3.r),
          child: LinearProgressIndicator(
            // 只有下载相位知道总量；定位/解析/写入用不确定动画表示仍在进行。
            value: current == null
                ? null
                : current.finished
                ? 1
                : current.determinate
                ? current.fraction
                : null,
            minHeight: 4.h,
            backgroundColor: scheme.surfaceContainerHigh,
          ),
        ),
      ],
    );
  }
}

/// 导入终态结果条：成功显示 release，失败显示错误码文案 + 原始详情。
class _ImportResult extends HookWidget {
  const _ImportResult({required this.state});

  final KernelProfileImportState state;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    if (state.result.ok) {
      return Text(
        l10n.kernelProfileImportSuccess(state.result.release),
        style: TextStyle(fontSize: 12.sp, height: 1.4, color: scheme.primary),
      );
    }
    return _CopyableError(
      text:
          '${l10n.kernelProfileImportFailed}: '
          '${kernelProfileErrorText(l10n, state)}',
    );
  }
}

/// 错误文本 + 一键复制按钮。
///
/// 解析失败的原因常要贴到别处排查，长按选区在弹层里不好用，这里直接给复制按钮。
class _CopyableError extends StatelessWidget {
  const _CopyableError({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: SelectableText(
            text,
            style: TextStyle(fontSize: 12.sp, height: 1.4, color: scheme.error),
          ),
        ),
        IconButton(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: text));
            if (context.mounted) {
              ToastMessage.success(l10n.kernelProfileErrorCopied);
            }
          },
          tooltip: l10n.kernelProfileErrorCopy,
          icon: Icon(Icons.copy_rounded, size: 15.sp),
          visualDensity: VisualDensity.compact,
          constraints: BoxConstraints(minWidth: 28.w, minHeight: 28.h),
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
