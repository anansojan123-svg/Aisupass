import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/core/constants/app_links.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/providers/asset_bundle_provider.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// GPL-3.0 协议全文页。
///
/// 文本来自包内 `LICENSE` 资源，离线可读。
class OpenSourceLicensePage extends HookConsumerWidget {
  const OpenSourceLicensePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final AssetBundle bundle = ref.watch(assetBundleProvider);
    final AsyncSnapshot<String> text = useFuture(
      useMemoized(() => bundle.loadString(AppLinks.licenseAsset)),
    );

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
          child: ListView(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
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

    if (!isDesktopPlatform) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.openSourceLicensePageTitle)),
        body: content,
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
          Expanded(child: content),
        ],
      ),
    );
  }
}
