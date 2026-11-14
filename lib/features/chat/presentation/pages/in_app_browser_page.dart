import 'dart:async';
import 'dart:convert';

import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/chat/presentation/providers/chat_action_provider.dart';
import 'package:Aisupass/features/chat/presentation/widgets/browser_action_bar.dart';
import 'package:Aisupass/features/chat/presentation/widgets/browser_load_failed_view.dart';
import 'package:Aisupass/features/chat/presentation/widgets/browser_url_pill.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 单页加载超时。超时后不再空转进度条，直接给出可操作的失败态。
const Duration _loadTimeout = Duration(seconds: 30);

/// 应用内浏览器。
///
/// 存在的理由：找 ROM / 固件时常被验证码、登录墙、Cloudflare 挑战拦住，
/// 这些只存在于真实浏览器会话里，应用内直连抓取永远过不去。这里给一个
/// 真 WebView，用户自己过验证码、自己下文件，再把结果交回对话。
class InAppBrowserPage extends HookConsumerWidget {
  const InAppBrowserPage({super.key, required this.initialUrl});

  /// 起始地址，由对话内的网页卡片带进来。
  final String initialUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;

    // 只有 Android 有 WebView 实现，其余平台只能退回系统浏览器。
    if (!isAndroidPlatform) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.chatBrowserPanelTitle)),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.desktop_windows_rounded,
                  size: 40.sp,
                  color: context.colorScheme.onSurfaceVariant,
                ),
                SizedBox(height: 12.h),
                Text(
                  l10n.chatBrowserDesktopUnsupported,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.sp),
                ),
                SizedBox(height: 16.h),
                FilledButton.icon(
                  onPressed: () async {
                    final Uri? uri = Uri.tryParse(initialUrl);
                    if (uri == null) return;
                    await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  icon: Icon(Icons.open_in_new_rounded, size: 16.sp),
                  label: Text(l10n.chatBrowserOpen),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (initialUrl.trim().isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.chatBrowserPanelTitle)),
        body: Center(
          child: Text(l10n.chatBrowserEmptyUrl, style: TextStyle(fontSize: 13.sp)),
        ),
      );
    }

    final ValueNotifier<String> currentUrl = useState<String>(initialUrl);
    final ValueNotifier<int> progress = useState<int>(0);
    final ValueNotifier<bool> loading = useState<bool>(true);
    final ValueNotifier<bool> canBack = useState<bool>(false);
    final ValueNotifier<bool> canForward = useState<bool>(false);
    // 空串表示正常；非空即失败原因，会顶掉 WebView 显示可操作面板。
    final ValueNotifier<String> loadError = useState<String>('');

    final WebViewController controller = useMemoized(() {
      // 先声明后配置：导航回调里要读 view 自身的前进/后退能力。
      final WebViewController view = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted);
      view.setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int value) => progress.value = value,
          onPageStarted: (String url) {
            currentUrl.value = url;
            loadError.value = '';
            loading.value = true;
          },
          onPageFinished: (String url) async {
            currentUrl.value = url;
            loading.value = false;
            try {
              final bool back = await view.canGoBack();
              final bool forward = await view.canGoForward();
              canBack.value = back;
              canForward.value = forward;
            } catch (_) {
              // 页面此时可能已被销毁，前进/后退按钮保持原样即可。
            }
          },
          onUrlChange: (UrlChange change) {
            final String? url = change.url;
            if (url != null && url.isNotEmpty) currentUrl.value = url;
          },
          onWebResourceError: (WebResourceError error) {
            // 子资源（图片、统计脚本）失败不该判定整页失败。
            if (error.isForMainFrame == false) return;
            loading.value = false;
            loadError.value = error.description.isEmpty
                ? l10n.chatBrowserLoadFailed
                : error.description;
          },
        ),
      );
      view.loadRequest(Uri.parse(initialUrl));
      return view;
    }, <Object?>[initialUrl]);

    // 30s 还没结束就认为是卡死：内置 WebView 被站点拒绝、协议不支持等。
    useEffect(() {
      if (!loading.value || loadError.value.isNotEmpty) return null;
      final Timer timer = Timer(_loadTimeout, () {
        if (!loading.value) return;
        loading.value = false;
        loadError.value = l10n.chatBrowserLoadTimeout;
      });
      return timer.cancel;
    }, <Object?>[loading.value, loadError.value]);

    /// 清掉失败态并重新加载当前地址。
    void retry() {
      loadError.value = '';
      progress.value = 0;
      loading.value = true;
      controller.loadRequest(Uri.parse(currentUrl.value));
    }

    /// 页内历史优先；没有历史时退出页面。
    Future<void> goBack() async {
      bool back = canBack.value;
      try {
        back = await controller.canGoBack();
      } catch (_) {
        back = false;
      }
      if (back) {
        await controller.goBack();
        return;
      }
      if (!context.mounted) return;
      Navigator.of(context).pop();
    }

    /// 关闭浏览器并把内容交回对话。
    ///
    /// 先 pop 再发送：发送可能耗时或因未配置模型而抛错，用户不该被按在
    /// 浏览器里等结果。
    Future<void> handoffToChat({
      required String source,
      required String filePath,
    }) async {
      String url = currentUrl.value;
      try {
        url = await controller.currentUrl() ?? url;
      } catch (_) {
        // WebView 已失效时沿用最后一次记录的地址。
      }
      final ChatController chat = ref.read(chatControllerProvider.notifier);
      if (!context.mounted) return;
      Navigator.of(context).pop();
      await chat.sendBrowserHandoff(
        url: url,
        source: source,
        filePath: filePath,
      );
    }

    /// 取当前页面源码并交回对话。
    Future<void> handoffSource() async {
      String source = '';
      try {
        final Object raw = await controller.runJavaScriptReturningResult(
          'document.documentElement.outerHTML',
        );
        source = _decodeJsString(raw);
      } catch (_) {
        source = '';
      }
      await handoffToChat(source: source, filePath: '');
    }

    /// 只回传当前地址，不抓源码。
    Future<void> handoffUrl() => handoffToChat(source: '', filePath: '');

    /// 选一个已经下载到本机的文件交回对话。
    ///
    /// 内嵌 WebView 没有下载管理器，固件包请用系统浏览器下载后用这里选回来。
    Future<void> handoffFile() async {
      final FilePickerResult? picked = await FilePicker.pickFiles();
      final String? path = picked?.files.single.path;
      if (path == null || path.isEmpty) return;
      await handoffToChat(source: '', filePath: path);
    }

    Future<void> openExternal() async {
      final String url = currentUrl.value;
      final Uri? uri = Uri.tryParse(url);
      if (uri == null) return;
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    final ColorScheme colors = context.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: goBack,
          icon: Icon(Icons.arrow_back_rounded, size: 20.sp),
          tooltip: l10n.chatBrowserBack,
        ),
        title: BrowserUrlPill(
          url: currentUrl.value,
          loading: loading.value,
          failed: loadError.value.isNotEmpty,
          progress: progress.value,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: canForward.value ? controller.goForward : null,
            icon: Icon(Icons.arrow_forward_rounded, size: 20.sp),
            tooltip: l10n.chatBrowserForward,
          ),
          IconButton(
            // 加载中也要能点：卡死时 reload 是唯一的自救手段。
            onPressed: loadError.value.isNotEmpty ? retry : controller.reload,
            icon: Icon(Icons.refresh_rounded, size: 19.sp),
            tooltip: l10n.chatBrowserReload,
          ),
          SizedBox(width: 4.w),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: loading.value
              ? LinearProgressIndicator(
                  value: progress.value <= 0 ? null : progress.value / 100,
                  minHeight: 3,
                  backgroundColor: colors.surfaceContainerHigh,
                )
              : SizedBox(height: 3, child: ColoredBox(color: colors.surface)),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              // 必须 expand：Android 的 platform view 拿到 loose 约束时
              // 可能以 0 尺寸挂载，表现为页面永远空转。
              fit: StackFit.expand,
              children: <Widget>[
                WebViewWidget(controller: controller),
                if (loadError.value.isNotEmpty)
                  Positioned.fill(
                    child: ColoredBox(
                      color: colors.surface,
                      child: BrowserLoadFailedView(
                        message: loadError.value,
                        title: l10n.chatBrowserLoadFailed,
                        retryLabel: l10n.chatBrowserRetry,
                        externalLabel: l10n.chatBrowserOpen,
                        onRetry: retry,
                        onExternal: openExternal,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          BrowserActionBar(
            onHandoffSource: handoffSource,
            onHandoffUrl: handoffUrl,
            onHandoffFile: handoffFile,
            onOpenExternal: openExternal,
          ),
        ],
      ),
    );
  }
}

/// `runJavaScriptReturningResult` 在 Android 上返回 JSON 编码的字符串，
/// 需要解一层引号才能拿到原文。
String _decodeJsString(Object raw) {
  final String text = raw.toString();
  if (text.length < 2 || !text.startsWith('"') || !text.endsWith('"')) {
    return text;
  }
  try {
    final Object? decoded = jsonDecode(text);
    return decoded is String ? decoded : text;
  } on FormatException {
    return text;
  }
}
