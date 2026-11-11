import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile.dart';
import 'package:Aisupass/features/escalation/presentation/providers/kernel_profile_query_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_import_panel.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_imported_row.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// 内核 profile 页面：从 boot.img 生成并管理用户导入的 profile。
class KernelProfilePage extends HookConsumerWidget {
  const KernelProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final AsyncValue<List<KernelProfile>> listAsync = ref.watch(
      kernelProfileListProvider,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.kernelProfileTitle)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
        children: <Widget>[
          Text(
            l10n.kernelProfilePageDesc,
            style: TextStyle(
              fontSize: 12.sp,
              height: 1.5,
              color: scheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 16.h),
          const KernelProfileImportPanel(),
          SizedBox(height: 22.h),
          Text(
            l10n.kernelProfileImportedSection,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          listAsync.when(
            loading: () => SizedBox(height: 120.h, child: const Loading()),
            error: (Object error, StackTrace stackTrace) => RefError(
              onRetry: () => ref.invalidate(kernelProfileListProvider),
            ),
            data: (List<KernelProfile> list) {
              if (list.isEmpty) {
                return Text(
                  l10n.kernelProfileImportedEmpty,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: scheme.onSurfaceVariant,
                  ),
                );
              }
              return Column(
                children: <Widget>[
                  for (final KernelProfile profile in list)
                    KernelProfileImportedRow(profile: profile),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
