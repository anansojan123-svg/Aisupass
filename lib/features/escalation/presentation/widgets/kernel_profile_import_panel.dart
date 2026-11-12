import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/kernel_profile_text.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_import_result.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_probe.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_probe_progress.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile_import_state.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/kernel_profile_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/kernel_profile_query_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/ota_catalog_sheet.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 示例链接：Pixel 8 Pro（GKI 内核，带 BTF，且服务端支持 Range）。
const String kSampleBtfOtaUrl =
    'https://release.calyxos.org/ota/husky/17/husky-ota_update-260800450.zip';

/// 解析后要导入到哪个漏洞。
enum _ImportTarget { ghostKey, ghostLock }

/// 内核表导入面板：选镜像 / 填直链 → 解析 → 点击结果卡片选落点。
///
/// 解析与落点解耦：解析由 GhostLock 的提取器完成（不落盘），得到 release 与
/// 自包含文本后才问用户要写进哪一套内核表。
class KernelProfileImportPanel extends HookConsumerWidget {
  const KernelProfileImportPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final bool isDark = context.isDark;

    final ValueNotifier<String?> inputPath = useState<String?>(null);
    final ValueNotifier<String> urlText = useState<String>('');
    final TextEditingController urlController = useTextEditingController();
    final ValueNotifier<bool> insecure = useState<bool>(false);

    // 解析：只出文本，不落盘。
    final ValueNotifier<bool> probing = useState<bool>(false);
    final ValueNotifier<GhostLockProbe?> probe = useState<GhostLockProbe?>(null);
    final ValueNotifier<String?> probeError = useState<String?>(null);

    // 落盘与 GhostKey 导入。
    final ValueNotifier<bool> busy = useState<bool>(false);
    final ValueNotifier<String?> doneText = useState<String?>(null);
    final ValueNotifier<String?> ghostKeyPath = useState<String?>(null);
    final ValueNotifier<String?> ghostKeyUrl = useState<String?>(null);
    final ObjectRef<String> handledRelease = useRef<String>('');

