import 'dart:async';

import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/core/constants/app_links.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/providers/asset_bundle_provider.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// 开源许可页：本项目协议、第三方声明与各许可证全文。
///
/// 文本全部来自包内资源，离线可读。
class OpenSourceLicensePage extends HookConsumerWidget {
  const OpenSourceLicensePage({super.key, this.initialDoc});

  /// 首次进入时选中的文档下标，对应 [AppLinks.licenseDocAssets]；null 取第一篇。
  final int? initialDoc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final AssetBundle bundle = ref.watch(assetBundleProvider);
    final ValueNotifier<int> selected = useState<int>(
      _clampDoc(initialDoc),
    );
    final String asset = AppLinks.licenseDocAssets[selected.value];

    final AsyncSnapshot<String> text = useFuture(
      useMemoized(() => bundle.loadString(asset), <Object?>[asset, bundle]),
    );

    final List<String> titles = <String>[
      l10n.licenseDocProjectTitle,
      l10n.licenseDocThirdPartyTitle,
      l10n.licenseDocApacheTitle,
      l10n.licenseDocGpl2Title,
    ];

    final Widget content;
    if (text.hasError) {
      content = Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Text(
            l10n.openSourceLicenseLoadFailed,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    } else if (!text.hasData) {
      content = const Loading();
    } else {
      content = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isDesktopPlatform ? 760 : double.infinity,
          ),
          child: _isMarkdown(asset)
              ? SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
                  child: MarkdownBody(
                    data: text.data!,
                    selectable: true,
                    styleSheet: _markdownStyle(context),
                    onTapLink: (String text, String? href, String title) {
                      final Uri? uri = href == null ? null : Uri.tryParse(href);
                      if (uri == null) return;
                      unawaited(
                        launchUrl(uri, mode: LaunchMode.externalApplication),
                      );
                    },
                  ),
                )
              : ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
                  children: <Widget>[
                    SelectableText(
                      text.data!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        height: 1.6,
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
        ),
      );
    }

    final Widget selector = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Row(
        children: <Widget>[
          for (int i = 0; i < titles.length; i++)
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: ChoiceChip(
                label: Text(titles[i], style: TextStyle(fontSize: 12.sp)),
                selected: selected.value == i,
                onSelected: (_) => selected.value = i,
              ),
            ),
        ],
      ),
    );

    if (!isDesktopPlatform) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.openSourceLicensePageTitle)),
        body: Column(
          children: <Widget>[selector, Expanded(child: content)],
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 28, 8),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    l10n.openSourceLicensePageTitle,
                    style: context.textTheme.titleLarge?.copyWith(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          selector,
          Expanded(child: content),
        ],
      ),
    );
  }
}

/// 把路由传来的下标收进合法范围，null 或越界都落到第一篇。
int _clampDoc(int? doc) {
  if (doc == null || doc < 0 || doc >= AppLinks.licenseDocAssets.length) {
    return 0;
  }
  return doc;
}

/// `.md` 走 Markdown 渲染，许可证纯文本保持等宽排版。
bool _isMarkdown(String asset) => asset.toLowerCase().endsWith('.md');

/// 声明文档的排版：正文、标题、表格与链接统一到许可页的紧凑层级。
MarkdownStyleSheet _markdownStyle(BuildContext context) {
  final ColorScheme colors = context.colorScheme;
  final double body = isDesktopPlatform ? 12.5 : 12.sp;

  return MarkdownStyleSheet.fromTheme(context.theme).copyWith(
    p: TextStyle(
      fontSize: body,
      height: 1.62,
      color: colors.onSurface.withValues(alpha: 0.9),
    ),
    a: TextStyle(
      color: colors.primary,
      decoration: TextDecoration.underline,
      decorationColor: colors.primary.withValues(alpha: 0.5),
    ),
    strong: TextStyle(fontWeight: FontWeight.w700, color: colors.onSurface),
    em: const TextStyle(fontStyle: FontStyle.italic),
    h1: TextStyle(
      fontSize: body + 6,
      fontWeight: FontWeight.w700,
      height: 1.4,
      color: colors.onSurface,
    ),
    h2: TextStyle(
      fontSize: body + 3,
      fontWeight: FontWeight.w700,
      height: 1.4,
      color: colors.onSurface,
    ),
    h3: TextStyle(
      fontSize: body + 1,
      fontWeight: FontWeight.w600,
      height: 1.4,
      color: colors.onSurface,
    ),
    code: TextStyle(
      fontSize: body - 1,
      fontFamily: 'monospace',
      color: colors.onSurface.withValues(alpha: 0.85),
      backgroundColor: colors.onSurface.withValues(alpha: 0.05),
    ),
    blockquote: TextStyle(
      fontSize: body,
      height: 1.6,
      color: colors.onSurfaceVariant,
    ),
    blockquoteDecoration: BoxDecoration(
      color: colors.onSurface.withValues(alpha: 0.04),
      borderRadius: BorderRadius.circular(8),
    ),
    blockquotePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    listBullet: TextStyle(color: colors.primary, fontSize: body),
    listIndent: 18,
    tableHead: TextStyle(
      fontSize: body - 1,
      fontWeight: FontWeight.w700,
      color: colors.onSurface,
    ),
    tableBody: TextStyle(
      fontSize: body - 1,
      height: 1.45,
      color: colors.onSurface.withValues(alpha: 0.9),
    ),
    tableCellsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    tableBorder: TableBorder.all(
      color: colors.outlineVariant.withValues(alpha: 0.6),
    ),
    blockSpacing: 8,
    horizontalRuleDecoration: BoxDecoration(
      border: Border(
        top: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.7)),
      ),
    ),
  );
}
