import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// 打开镜像导出弹层。
///
/// [paths] 是解析/提取留在缓存里的镜像绝对路径；每行单独导出到「下载」目录。
Future<void> showKernelImageExportSheet(
  BuildContext context, {
  required List<String> paths,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (BuildContext sheetContext) => KernelImageExportSheet(paths: paths),
);

/// 镜像导出列表：文件名 + 单条导出。
class KernelImageExportSheet extends HookConsumerWidget {
  const KernelImageExportSheet({super.key, required this.paths});

  final List<String> paths;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final ValueNotifier<bool> busy = useState<bool>(false);
    /* 订阅后才刷新按钮禁用态，避免导出途中重复触发。 */
    final bool isBusy = useValueListenable(busy);

    Future<void> export(String path) async {
      if (busy.value) return;
      busy.value = true;
      try {
        final String saved = await ref
            .read(ghostLockProfileActionsProvider)
            .exportLocalFile(sourcePath: path, fileName: _nameOf(path));
        if (!context.mounted) return;
        if (saved.isEmpty) {
          ToastMessage.error(l10n.kernelImageExportFailed);
        } else {
          ToastMessage.success(l10n.kernelImageExportSaved(saved));
        }
      } catch (error) {
        ToastMessage.error(error);
      } finally {
        busy.value = false;
      }
    }

    return FractionallySizedBox(
      heightFactor: 0.6,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 8.w, 4.h),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    l10n.kernelImageExportCount(paths.length),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close_rounded, size: 20.sp),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.kernelImageExportHint,
                style: TextStyle(
                  fontSize: 11.5.sp,
                  height: 1.4,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Expanded(
            child: paths.isEmpty
                ? Center(
                    child: Text(
                      l10n.kernelImageExportEmpty,
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 16.h),
                    itemCount: paths.length,
                    separatorBuilder: (_, _) => Divider(
                      height: 1.h,
                      color: scheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final String path = paths[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text(
                          _nameOf(path),
                          style: TextStyle(fontSize: 12.5.sp),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: TextButton(
                          onPressed: isBusy ? null : () => export(path),
                          child: Text(
                            l10n.escalationGhostLockProfileExport,
                            style: TextStyle(fontSize: 11.5.sp),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// 取路径末段作为文件名；原生侧只接受文件名而不是完整路径。
  String _nameOf(String path) => path.split('/').last;
}