    final AsyncValue<KernelProfileImportState>? ghostKeyImport =
        ghostKeyPath.value != null
        ? ref.watch(importKernelProfileProvider(path: ghostKeyPath.value!))
        : ghostKeyUrl.value != null
        ? ref.watch(
            importKernelProfileFromUrlProvider(url: ghostKeyUrl.value!),
          )
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
      }
      return null;
    }, <Object?>[ghostKeyImport]);

    /// 当前输入源；本地文件优先。
    String currentInput() =>
        inputPath.value ?? urlText.value.trim();

    Future<void> parse() async {
      final String input = currentInput();
      if (input.isEmpty) {
        ToastMessage.warning(l10n.kernelProfileImportNeedInput);
        return;
      }
      FocusScope.of(context).unfocus();
      probing.value = true;
      probe.value = null;
      probeError.value = null;
      doneText.value = null;
      try {
        final GhostLockProbe result = await ref
            .read(ghostLockProfileActionsProvider)
            .probeProfile(input: input, insecure: insecure.value);
        if (result.ok) {
          probe.value = result;
        } else {
          probeError.value = result.reason;
        }
      } catch (error) {
        probeError.value = error.toString();
      } finally {
        probing.value = false;
      }
    }

    Future<void> pickInput() async {
      final FilePickerResult? picked;
      try {
        picked = await FilePicker.pickFiles(
          type: FileType.custom,
          allowedExtensions: <String>['img', 'bin', 'zip'],
          withData: false,
        );
      } catch (error) {
        ToastMessage.error(error);
        return;
      }
      final String? path = picked?.files.firstOrNull?.path;
      if (path == null) return;
      inputPath.value = path;
      urlText.value = '';
      urlController.clear();
      probe.value = null;
      probeError.value = null;
      doneText.value = null;
    }

    Future<void> saveToGhostLock(GhostLockProbe result) async {
      busy.value = true;
      try {
        final GhostLockImportResult saved = await ref
            .read(ghostLockProfileActionsProvider)
            .saveProfile(release: result.release, conf: result.conf);
        if (saved.ok) {
          doneText.value = l10n.escalationGhostLockImportDone(saved.release);
          probe.value = null;
          return;
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
            } else {
              ToastMessage.error(
                l10n.escalationGhostLockImportFailed(retry.reason),
              );
            }
          }
          return;
        }
        ToastMessage.error(
          l10n.escalationGhostLockImportFailed(saved.reason),
        );
      } catch (error) {
        ToastMessage.error(error);
      } finally {
        busy.value = false;
      }
    }

    /// 把解析过的镜像交给 GhostKey。
    ///
    /// GhostKey 走自己的 Kotlin 解析链路（表结构不同），但可以复用 probe 已
    /// 解出的 boot 文件，避免再下载一次整个 OTA。
    void importToGhostKey(GhostLockProbe result) {
      final String local = result.bootPath.isNotEmpty
          ? result.bootPath
          : inputPath.value ?? '';
      handledRelease.value = '';
      doneText.value = null;
      probe.value = null;
      ghostKeyUrl.value = null;
      ghostKeyPath.value = local.isEmpty ? null : local;
      if (local.isEmpty) {
        ghostKeyUrl.value = urlText.value.trim();
        ref.invalidate(
          importKernelProfileFromUrlProvider(url: ghostKeyUrl.value!),
        );
        return;
      }
      ref.invalidate(importKernelProfileProvider(path: local));
    }

    Future<void> chooseTarget(GhostLockProbe result) async {
      if (!context.mounted) return;
      final _ImportTarget? target = await showModalBottomSheet<_ImportTarget>(
        context: context,
        builder: (BuildContext sheetContext) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 4.h),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.kernelProfileChooseTargetTitle(result.release),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.vpn_key_rounded),
                title: Text(l10n.kernelProfileChooseTargetGhostKey),
                subtitle: Text(l10n.kernelProfileChooseTargetGhostKeyHint),
                onTap: () =>
                    Navigator.of(sheetContext).pop(_ImportTarget.ghostKey),
              ),
              ListTile(
                leading: const Icon(Icons.lock_rounded),
                title: Text(l10n.kernelProfileChooseTargetGhostLock),
                subtitle: Text(l10n.kernelProfileChooseTargetGhostLockHint),
                onTap: () =>
                    Navigator.of(sheetContext).pop(_ImportTarget.ghostLock),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      );
      if (target == null) return;
      switch (target) {
        case _ImportTarget.ghostLock:
          await saveToGhostLock(result);
        case _ImportTarget.ghostKey:
          importToGhostKey(result);
      }
    }

    final GhostLockProbe? probed = probe.value;
    final KernelProfileImportState? keyState = ghostKeyImport?.value;
    final BorderRadius radius = BorderRadius.circular(12.r);
    final BorderSide side = BorderSide(
      color: scheme.outline.withValues(alpha: isDark ? 0.28 : 0.16),
    );
    final bool anyBusy = probing.value || busy.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // ---- 输入源 ----
        Row(
          children: <Widget>[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: anyBusy ? null : pickInput,
                icon: Icon(Icons.folder_open_rounded, size: 18.r),
                label: Text(
                  inputPath.value == null
                      ? l10n.kernelProfileImportAction
                      : l10n.kernelProfileImportChangeFile,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        if (inputPath.value != null) ...<Widget>[
          SizedBox(height: 6.h),
          _InputChip(
            icon: Icons.insert_drive_file_outlined,
            text: inputPath.value!,
            onClear: anyBusy
                ? null
                : () {
                    inputPath.value = null;
                    probe.value = null;
                    probeError.value = null;
                    doneText.value = null;
                  },
          ),
        ],
        SizedBox(height: 12.h),
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: urlController,
                onChanged: (String value) => urlText.value = value,
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.go,
                onSubmitted: (_) => parse(),
                style: TextStyle(fontSize: 13.sp, color: scheme.onSurface),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: l10n.kernelProfileImportUrlHint,
                  hintStyle: TextStyle(
                    fontSize: 13.sp,
                    color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                  prefixIcon: Icon(
                    Icons.link_rounded,
                    size: 18.sp,
                    color: scheme.onSurfaceVariant,
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 36.w,
                    minHeight: 36.h,
                  ),
                  filled: true,
                  fillColor: isDark
                      ? scheme.onSurface.withValues(alpha: 0.04)
                      : scheme.surfaceContainerHighest.withValues(alpha: 0.35),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  border: OutlineInputBorder(
                    borderRadius: radius,
                    borderSide: side,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: radius,
                    borderSide: side,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                l10n.kernelProfileImportInsecureHint,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
            Switch(
              value: insecure.value,
              onChanged: anyBusy
                  ? null
                  : (bool value) => insecure.value = value,
            ),
          ],
        ),
        SizedBox(height: 4.h),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: anyBusy || currentInput().isEmpty ? null : parse,
            icon: Icon(Icons.playlist_add_check_rounded, size: 18.r),
            label: Text(l10n.kernelProfileImportParseAction),
          ),
        ),
        SizedBox(height: 6.h),
        _BtfHint(
          onBrowseCatalog: () => showOtaCatalogSheet(
            context,
            onPick: (String url) {
              urlController.value = TextEditingValue(
                text: url,
                selection: TextSelection.collapsed(offset: url.length),
              );
              urlText.value = url;
              inputPath.value = null;
            },
          ),
          onPasteExample: () {
            urlController.value = TextEditingValue(
              text: kSampleBtfOtaUrl,
              selection: TextSelection.collapsed(
                offset: kSampleBtfOtaUrl.length,
              ),
            );
            urlText.value = kSampleBtfOtaUrl;
            inputPath.value = null;
          },
        ),
        if (probing.value) ...<Widget>[
          SizedBox(height: 14.h),
          _ProbeProgress(
            state:
                probeProgress.value ??
                const GhostLockProbeProgress(phase: 0, done: 0, total: 0),
          ),
        ],
        if (probeError.value != null && !probing.value) ...<Widget>[
          SizedBox(height: 10.h),
          SelectableText(
            l10n.kernelProfileProbeFailed(probeError.value!),
            style: TextStyle(fontSize: 12.sp, height: 1.4, color: scheme.error),
          ),
        ],
        if (probed != null && !probing.value) ...<Widget>[
          SizedBox(height: 14.h),
          _ProbeCard(
            probe: probed,
            enabled: !anyBusy,
            onTap: () => chooseTarget(probed),
          ),
        ],
        if (busy.value) ...<Widget>[
          SizedBox(height: 14.h),
          SizedBox(height: 36.h, child: const LinearProgressIndicator()),
        ],
        if (ghostKeyImport != null) ...<Widget>[
          SizedBox(height: 14.h),
          _ImportProgress(state: keyState),
          if (ghostKeyImport.hasError) ...<Widget>[
            SizedBox(height: 8.h),
            SelectableText(
              '${l10n.kernelProfileImportFailed}: ${ghostKeyImport.error}',
              style: TextStyle(
                fontSize: 12.sp,
                height: 1.4,
                color: scheme.error,
              ),
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
            style: TextStyle(fontSize: 12.sp, height: 1.4, color: scheme.primary),
          ),
        ],
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

/// 已选镜像的路径条，可清除。
class _InputChip extends HookWidget {
  const _InputChip({
    required this.icon,
    required this.text,
    required this.onClear,
  });

  final IconData icon;
  final String text;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 15.sp, color: scheme.onSurfaceVariant),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5.sp,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
          IconButton(
            onPressed: onClear,
            icon: Icon(Icons.close_rounded, size: 15.sp),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: 24.w, minHeight: 24.h),
          ),
        ],
      ),
    );
  }
}

