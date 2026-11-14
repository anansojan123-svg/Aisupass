import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/kernel_image_picker.dart';
import 'package:Aisupass/features/escalation/domain/enums/kernel_image_source.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/ota_catalog_sheet.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 示例链接：realme RMX5062 全量 OTA（服务端支持 Range）。
const String kSampleBtfOtaUrl =
    'https://rbp01.realme.net/RMX5062/1339_sign_RMX5062_11_A_OTA_0480_all_CAf8wi_10010111.zip';

/// 镜像解析的输入源；本地文件优先于直链。
class KernelImageInput {
  const KernelImageInput({this.path, this.url = '', this.insecure = false});

  /// 本地镜像 / OTA 包路径。
  final String? path;

  /// OTA 直链。
  final String url;

  /// 直链下载时跳过证书校验。
  final bool insecure;

  /// 没有任何输入源。
  bool get isEmpty => (path == null || path!.isEmpty) && url.trim().isEmpty;

  /// 交给解析器的输入：本地文件优先。
  String get value => path ?? url.trim();

  /// 输入是 OTA / payload 包（本地 zip 或直链）。
  bool get fromPackage => path != null
      ? path!.toLowerCase().endsWith('.zip')
      : url.trim().toLowerCase().startsWith('http');

  KernelImageInput copyWith({
    String? path,
    bool clearPath = false,
    String? url,
    bool? insecure,
  }) => KernelImageInput(
    path: clearPath ? null : (path ?? this.path),
    url: url ?? this.url,
    insecure: insecure ?? this.insecure,
  );
}

