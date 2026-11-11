import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/kernel_profile_text.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile_import_state.dart';
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

/// boot.img 导入面板：选择文件 + 进度条 + 结果条。
///
/// 自己持有本次选中的临时路径并订阅导入流；导入成功后失效 profile 列表，
/// 页面只负责渲染列表。
class KernelProfileImportPanel extends HookConsumerWidget {
  const KernelProfileImportPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final bool isDark = context.isDark;
    final ValueNotifier<String?> importPath = useState<String?>(null);
    final ValueNotifier<String?> importUrl = useState<String?>(null);
    final ValueNotifier<String> urlText = useState<String>('');
    final TextEditingController urlController = useTextEditingController();
    // 同一个 release 只刷新一次列表，避免进度块反复触发 invalidate。
    final ObjectRef<String> handledRelease = useRef<String>('');
    final AsyncValue<KernelProfileImportState>? importing =
        importPath.value != null
        ? ref.watch(importKernelProfileProvider(path: importPath.value!))
        : importUrl.value != null
        ? ref.watch(importKernelProfileFromUrlProvider(url: importUrl.value!))
        : null;

    useEffect(() {
      final KernelProfileImportState? state = importing?.value;
      if (state == null) return null;
      if (state.finished &&
          state.result.ok &&
          handledRelease.value != state.result.release) {
        handledRelease.value = state.result.release;
        ref.invalidate(kernelProfileListProvider);
      }
      return null;
    }, <Object?>[importing]);

    Future<void> pickAndImport() async {
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
      handledRelease.value = '';
      importUrl.value = null;
      importPath.value = path;
      ref.invalidate(importKernelProfileProvider(path: path));
    }

    Future<void> browseCatalog() => showOtaCatalogSheet(
      context,
      onPick: (String url) {
        urlController.value = TextEditingValue(
          text: url,
          selection: TextSelection.collapsed(offset: url.length),
        );
        urlText.value = url;
      },
    );

    void startUrlImport() {
      final String url = urlText.value.trim();
      if (url.isEmpty) return;
      FocusScope.of(context).unfocus();
      handledRelease.value = '';
      importPath.value = null;
      importUrl.value = url;
      ref.invalidate(importKernelProfileFromUrlProvider(url: url));
    }

    final KernelProfileImportState? state = importing?.value;
    final BorderRadius radius = BorderRadius.circular(12.r);
    final BorderSide side = BorderSide(
      color: scheme.outline.withValues(alpha: isDark ? 0.28 : 0.16),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FilledButton.icon(
          onPressed: pickAndImport,
          icon: Icon(Icons.folder_open_rounded, size: 18.r),
          label: Text(l10n.kernelProfileImportAction),
        ),
        SizedBox(height: 12.h),
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: urlController,
                onChanged: (String value) => urlText.value = value,
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.go,
                onSubmitted: (_) => startUrlImport(),
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
            SizedBox(width: 8.w),
            FilledButton.tonal(
              onPressed: urlText.value.trim().isEmpty ? null : startUrlImport,
              child: Text(l10n.kernelProfileImportUrlAction),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        _BtfHint(
          onBrowseCatalog: browseCatalog,
          onPasteExample: () {
            urlController.value = TextEditingValue(
              text: kSampleBtfOtaUrl,
              selection: TextSelection.collapsed(
                offset: kSampleBtfOtaUrl.length,
              ),
            );
            urlText.value = kSampleBtfOtaUrl;
          },
        ),
        if (importing != null) ...<Widget>[
          SizedBox(height: 14.h),
          _ImportProgress(state: state),
          if (importing.hasError) ...<Widget>[
            SizedBox(height: 8.h),
            SelectableText(
              '${l10n.kernelProfileImportFailed}: ${importing.error}',
              style: TextStyle(fontSize: 12.sp, height: 1.4, color: scheme.error),
            ),
          ],
          if (state != null && state.finished) ...<Widget>[
            SizedBox(height: 8.h),
            _ImportResult(state: state),
          ],
        ],
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
              constraints: BoxConstraints(
                minWidth: 24.w,
                minHeight: 24.h,
              ),
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
