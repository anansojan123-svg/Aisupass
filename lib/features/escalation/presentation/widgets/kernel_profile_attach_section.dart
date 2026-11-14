import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_image_input_section.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 上游 `--route` 的可选值。
const List<String> kKernelRouteOptions = <String>[
  'tcp_zerocopy',
  'select_stack',
  'multicast_waiter',
];

/// 可选附件区：默认收起，只补 `kernel_phys_load` 时才需要展开。
///
/// 只影响 GhostLock 的 Rust 推导；GhostKey 走 Kotlin 链路，不显示本区。
class KernelProfileAttachSection extends StatelessWidget {
  const KernelProfileAttachSection({
    super.key,
    required this.expanded,
    required this.onToggle,
    required this.anyBusy,
    required this.xblPath,
    required this.uefiPath,
    required this.vendorBootPath,
    required this.physController,
    required this.onPick,
    required this.onCleared,
    required this.fromPackage,
  });

  final bool expanded;
  final VoidCallback? onToggle;
  final bool anyBusy;
  final ValueNotifier<String?> xblPath;
  final ValueNotifier<String?> uefiPath;
  final ValueNotifier<String?> vendorBootPath;
  final TextEditingController physController;
  final ValueChanged<ValueNotifier<String?>> onPick;

  /// 附件变化后解析结果作废，避免拿旧结果落盘。
  final VoidCallback onCleared;

  /// 输入是直链或本地压缩包：分区由提取器从包内自动解出。
  final bool fromPackage;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final bool isDark = context.isDark;
    final bool hasAttach =
        xblPath.value != null ||
        uefiPath.value != null ||
        vendorBootPath.value != null;

