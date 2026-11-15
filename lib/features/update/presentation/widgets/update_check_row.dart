import 'package:Aisupass/common/widgets/app_setting_icon.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/app_version.dart';
import 'package:Aisupass/features/update/data/datasources/update_query_datasource.dart';
import 'package:Aisupass/features/update/domain/enums/update_check_failure.dart';
import 'package:Aisupass/features/update/domain/models/app_update.dart';
import 'package:Aisupass/features/update/presentation/controllers/update_check_controller.dart';
import 'package:Aisupass/features/update/presentation/widgets/update_prompt_dialog.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 设置页「关于」分组里的检查更新入口。
///
/// 副标题展示本机版本；检查中在右侧显示进度圈。
class UpdateCheckRow extends HookConsumerWidget {
  const UpdateCheckRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final AsyncSnapshot<PackageInfo> info = useFuture(
      useMemoized(AppVersion.load),
    );
    final ValueNotifier<bool> checking = useState<bool>(false);
    final PackageInfo? package = info.data;

    Future<void> check() async {
      if (checking.value || package == null) return;
      checking.value = true;
      try {
        final AppUpdate? latest = await UpdateCheckController(
          ref: ref,
          version: package.version,
          buildNumber: package.buildNumber,
        ).check();
        if (!context.mounted) return;
        if (latest == null) {
          ToastMessage.success(l10n.updateLatest);
          return;
        }
        await showUpdatePromptDialog(context, update: latest);
      } on UpdateCheckException catch (error) {
        if (!context.mounted) return;
        ToastMessage.error(
          error.failure == UpdateCheckFailure.notConfigured
              ? l10n.updateNotConfigured
              : l10n.updateCheckFailed,
        );
      } finally {
        checking.value = false;
      }
    }

    return InkWell(
      onTap: check,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: <Widget>[
            const AppSettingIcon(icon: Icons.system_update_alt_rounded),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    l10n.updateCheckTitle,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    package == null
                        ? ''
                        : l10n.updateCurrentVersion(
                            package.version,
                            package.buildNumber,
                          ),
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            if (checking.value)
              SizedBox(
                width: 16.sp,
                height: 16.sp,
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(
                Icons.chevron_right_rounded,
                size: 20.sp,
                color: context.colorScheme.onSurface.withValues(alpha: 0.72),
              ),
          ],
        ),
      ),
    );
  }
}