/// 解析结果卡片：绿色光晕 + 点击选落点。
class _ProbeCard extends HookWidget {
  const _ProbeCard({
    required this.probe,
    required this.enabled,
    required this.onTap,
  });

  final GhostLockProbe probe;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final double glow = enabled ? 0.30 : 0.10;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        color: scheme.primaryContainer.withValues(alpha: enabled ? 0.45 : 0.2),
        border: Border.all(
          color: scheme.primary.withValues(alpha: enabled ? 0.55 : 0.2),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: scheme.primary.withValues(alpha: glow),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.check_circle_rounded,
                    size: 17.sp,
                    color: scheme.primary,
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      l10n.kernelProfileProbeReady,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: scheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              SelectableText(
                probe.release,
                style: TextStyle(
                  fontSize: 12.5.sp,
                  height: 1.4,
                  color: scheme.onSurface,
                ),
              ),
              if (probe.warnings.isNotEmpty) ...<Widget>[
                SizedBox(height: 4.h),
                Text(
                  l10n.kernelProfileProbeWarnings(probe.warnings.length),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
              SizedBox(height: 8.h),
              Row(
                children: <Widget>[
                  Text(
                    l10n.kernelProfileProbeTapHint,
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w600,
                      color: scheme.primary,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 16.sp,
                    color: scheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// GhostLock 解析进度：阶段名 + 百分比 + 进度条。
///
/// 下载阶段有字节总量，进度条走确定值；解包与解析阶段没有总量，用不确定动画。
class _ProbeProgress extends HookWidget {
  const _ProbeProgress({required this.state});

  final GhostLockProbeProgress state;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final bool determinate = state.total > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                state.downloading
                    ? l10n.kernelProfilePhaseRead
                    : l10n.kernelProfilePhaseParse,
                style: TextStyle(
                  fontSize: 11.5.sp,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
            Text(
              determinate ? '${(state.fraction * 100).round()}%' : '',
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
            value: determinate ? state.fraction : null,
            minHeight: 4.h,
            backgroundColor: scheme.surfaceContainerHigh,
          ),
        ),
      ],
    );
  }
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
///
/// 失败内容用 [SelectableText]：错误详情可能较长（含 content-type、服务端
/// 能力判断等），用户要能选中复制去排查。
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
    return SelectableText(
      '${l10n.kernelProfileImportFailed}: '
      '${kernelProfileErrorText(l10n, state)}',
      style: TextStyle(fontSize: 12.sp, height: 1.4, color: scheme.error),
    );
  }
}

/// URL 输入框下方的提示行：为什么需要 BTF、粘贴示例、原理解释。
class _BtfHint extends HookWidget {
  const _BtfHint({
    required this.onPasteExample,
    required this.onBrowseCatalog,
  });

  final VoidCallback onPasteExample;
  final VoidCallback onBrowseCatalog;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          l10n.kernelProfileBtfHint,
          style: TextStyle(
            fontSize: 11.sp,
            height: 1.4,
            color: scheme.onSurfaceVariant,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              onPressed: onBrowseCatalog,
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                l10n.otaCatalogBrowseAction,
                style: TextStyle(fontSize: 11.sp),
              ),
            ),
            TextButton(
              onPressed: onPasteExample,
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                l10n.kernelProfilePasteExample,
                style: TextStyle(fontSize: 11.sp),
              ),
            ),
            IconButton(
              onPressed: () => _showWhyDialog(context),
              icon: Icon(
                Icons.help_outline_rounded,
                size: 15.sp,
                color: scheme.onSurfaceVariant,
              ),
              tooltip: l10n.kernelProfileWhyBtfTitle,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(minWidth: 24.w, minHeight: 24.h),
            ),
          ],
        ),
      ],
    );
  }

  void _showWhyDialog(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(l10n.kernelProfileWhyBtfTitle),
        content: SingleChildScrollView(
          child: Text(
            l10n.kernelProfileWhyBtfBody,
            style: const TextStyle(fontSize: 13, height: 1.6),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.kernelProfileDialogClose),
          ),
        ],
      ),
    );
  }
}
