import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/escalation/domain/enums/ota_catalog_brand.dart';
import 'package:Aisupass/features/escalation/domain/models/ota_package.dart';
import 'package:Aisupass/features/escalation/presentation/providers/ota_catalog_query_provider.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// 打开内置 OTA 清单弹窗；选中一条后通过 [onPick] 回填链接。
Future<void> showOtaCatalogSheet(
  BuildContext context, {
  required ValueChanged<String> onPick,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (BuildContext _) => OtaCatalogSheet(onPick: onPick),
);

/// 内置 OTA 版本浏览：按品牌切换，按机型分组，点版本回填 URL。
class OtaCatalogSheet extends HookConsumerWidget {
  const OtaCatalogSheet({required this.onPick, super.key});

  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final ValueNotifier<OtaCatalogBrand> brand = useState<OtaCatalogBrand>(
      OtaCatalogBrand.google,
    );
    final ValueNotifier<String> keyword = useState<String>('');
    final ValueNotifier<Set<String>> expanded = useState<Set<String>>(
      <String>{},
    );

    final AsyncValue<List<OtaPackage>> catalog = ref.watch(
      otaCatalogListProvider(brand: brand.value),
    );

    final List<OtaPackage> filtered = useMemoized(() {
      final List<OtaPackage> all = catalog.value ?? const <OtaPackage>[];
      final String q = keyword.value.trim().toLowerCase();
      if (q.isEmpty) return all;
      return all
          .where(
            (OtaPackage e) =>
                e.device.toLowerCase().contains(q) ||
                e.model.toLowerCase().contains(q) ||
                e.build.toLowerCase().contains(q),
          )
          .toList(growable: false);
    }, <Object?>[catalog.value, keyword.value]);

    // 按机型分组，保留清单里的原始顺序。
    final Map<String, List<OtaPackage>> grouped = useMemoized(() {
      final Map<String, List<OtaPackage>> map = <String, List<OtaPackage>>{};
      for (final OtaPackage pkg in filtered) {
        map.putIfAbsent(pkg.device, () => <OtaPackage>[]).add(pkg);
      }
      return map;
    }, <Object?>[filtered]);

    return FractionallySizedBox(
      heightFactor: 0.88,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    l10n.otaCatalogTitle,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close_rounded, size: 18.sp),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              children: <Widget>[
                for (final OtaCatalogBrand item in OtaCatalogBrand.values)
                  ChoiceChip(
                    label: Text(
                      switch (item) {
                        OtaCatalogBrand.google => l10n.otaCatalogBrandGoogle,
                        OtaCatalogBrand.realme => l10n.otaCatalogBrandRealme,
                      },
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    selected: brand.value == item,
                    onSelected: (bool _) {
                      expanded.value = <String>{};
                      brand.value = item;
                    },
                  ),
              ],
            ),
            SizedBox(height: 8.h),
            TextField(
              onChanged: (String value) => keyword.value = value,
              style: TextStyle(fontSize: 13.sp, color: scheme.onSurface),
              decoration: InputDecoration(
                isDense: true,
                hintText: l10n.otaCatalogSearchHint,
                hintStyle: TextStyle(
                  fontSize: 13.sp,
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 18.sp,
                  color: scheme.onSurfaceVariant,
                ),
                filled: true,
                fillColor: scheme.surfaceContainerHighest.withValues(
                  alpha: 0.35,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              l10n.otaCatalogPickHint,
              style: TextStyle(
                fontSize: 11.sp,
                height: 1.4,
                color: scheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 4.h),
            Expanded(
              child: catalog.when(
                loading: () => const Loading(),
                error: (Object error, StackTrace _) => RefError(
                  message: '$error',
                  onRetry: () =>
                      ref.invalidate(otaCatalogListProvider(brand: brand.value)),
                ),
                data: (_) => grouped.isEmpty
                    ? Center(
                        child: Text(
                          l10n.otaCatalogEmpty,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.only(bottom: 16.h),
                        itemCount: grouped.length,
                        itemBuilder: (BuildContext _, int index) {
                          final String device = grouped.keys.elementAt(index);
                          final List<OtaPackage> versions = grouped[device]!;
                          return _DeviceGroup(
                            device: device,
                            versions: versions,
                            expanded: expanded.value.contains(device),
                            onToggle: () {
                              final Set<String> next = <String>{
                                ...expanded.value,
                              };
                              if (!next.remove(device)) next.add(device);
                              expanded.value = next;
                            },
                            onPick: (OtaPackage pkg) {
                              Navigator.of(context).pop();
                              onPick(pkg.url);
                            },
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 一个机型分组：折叠时只显示机型名与版本数，展开后列出每条版本。
class _DeviceGroup extends StatelessWidget {
  const _DeviceGroup({
    required this.device,
    required this.versions,
    required this.expanded,
    required this.onToggle,
    required this.onPick,
  });

  final String device;
  final List<OtaPackage> versions;
  final bool expanded;
  final VoidCallback onToggle;
  final ValueChanged<OtaPackage> onPick;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
            child: Row(
              children: <Widget>[
                Icon(
                  expanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  size: 18.sp,
                  color: scheme.onSurfaceVariant,
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    device,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: scheme.onSurface,
                    ),
                  ),
                ),
                Text(
                  l10n.otaCatalogVersionCount(versions.length),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (expanded)
          for (final OtaPackage pkg in versions)
            InkWell(
              onTap: () => onPick(pkg),
              child: Padding(
                padding: EdgeInsets.fromLTRB(26.w, 6.h, 4.w, 6.h),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            pkg.build.isEmpty ? pkg.version : pkg.build,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: scheme.onSurface,
                            ),
                          ),
                          if (pkg.version.isNotEmpty &&
                              pkg.version.toUpperCase() !=
                                  pkg.build.toUpperCase())
                            Padding(
                              padding: EdgeInsets.only(top: 2.h),
                              child: Text(
                                pkg.version,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10.5.sp,
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.north_west_rounded,
                      size: 14.sp,
                      color: scheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}