    /* 三个附件竖排：并排时中文标签必然被省略号截断。 */
    Widget row(ValueNotifier<String?> slot, IconData icon, String label) {
      final String? path = slot.value;
      return Padding(
        padding: EdgeInsets.only(top: 6.h),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: anyBusy ? null : () => onPick(slot),
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: scheme.outline.withValues(alpha: isDark ? 0.30 : 0.20),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Icon(icon, size: 15.sp, color: scheme.onSurfaceVariant),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: scheme.onSurface,
                          ),
                        ),
                        if (path != null) ...<Widget>[
                          SizedBox(height: 1.h),
                          Text(
                            path.split('/').last,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: AppFonts.code,
                              fontSize: 10.5.sp,
                              color: scheme.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    path == null
                        ? l10n.kernelProfileAttachPick
                        : l10n.kernelProfileAttachReplace,
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w600,
                      color: scheme.primary,
                    ),
                  ),
                  if (path != null) ...<Widget>[
                    SizedBox(width: 2.w),
                    InkWell(
                      onTap: anyBusy
                          ? null
                          : () {
                              slot.value = null;
                              onCleared();
                            },
                      borderRadius: BorderRadius.circular(12.r),
                      child: Padding(
                        padding: EdgeInsets.all(4.r),
                        child: Icon(
                          Icons.close_rounded,
                          size: 14.sp,
                          color: scheme.onSurfaceVariant,
                        ),
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

    return _SectionShell(
      icon: Icons.attachment_rounded,
      title: l10n.kernelProfileAttachTitle,
      subtitle: hasAttach
          ? l10n.kernelProfileAttachAttachedCount
          : l10n.kernelProfileAttachHint,
      marked: hasAttach,
      expanded: expanded,
      onToggle: onToggle,
      children: <Widget>[
        if (fromPackage)
          /* 直链/压缩包：分区由提取器决定，不给手选入口。 */
          Text(
            l10n.kernelProfileAttachAutoHint,
            style: TextStyle(
              fontSize: 10.5.sp,
              height: 1.4,
              color: scheme.onSurfaceVariant,
            ),
          )
        else ...<Widget>[
          /* 单镜像输入没有包内分区。 */
          row(xblPath, Icons.memory_rounded, l10n.kernelProfileImportAttachXbl),
          row(uefiPath, Icons.dns_rounded, l10n.kernelProfileImportAttachUefi),
          row(
            vendorBootPath,
            Icons.developer_board_rounded,
            l10n.kernelProfileImportAttachVendorBoot,
          ),
          Padding(
            padding: EdgeInsets.only(top: 4.h, left: 2.w),
            child: Text(
              l10n.kernelProfileAttachVendorBootHint,
              style: TextStyle(
                fontSize: 10.5.sp,
                height: 1.4,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
        SizedBox(height: 8.h),
        TextField(
          controller: physController,
          keyboardType: TextInputType.text,
          style: TextStyle(fontSize: 13.sp, color: scheme.onSurface),
          decoration: InputDecoration(
            isDense: true,
            labelText: l10n.kernelProfileImportPhysLabel,
            hintText: l10n.kernelProfileImportPhysHint,
            hintStyle: TextStyle(
              fontSize: 13.sp,
              color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            border: const OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 12.h,
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          l10n.kernelProfileProbePhysUnsetHint,
          style: TextStyle(
            fontSize: 10.5.sp,
            height: 1.4,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// 上游 CLI 的解析选项：外部符号表 / 内存映射 / 强制路由 / 缺符号容忍 / 跳过反汇编。
class KernelProfileAdvancedSection extends StatelessWidget {
  const KernelProfileAdvancedSection({
    super.key,
    required this.expanded,
    required this.onToggle,
    required this.anyBusy,
    required this.kallsymsPath,
    required this.iomemPath,
    required this.forcedRoute,
    required this.allowMissing,
    required this.noDisasm,
    required this.onPick,
    required this.onChanged,
  });

  final bool expanded;
  final VoidCallback? onToggle;
  final bool anyBusy;
  final ValueNotifier<String?> kallsymsPath;
  final ValueNotifier<String?> iomemPath;
  final ValueNotifier<String> forcedRoute;
  final ValueNotifier<bool> allowMissing;
  final ValueNotifier<bool> noDisasm;
  final ValueChanged<ValueNotifier<String?>> onPick;

  /// 选项变化后作废上一次的解析结果。
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final bool hasOverride =
        kallsymsPath.value != null ||
        iomemPath.value != null ||
        forcedRoute.value.isNotEmpty ||
        allowMissing.value ||
        noDisasm.value;

    Widget chip(ValueNotifier<String?> slot, IconData icon) => Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: KernelProfileInputChip(
        icon: icon,
        text: slot.value!,
        onClear: anyBusy
            ? null
            : () {
                slot.value = null;
                onChanged();
              },
      ),
    );

    Widget switchRow({
      required String label,
      required ValueNotifier<bool> slot,
    }) => Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.5.sp,
                height: 1.35,
                color: scheme.onSurface,
              ),
            ),
          ),
          SizedBox(
            height: 28.h,
            child: Switch(
              value: slot.value,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: anyBusy
                  ? null
                  : (bool next) {
                      slot.value = next;
                      onChanged();
                    },
            ),
          ),
        ],
      ),
    );

    return _SectionShell(
      icon: Icons.tune_rounded,
      title: l10n.kernelProfileAdvancedTitle,
      subtitle: l10n.kernelProfileAdvancedHint,
      marked: hasOverride,
      expanded: expanded,
      onToggle: onToggle,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: anyBusy ? null : () => onPick(kallsymsPath),
                icon: Icon(Icons.tag_rounded, size: 15.r),
                label: Text(
                  l10n.kernelProfileImportKallsyms,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11.5.sp),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: anyBusy ? null : () => onPick(iomemPath),
                icon: Icon(Icons.memory_outlined, size: 15.r),
                label: Text(
                  l10n.kernelProfileImportIomem,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11.5.sp),
                ),
              ),
            ),
          ],
        ),
        if (kallsymsPath.value != null) chip(kallsymsPath, Icons.tag_rounded),
        if (iomemPath.value != null) chip(iomemPath, Icons.memory_outlined),
        SizedBox(height: 10.h),
        Text(
          l10n.kernelProfileImportRoute,
          style: TextStyle(
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w600,
            color: scheme.onSurface,
          ),
        ),
        SizedBox(height: 4.h),
        Wrap(
          spacing: 6.w,
          runSpacing: 6.h,
          children: <Widget>[
            ChoiceChip(
              label: Text(
                l10n.kernelProfileImportRouteAuto,
                style: TextStyle(fontSize: 11.sp),
              ),
              selected: forcedRoute.value.isEmpty,
              onSelected: anyBusy
                  ? null
                  : (bool selected) {
                      if (!selected) return;
                      forcedRoute.value = '';
                      onChanged();
                    },
            ),
            for (final String option in kKernelRouteOptions)
              ChoiceChip(
                label: Text(option, style: TextStyle(fontSize: 11.sp)),
                selected: forcedRoute.value == option,
                onSelected: anyBusy
                    ? null
                    : (bool selected) {
                        if (!selected) return;
                        forcedRoute.value = option;
                        onChanged();
                      },
              ),
          ],
        ),
        SizedBox(height: 8.h),
        switchRow(
          label: l10n.kernelProfileImportAllowMissing,
          slot: allowMissing,
        ),
        switchRow(label: l10n.kernelProfileImportNoDisasm, slot: noDisasm),
      ],
    );
  }
}

/// 可折叠分区的统一外壳。
class _SectionShell extends StatelessWidget {
  const _SectionShell({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.marked,
    required this.expanded,
    required this.onToggle,
    required this.children,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  /// 右侧显示已启用标记。
  final bool marked;
  final bool expanded;
  final VoidCallback? onToggle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: scheme.outline.withValues(alpha: 0.15)),
        ),
      ),
      padding: EdgeInsets.only(top: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(8.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 6.h),
              child: Row(
                children: <Widget>[
                  Icon(icon, size: 15.sp, color: scheme.onSurfaceVariant),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 10.5.sp,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (marked)
                    Padding(
                      padding: EdgeInsets.only(right: 4.w),
                      child: Icon(
                        Icons.check_circle_rounded,
                        size: 14.sp,
                        color: scheme.primary,
                      ),
                    ),
                  Icon(
                    expanded
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    size: 18.sp,
                    color: scheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          if (expanded) ...<Widget>[
            SizedBox(height: 4.h),
            ...children,
          ],
        ],
      ),
    );
  }
}
