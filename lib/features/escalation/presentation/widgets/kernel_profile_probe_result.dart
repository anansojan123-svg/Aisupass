import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_probe.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_probe_progress.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 复制按钮：把失败原因整段写进剪贴板。
class _CopyIcon extends StatelessWidget {
  const _CopyIcon({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    return IconButton(
      onPressed: () async {
        await Clipboard.setData(ClipboardData(text: text));
        if (context.mounted) {
          ToastMessage.success(l10n.kernelProfileErrorCopied);
        }
      },
      tooltip: l10n.kernelProfileErrorCopy,
      icon: Icon(Icons.copy_rounded, size: 14.sp),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(minWidth: 28.w, minHeight: 28.h),
    );
  }
}

/// 解析结果卡片：只做展示，写入由弹层底部主按钮触发。
class KernelProfileProbeCard extends HookWidget {
  const KernelProfileProbeCard({
    super.key,
    required this.probe,
    required this.enabled,
  });

  final GhostLockProbe probe;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        color: scheme.primaryContainer.withValues(alpha: 0.45),
        border: Border.all(
          color: scheme.primary.withValues(alpha: enabled ? 0.55 : 0.2),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.check_circle_rounded,
                  size: 17.sp,
                  color: scheme.primary,
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    l10n.kernelProfileProbeReady,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: scheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            SelectableText(
              probe.release,
              style: TextStyle(
                fontSize: 12.5.sp,
                height: 1.4,
                color: scheme.onSurface,
              ),
            ),
            SizedBox(height: 4.h),
            /* 几何缺失是硬失败：运行到 W1 一定停，先在这里说清楚。 */
            if (_geometryWarnings(probe.warnings) case final List<String> gaps
                when gaps.isNotEmpty) ...<Widget>[
              SizedBox(height: 4.h),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      l10n.kernelProfileProbeRouteIncomplete,
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: scheme.error,
                      ),
                    ),
                  ),
                  _CopyIcon(
                    text: <String>[
                      l10n.kernelProfileProbeRouteIncomplete,
                      for (final String line in gaps) '· $line',
                      l10n.kernelProfileProbeRouteIncompleteHint,
                    ].join('\n'),
                  ),
                ],
              ),
              for (final String line in gaps)
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: SelectableText(
                    '· $line',
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      height: 1.4,
                      color: scheme.error,
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: SelectableText(
                  l10n.kernelProfileProbeRouteIncompleteHint,
                  style: TextStyle(
                    fontSize: 10.5.sp,
                    height: 1.4,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
            /* 从包内实际解出的分区。 */
            if (_payloadLine(probe.warnings)
                case final String extracted) ...<Widget>[
              SelectableText(
                '${l10n.kernelProfileProbePayloadParts}: $extracted',
                style: TextStyle(
                  fontSize: 11.5.sp,
                  height: 1.4,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 4.h),
            ],
            SelectableText(
              probe.hasKernelPhysLoad
                  ? '${l10n.kernelProfileProbePhys}: '
                        '${probe.kernelPhysLoad} (${probe.physSource})'
                  : '${l10n.kernelProfileProbePhys}: '
                        '${l10n.kernelProfileProbePhysMissing}',
              style: TextStyle(
                fontSize: 11.5.sp,
                height: 1.4,
                color: scheme.onSurfaceVariant,
              ),
            ),
            /* 未取到时展开物理基址相关的告警。 */
            if (!probe.hasKernelPhysLoad) ...<Widget>[
              SizedBox(height: 2.h),
              Row(
                children: <Widget>[
                  Expanded(
                    child: SelectableText(
                      l10n.kernelProfileProbePhysUnsetHint,
                      style: TextStyle(
                        fontSize: 10.5.sp,
                        height: 1.4,
                        color: scheme.onSurfaceVariant.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  _CopyIcon(
                    text: <String>[
                      l10n.kernelProfileProbePhysUnsetHint,
                      for (final String line in _physWarnings(probe.warnings))
                        '· $line',
                    ].join('\n'),
                  ),
                ],
              ),
              for (final String line in _physWarnings(probe.warnings))
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: SelectableText(
                    '· $line',
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      height: 1.4,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
            if (probe.warnings.isNotEmpty) ...<Widget>[
              SizedBox(height: 6.h),
              KernelProfileTextSheetButton(
                icon: Icons.report_outlined,
                label: l10n.kernelProfileProbeWarnings(probe.warnings.length),
                title: l10n.kernelProfileProbeWarningsTitle,
                body: probe.warnings.join('\n'),
                enabled: enabled,
              ),
            ],
            if (probe.analysis.isNotEmpty) ...<Widget>[
              SizedBox(height: 4.h),
              KernelProfileAnalysisButton(
                text: probe.analysis,
                enabled: enabled,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 解析进度：阶段名 + 百分比 + 进度条。
///
/// 下载阶段有字节总量，进度条走确定值；解包与解析阶段没有总量，用不确定动画。
class KernelProfileProbeProgress extends HookWidget {
  const KernelProfileProbeProgress({super.key, required this.state});

  final GhostLockProbeProgress state;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final bool determinate = state.total > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                state.downloading
                    ? l10n.kernelProfilePhaseRead
                    : l10n.kernelProfilePhaseParse,
                style: TextStyle(
                  fontSize: 11.5.sp,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
            Text(
              determinate ? '${(state.fraction * 100).round()}%' : '',
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
            value: determinate ? state.fraction : null,
            minHeight: 4.h,
            backgroundColor: scheme.surfaceContainerHigh,
          ),
        ),
      ],
    );
  }
}

/// 点击后在弹窗里看全文的按钮（告警明细与审查报告共用）。
class KernelProfileTextSheetButton extends HookWidget {
  const KernelProfileTextSheetButton({
    super.key,
    required this.icon,
    required this.label,
    required this.title,
    required this.body,
    required this.enabled,
  });

  final IconData icon;
  final String label;
  final String title;
  final String body;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: enabled ? () => _show(context) : null,
        icon: Icon(icon, size: 15.sp),
        label: Text(label, style: TextStyle(fontSize: 11.5.sp)),
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          foregroundColor: scheme.primary,
        ),
      ),
    );
  }

  void _show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SelectableText(
              body,
              style: TextStyle(fontSize: 12.sp, height: 1.45),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(dialogContext.l10n.kernelProfileDialogClose),
          ),
        ],
      ),
    );
  }
}

