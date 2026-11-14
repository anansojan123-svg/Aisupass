import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/kernel_image_picker.dart';
import 'package:Aisupass/core/utils/kernel_profile_text.dart';
import 'package:Aisupass/features/escalation/domain/enums/kernel_profile_import_target.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_probe.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_probe_progress.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile_import_state.dart';
import 'package:Aisupass/features/escalation/presentation/controllers/kernel_profile_import_controller.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/kernel_profile_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/kernel_profile_query_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_image_input_section.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_image_export_sheet.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_attach_section.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_import_bottom_bar.dart';
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

    final KernelProfileImportController controller = useMemoized(
      () => KernelProfileImportController(
        ref: ref,
        l10n: l10n,
        pickFiles:
            ({
              required List<String> extensions,
              required bool allowMultiple,
              required bool withData,
            }) async {
              final FilePickerResult? result = await FilePicker.pickFiles(
                type: FileType.custom,
                allowedExtensions: extensions,
                allowMultiple: allowMultiple,
                withData: withData,
              );
              return result?.files;
            },
        confirmOverwrite: () async =>
            (await _confirmOverwrite(context)) ?? false,
        notify: (String text, ImportNotice notice) {
          switch (notice) {
            case ImportNotice.success:
              ToastMessage.success(text);
            case ImportNotice.warning:
              ToastMessage.warning(text);
            case ImportNotice.error:
              ToastMessage.error(text);
          }
        },
      ),
      <Object?>[l10n],
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
      final String path = await controller.pickImage();
      if (path.isEmpty) return;
      slot.value = path;
      invalidateProbe();
    }

    /// 选择外部 kallsyms / iomem 文本文件。
    Future<void> pickText(ValueNotifier<String?> slot) async {
      final String path = await controller.pickText();
      if (path.isEmpty) return;
      slot.value = path;
      invalidateProbe();
    }

    /// 打开镜像导出弹层。
    Future<void> exportImages() async {
      final List<String> paths = await controller.collectExportPaths(
        bootPath: probe.value?.bootPath ?? lastBootPath.value,
        attachPaths: <String>[
          xblPath.value ?? '',
          uefiPath.value ?? '',
          vendorBootPath.value ?? '',
        ],
      );
      if (!context.mounted) return;
      await showKernelImageExportSheet(context, paths: paths);
    }

    /// 直接导入现成的 HOCON / JSON 内核表。
    Future<void> importExisting() async {
      busy.value = true;
      doneText.value = null;
      try {
        final KernelImportOutcome outcome = await controller.importExisting();
        if (!outcome.ok) return;
        doneText.value = l10n.escalationGhostLockImportDone(outcome.release);
        await controller.autoLoadSaved(outcome);
      } finally {
        busy.value = false;
      }
    }

    Future<void> parse() async {
      final KernelImageInput input = imageInput.value;
      FocusScope.of(context).unfocus();
      probing.value = true;
      probe.value = null;
      probeError.value = null;
      failedAnalysis.value = null;
      doneText.value = null;
      try {
        final KernelImportParseOutcome outcome = await controller.parse(
          hasInput: !input.isEmpty,
          readable: input.path == null || isReadableFile(input.path!),
          probe: () => ref
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
              ),
        );
        final GhostLockProbe? result = outcome.probe;
        if (result == null) {
          probeError.value = outcome.error.isEmpty ? null : outcome.error;
          failedAnalysis.value = outcome.analysis.isEmpty
              ? null
              : outcome.analysis;
          return;
        }
        probe.value = result;
        lastBootPath.value = result.bootPath;
        /* 只有解析成功才亮出导出图标。 */
        parsed.value = true;
      } finally {
        probing.value = false;
      }
    }

    /// 按当前目标写入：GhostLock 落盘，GhostKey 交给自己的解析链路。
    Future<void> saveToTarget(GhostLockProbe result) async {
      if (!context.mounted) return;
      busy.value = true;
      try {
        switch (target.value) {
          case KernelProfileImportTarget.ghostLock:
            final KernelImportOutcome outcome = await controller
                .saveToGhostLock(result);
            if (!outcome.ok) return;
            doneText.value = l10n.escalationGhostLockImportDone(
              outcome.release,
            );
            probe.value = null;
            await controller.autoLoadSaved(outcome);
            if (context.mounted) {
              Navigator.of(context).pop(KernelProfileImportTarget.ghostLock);
            }
          case KernelProfileImportTarget.ghostKey:
            final ({String path, String url}) source = controller
                .importToGhostKey(
                  result: result,
                  fallbackPath: imageInput.value.path ?? '',
                  url: imageInput.value.url,
                );
            handledRelease.value = '';
            doneText.value = null;
            probe.value = null;
            ghostKeyPath.value = source.path.isEmpty ? null : source.path;
            ghostKeyUrl.value = source.url.isEmpty ? null : source.url;
        }
      } finally {
        busy.value = false;
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
        KernelProfileImportBottomBar(
          probed: probed != null,
          anyBusy: anyBusy,
          probing: probing.value,
          parsed: parsed.value,
          ghostLockTarget: ghostLockTarget,
          inputEmpty: imageInput.value.isEmpty,
          targetName: targetName,
          onParse: parse,
          onSave: () {
            if (probed != null) saveToTarget(probed);
          },
          onExport: exportImages,
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
