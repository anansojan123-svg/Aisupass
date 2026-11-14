import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 顶部地址胶囊。
///
/// 域名加粗、路径淡化，一眼能看出当前站点；点击复制完整链接。
/// 加载中把协议图标换成小转圈，进度条由页面挂在 AppBar 底部。
class BrowserUrlPill extends StatelessWidget {
  const BrowserUrlPill({
    super.key,
    required this.url,
    required this.loading,
    required this.failed,
    required this.progress,
  });

  /// 当前地址，可能还没规范化。
  final String url;

  /// 是否正在加载。
  final bool loading;

  /// 是否处于加载失败态。
  final bool failed;

  /// 加载进度百分比，仅在 [loading] 时展示。
  final int progress;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme colors = context.colorScheme;
    final Uri? uri = Uri.tryParse(url);
    final bool secure = uri?.scheme == 'https';
    final String host = uri?.host ?? '';
    final String path = host.isEmpty ? '' : (uri?.path ?? '');

    Future<void> copy() async {
      await Clipboard.setData(ClipboardData(text: url));
      if (!context.mounted) return;
      ToastMessage.success(l10n.chatBrowserLinkCopied);
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h),
      child: Material(
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: copy,
          child: Container(
            height: 34.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: 0.7),
              ),
            ),
            child: Row(
              children: <Widget>[
                _leading(colors, secure),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        TextSpan(
                          text: host.isEmpty ? url : host,
                          style: TextStyle(
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.onSurface,
                          ),
                        ),
                        if (path.isNotEmpty && path != '/')
                          TextSpan(
                            text: path,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (loading) ...<Widget>[
                  SizedBox(width: 6.w),
                  Text(
                    l10n.chatBrowserLoadingPercent(progress),
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _leading(ColorScheme colors, bool secure) {
    if (loading) {
      return SizedBox(
        width: 13.sp,
        height: 13.sp,
        child: CircularProgressIndicator(
          strokeWidth: 1.6,
          color: colors.onSurfaceVariant,
        ),
      );
    }
    if (failed) {
      return Icon(
        Icons.error_outline_rounded,
        size: 14.sp,
        color: colors.error,
      );
    }
    return Icon(
      secure ? Icons.lock_rounded : Icons.public_rounded,
      size: 13.sp,
      color: colors.onSurfaceVariant,
    );
  }
}