/// 内核审查报告入口。
class KernelProfileAnalysisButton extends HookWidget {
  const KernelProfileAnalysisButton({
    super.key,
    required this.text,
    required this.enabled,
  });

  final String text;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    return KernelProfileTextSheetButton(
      icon: Icons.fact_check_outlined,
      label: l10n.kernelProfileProbeAnalysis,
      title: l10n.kernelProfileProbeAnalysisTitle,
      body: text,
      enabled: enabled,
    );
  }
}

/// 取出「包内解出了哪些分区」那一行；没有则返回 null。
String? _payloadLine(List<String> warnings) {
  const String prefix = 'extracted from payload: ';
  for (final String line in warnings) {
    if (line.startsWith(prefix)) return line.substring(prefix.length);
  }
  return null;
}

/// 与物理装载基址相关的告警行。
///
/// 已解出分区那一行单独展示，这里排除掉，避免重复。
List<String> _physWarnings(List<String> warnings) => warnings
    .where(
      (String line) =>
          !line.startsWith('extracted from payload: ') &&
          !line.startsWith('vendor_boot extracted from payload') &&
          (line.contains('xbl_config') ||
              line.contains('uefi') ||
              line.contains('vendor_boot') ||
              line.contains('iomem')),
    )
    .toList();

/// 路由几何缺失的告警行。
///
/// 提取器把 `waiter_off` / `buffer_size` 这类帧常量留给反汇编推导，推不出来
/// 就只写一部分字段并留下对应告警。缺字段的路由在 W1 会直接被拒，必须提到
/// 卡片正面而不是折在「提示」里。
List<String> _geometryWarnings(List<String> warnings) => warnings
    .where(
      (String line) =>
          line.contains('multicast waiter_off derivation failed') ||
          line.contains('no image-derived geometry') ||
          line.contains('geometry is partial') ||
          line.contains('no route could be inferred'),
    )
    .toList();