/// 已选文件的路径条，可清除。
class KernelProfileInputChip extends HookWidget {
  const KernelProfileInputChip({
    super.key,
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
    /* 长路径尾部才是文件名，按文件名展示，完整路径放 tooltip。 */
    final String name = text.split('/').last;
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
            child: Tooltip(
              message: text,
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5.sp,
                  color: scheme.onSurfaceVariant,
                ),
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

/// 内核表镜像的公共输入层：选镜像 / 导入现成配置 / 直链。
///
/// 只负责收集与校验输入，不触发解析——解析动作由各自的内核表页面注入。
class KernelImageInputSection extends HookWidget {
  const KernelImageInputSection({
    super.key,
    required this.input,
    required this.enabled,
    required this.onChanged,
    required this.onImportExisting,
    required this.onSubmit,
  });

  final KernelImageInput input;
  final bool enabled;
  final ValueChanged<KernelImageInput> onChanged;

  /// 导入现成的 HOCON / JSON 内核表；由调用方接自己的落点。
  final VoidCallback onImportExisting;

  /// 直链输入框回车触发解析。
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final bool isDark = context.isDark;
    final TextEditingController urlController = useTextEditingController(
      text: input.url,
    );

    /* 已有本地文件时固定落在本地段；否则沿用用户上次选择。 */
    final ValueNotifier<KernelImageSource> source = useState<KernelImageSource>(
      input.path != null || input.url.trim().isEmpty
          ? KernelImageSource.local
          : KernelImageSource.url,
    );

    /* 外部粘贴或从目录选链接后，输入框要跟着变。 */
    useEffect(() {
      if (urlController.text != input.url) {
        urlController.value = TextEditingValue(
          text: input.url,
          selection: TextSelection.collapsed(offset: input.url.length),
        );
      }
      return null;
    }, <Object?>[input.url]);

    useEffect(() {
      if (input.path != null && source.value != KernelImageSource.local) {
        source.value = KernelImageSource.local;
      }
      return null;
    }, <Object?>[input.path]);

    /* 两种来源互斥：切换时清掉另一侧，避免解析到看不见的旧输入。 */
    void switchSource(KernelImageSource next) {
      if (next == source.value) return;
      source.value = next;
      switch (next) {
        case KernelImageSource.local:
          onChanged(input.copyWith(url: ''));
        case KernelImageSource.url:
          onChanged(input.copyWith(clearPath: true));
      }
    }

    Future<void> pickInput() async {
      final FilePickerResult? picked;
      try {
        picked = await FilePicker.pickFiles(
          type: FileType.custom,
          allowedExtensions: kernelImageExtensions.toList(),
          withData: false,
        );
      } catch (error) {
        ToastMessage.error(error);
        return;
      }
      final String? path = picked?.files.firstOrNull?.path;
      if (path == null) return;
      if (!hasAllowedExtension(path, kernelImageExtensions)) {
        ToastMessage.error(l10n.kernelProfileImportUnsupportedImage);
        return;
      }
      if (!isReadableFile(path)) {
        ToastMessage.error(l10n.kernelProfileImportEmptyFile);
        return;
      }
      onChanged(KernelImageInput(path: path, insecure: input.insecure));
    }

    /* 本地与直链两组控件互斥，避免一屏堆满无关输入。 */
    final bool localMode = source.value == KernelImageSource.local;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SegmentedButton<KernelImageSource>(
          segments: <ButtonSegment<KernelImageSource>>[
            ButtonSegment<KernelImageSource>(
              value: KernelImageSource.local,
              icon: Icon(Icons.folder_open_rounded, size: 16.r),
              label: Text(l10n.kernelProfileInputSourceLocal),
            ),
            ButtonSegment<KernelImageSource>(
              value: KernelImageSource.url,
              icon: Icon(Icons.link_rounded, size: 16.r),
              label: Text(l10n.kernelProfileInputSourceUrl),
            ),
          ],
          selected: <KernelImageSource>{source.value},
          showSelectedIcon: false,
          expandedInsets: EdgeInsets.zero,
          onSelectionChanged: enabled
              ? (Set<KernelImageSource> picked) => switchSource(picked.first)
              : null,
        ),
        SizedBox(height: 12.h),
        if (localMode) ...<Widget>[
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: enabled ? pickInput : null,
              icon: Icon(Icons.folder_open_rounded, size: 18.r),
              label: Text(
                input.path == null
                    ? l10n.kernelProfileImportAction
                    : l10n.kernelProfileImportChangeFile,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (input.path != null) ...<Widget>[
            SizedBox(height: 6.h),
            KernelProfileInputChip(
              icon: Icons.insert_drive_file_outlined,
              text: input.path!,
              onClear: enabled
                  ? () => onChanged(input.copyWith(clearPath: true))
                  : null,
            ),
          ],
        ] else ...<Widget>[
          TextField(
            controller: urlController,
            enabled: enabled,
            onChanged: (String value) => onChanged(input.copyWith(url: value)),
            onSubmitted: (_) => onSubmit(),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.go,
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
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: scheme.outline.withValues(alpha: isDark ? 0.28 : 0.16),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: scheme.outline.withValues(alpha: isDark ? 0.28 : 0.16),
                ),
              ),
            ),
          ),
          SizedBox(height: 4.h),
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
                value: input.insecure,
                onChanged: enabled
                    ? (bool value) => onChanged(input.copyWith(insecure: value))
                    : null,
              ),
            ],
          ),
          SizedBox(height: 4.h),
          _BtfHint(
            enabled: enabled,
            onBrowseCatalog: () => showOtaCatalogSheet(
              context,
              onPick: (String url) =>
                  onChanged(input.copyWith(url: url, clearPath: true)),
            ),
            onPasteExample: () => onChanged(
              input.copyWith(url: kSampleBtfOtaUrl, clearPath: true),
            ),
          ),
        ],
        SizedBox(height: 10.h),
        Divider(height: 1, color: scheme.outlineVariant.withValues(alpha: 0.5)),
        SizedBox(height: 4.h),
        /* 跳过解析、直接写入现成 profile 的独立路径。 */
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: enabled ? onImportExisting : null,
            icon: Icon(Icons.file_present_rounded, size: 16.r),
            label: Text(
              l10n.escalationGhostLockImportText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              minimumSize: Size(0, 34.h),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              textStyle: TextStyle(fontSize: 12.5.sp),
            ),
          ),
        ),
      ],
    );
  }
}

/// URL 输入框下方的提示行：为什么需要 BTF、粘贴示例、原理解释。
class _BtfHint extends StatelessWidget {
  const _BtfHint({
    required this.enabled,
    required this.onPasteExample,
    required this.onBrowseCatalog,
  });

  final bool enabled;
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
              onPressed: enabled ? onBrowseCatalog : null,
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
              onPressed: enabled ? onPasteExample : null,
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
