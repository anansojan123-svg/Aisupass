import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// 导入面板的固定底部操作栏：解析 / 写入，解析成功后追加导出图标。
///
/// 纯展示，动作全部由回调注入。
class KernelProfileImportBottomBar extends StatelessWidget {
  const KernelProfileImportBottomBar({
    super.key,
    required this.probed,
    required this.anyBusy,
    required this.probing,
    required this.parsed,
    required this.ghostLockTarget,
    required this.inputEmpty,
    required this.targetName,
    required this.onParse,
    required this.onSave,
    required this.onExport,
  });

  /// 是否已有可写入的解析结果；有则主按钮切成「写入」。
  final bool probed;

  /// 任何一路进行中：按钮统一置灰。
  final bool anyBusy;

  /// 正在解析，主按钮显示转圈。
  final bool probing;

  /// 本次是否解析成功；导出图标只在这之后出现。
  final bool parsed;

  /// 目标为 GhostLock 时才提供导出入口。
  final bool ghostLockTarget;

  /// 输入源为空，解析按钮不可点。
  final bool inputEmpty;

  /// 当前目标名，用于「写入到 xxx」。
  final String targetName;

  final VoidCallback onParse;
  final VoidCallback onSave;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 44.h,
          child: Row(
            children: <Widget>[
              Expanded(
                child: probed
                    ? FilledButton.icon(
                        onPressed: anyBusy ? null : onSave,
                        icon: Icon(Icons.save_alt_rounded, size: 18.r),
                        label: Text(
                          l10n.kernelProfileWriteToTarget(targetName),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : FilledButton.icon(
                        onPressed: anyBusy || inputEmpty ? null : onParse,
                        icon: probing
                            ? SizedBox(
                                width: 16.r,
                                height: 16.r,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(
                                Icons.playlist_add_check_rounded,
                                size: 18.r,
                              ),
                        label: Text(l10n.kernelProfileImportParseAction),
                      ),
              ),
              if (ghostLockTarget && parsed) ...<Widget>[
                SizedBox(width: 8.w),
                IconButton.filledTonal(
                  onPressed: anyBusy ? null : onExport,
                  tooltip: l10n.kernelImageExport,
                  icon: Icon(Icons.download_rounded, size: 20.r),
                  style: IconButton.styleFrom(minimumSize: Size(44.r, 44.r)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
