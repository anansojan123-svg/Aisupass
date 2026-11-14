import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/core/utils/kernel_profile_text.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile_editor.dart';
import 'package:Aisupass/features/escalation/presentation/providers/kernel_profile_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/kernel_profile_query_provider.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// 保存菜单动作：写回原文档 / 另存为文件 / 导出原始文档。
enum _SaveAction { writeBack, saveAs, exportOriginal }

/// GhostKey 用户内核表的字段编辑器。
///
/// 只有用户导入文档可编辑；release 是匹配键，只读。
class KernelProfileEditPage extends HookConsumerWidget {
  const KernelProfileEditPage({super.key, required this.release});

  /// 目标用户文档的 release。
  final String release;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final AsyncValue<KernelProfileEditorState> editorAsync = ref.watch(
      kernelProfileEditorProvider(release: release),
    );
    /* 只登记用户改过的输入，保存时统一提交。 */
    final ValueNotifier<Map<String, String>> draft =
        useState<Map<String, String>>(const <String, String>{});
    final ValueNotifier<bool> busy = useState<bool>(false);
    final bool isBusy = useValueListenable(busy);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.kernelProfileEditTitle),
        actions: <Widget>[
          editorAsync.maybeWhen(
            data: (KernelProfileEditorState state) => state.available
                ? PopupMenuButton<_SaveAction>(
                    tooltip: l10n.aiSave,
                    icon: Icon(Icons.save_rounded, size: 20.sp),
                    enabled: !isBusy,
                    onSelected: (_SaveAction action) => _handleSaveAction(
                      context,
                      ref,
                      state,
                      draft,
                      busy,
                      action,
                    ),
                    itemBuilder: (BuildContext _) => <PopupMenuEntry<_SaveAction>>[
                      _menuEntry(
                        value: _SaveAction.writeBack,
                        icon: Icons.save_alt_rounded,
                        title: l10n.kernelProfileEditWriteBack,
                        subtitle: l10n.kernelProfileEditWriteBackHint,
                      ),
                      _menuEntry(
                        value: _SaveAction.saveAs,
                        icon: Icons.file_download_outlined,
                        title: l10n.kernelProfileEditSaveAs,
                        subtitle: l10n.kernelProfileEditSaveAsHint,
                      ),
                      _menuEntry(
                        value: _SaveAction.exportOriginal,
                        icon: Icons.description_outlined,
                        title: l10n.kernelProfileEditExportOriginal,
                        subtitle: l10n.kernelProfileEditExportOriginalHint,
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: editorAsync.when(
        loading: () => const Loading(),
        error: (Object _, StackTrace _) => RefError(
          onRetry: () =>
              ref.invalidate(kernelProfileEditorProvider(release: release)),
        ),
        data: (KernelProfileEditorState state) {
          if (!state.available) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Text(
                  l10n.kernelProfileEditNotEditable,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }
          final List<KernelProfileEditorField> basic = state.fields
              .where((KernelProfileEditorField f) => !f.advanced)
              .toList(growable: false);
          final List<KernelProfileEditorField> advanced = state.fields
              .where((KernelProfileEditorField f) => f.advanced)
              .toList(growable: false);

          return ListView(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 28.h),
            children: <Widget>[
              _HeaderCard(state: state),
              SizedBox(height: 8.h),
              Text(
                l10n.kernelProfileEditInputHint,
                style: TextStyle(
                  fontSize: 10.5.sp,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 10.h),
              _SectionTitle(text: l10n.kernelProfileEditBasicSection),
              for (final KernelProfileEditorField field in basic)
                _EditorField(
                  key: ValueKey<String>(field.path),
                  field: field,
                  draft: draft,
                ),
              SizedBox(height: 8.h),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                childrenPadding: EdgeInsets.only(bottom: 6.h),
                title: Text(
                  l10n.kernelProfileEditAdvancedSection,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                children: <Widget>[
                  for (final KernelProfileEditorField field in advanced)
                    _EditorField(
                      key: ValueKey<String>(field.path),
                      field: field,
                      draft: draft,
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  /// 保存菜单的统一入口：先汇总草稿，再按动作落盘或导出。
  Future<void> _handleSaveAction(
    BuildContext context,
    WidgetRef ref,
    KernelProfileEditorState state,
    ValueNotifier<Map<String, String>> draft,
    ValueNotifier<bool> busy,
    _SaveAction action,
  ) async {
    final AppLocalizations l10n = context.l10n;
    if (action == _SaveAction.exportOriginal) {
      await _exportOriginal(context, ref, state);
      return;
    }

    final Map<String, String> changed = <String, String>{};
    final List<String> invalid = <String>[];
    for (final KernelProfileEditorField field in state.fields) {
      final String original = _displayValue(field);
      final String text = (draft.value[field.path] ?? original).trim();
      if (text == original) continue;
      if (text.isEmpty || _parseValue(text) == null) {
        invalid.add(field.path);
      } else {
        changed[field.path] = text;
      }
    }
    if (invalid.isNotEmpty) {
      ToastMessage.error(l10n.kernelProfileEditInvalidFields(invalid.join(', ')));
      return;
    }
    if (changed.isEmpty) {
      ToastMessage.warning(l10n.kernelProfileEditNoChange);
      return;
    }

    busy.value = true;
    try {
      if (action == _SaveAction.writeBack) {
        final result = await ref
            .read(kernelProfileActionsProvider)
            .saveEditor(release: state.release, values: changed);
        if (!context.mounted) return;
        if (result.ok) {
          draft.value = const <String, String>{};
          ToastMessage.success(l10n.kernelProfileEditSaved);
        } else {
          ToastMessage.error(kernelProfileEditErrorText(l10n, result));
        }
      } else {
        final String text = await ref
            .read(kernelProfileActionsProvider)
            .renderEditor(release: state.release, values: changed);
        if (!context.mounted) return;
        if (text.isEmpty) {
          ToastMessage.error(l10n.kernelProfileEditExportFailed);
          return;
        }
        await _saveTextFile(context, state.release, text);
      }
    } catch (error) {
      if (context.mounted) ToastMessage.error(error);
    } finally {
      busy.value = false;
    }
  }

  /// 导出未修改的原始文档，便于编辑前备份。
  Future<void> _exportOriginal(
    BuildContext context,
    WidgetRef ref,
    KernelProfileEditorState state,
  ) async {
    final AppLocalizations l10n = context.l10n;
    try {
      final String text = await ref.read(
        kernelProfileContentProvider(release: state.release).future,
      );
      if (!context.mounted) return;
      if (text.trim().isEmpty) {
        ToastMessage.error(l10n.kernelProfileEditExportFailed);
        return;
      }
      await _saveTextFile(context, state.release, text);
    } catch (error) {
      if (context.mounted) ToastMessage.error(error);
    }
  }

  /// 让用户选择路径保存 .conf 文本。
  Future<void> _saveTextFile(
    BuildContext context,
    String release,
    String text,
  ) async {
    await FilePicker.saveFile(
      dialogTitle: context.l10n.kernelProfileEditSaveAs,
      fileName:
          '${release.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_')}.conf',
      bytes: utf8.encode(text),
      type: FileType.any,
    );
  }
}

/// AppBar 菜单项：图标 + 标题 + 副标题。
PopupMenuItem<_SaveAction> _menuEntry({
  required _SaveAction value,
  required IconData icon,
  required String title,
  required String subtitle,
}) => PopupMenuItem<_SaveAction>(
  value: value,
  child: Row(
    children: <Widget>[
      Icon(icon, size: 18.r),
      SizedBox(width: 10.w),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(title, style: TextStyle(fontSize: 12.5.sp)),
            Text(
              subtitle,
              style: TextStyle(fontSize: 10.sp, color: Colors.grey),
            ),
          ],
        ),
      ),
    ],
  ),
);

/// 顶部信息卡：release 只读 + 漏洞类型 + 来源。
class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.state});

  final KernelProfileEditorState state;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.kernelProfileEditReleaseLabel,
            style: TextStyle(fontSize: 10.5.sp, color: scheme.onSurfaceVariant),
          ),
          SizedBox(height: 2.h),
          SelectableText(
            state.release,
            style: TextStyle(
              fontSize: 12.5.sp,
              fontFamily: AppFonts.code,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            l10n.kernelProfileEditReleaseHint,
            style: TextStyle(fontSize: 10.5.sp, color: scheme.onSurfaceVariant),
          ),
          if (state.detail.isNotEmpty) ...<Widget>[
            SizedBox(height: 6.h),
            Text(
              '${l10n.kernelProfileEditSource} · ${state.detail}',
              style: TextStyle(fontSize: 11.sp, color: scheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

/// 分区标题。
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 4.h),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        color: context.colorScheme.onSurfaceVariant,
      ),
    ),
  );
}

/// 单个字段输入框：改动只写进草稿，保存时统一提交。
class _EditorField extends HookWidget {
  const _EditorField({super.key, required this.field, required this.draft});

  final KernelProfileEditorField field;

  final ValueNotifier<Map<String, String>> draft;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    final String initial = _displayValue(field);
    final TextEditingController controller = useTextEditingController(
      text: initial,
    );
    /* 保存后回到原值时强制回填，避免留下格式化差异（如 0x 与十进制）。 */
    final ObjectRef<String> synced = useRef<String>(initial);
    useEffect(() {
      if (synced.value == initial) return null;
      synced.value = initial;
      if (controller.text != initial) controller.text = initial;
      return null;
    }, <Object?>[initial, controller]);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: TextField(
        controller: controller,
        onChanged: (String text) {
          final Map<String, String> next = Map<String, String>.of(draft.value);
          if (text.trim() == initial) {
            next.remove(field.path);
          } else {
            next[field.path] = text.trim();
          }
          draft.value = next;
        },
        keyboardType: field.hex
            ? TextInputType.text
            : const TextInputType.numberWithOptions(signed: true),
        textInputAction: TextInputAction.next,
        style: TextStyle(fontSize: 12.5.sp, fontFamily: AppFonts.code),
        decoration: InputDecoration(
          isDense: true,
          labelText: field.name,
          labelStyle: TextStyle(fontSize: 11.5.sp),
          helperText: field.path,
          helperStyle: TextStyle(
            fontSize: 9.5.sp,
            color: scheme.onSurfaceVariant,
          ),
          border: const OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 8.h,
          ),
        ),
      ),
    );
  }
}

/// 当前值的展示文本：64 位地址按无符号十六进制，其余保持十进制。
String _displayValue(KernelProfileEditorField field) {
  if (field.value.isEmpty) return '';
  return field.hex ? kernelProfileHex(field.value) : field.value;
}

/// 解析输入：支持 `0x` 十六进制（按 64 位无符号回绕）与十进制负数。
int? _parseValue(String text) {
  final String value = text.trim();
  if (value.isEmpty) return null;
  if (value.toLowerCase().startsWith('0x')) {
    final BigInt? raw = BigInt.tryParse(value.substring(2), radix: 16);
    if (raw == null) return null;
    final BigInt sign = BigInt.one << 63;
    final BigInt total = BigInt.one << 64;
    return (raw >= sign ? raw - total : raw).toInt();
  }
  return int.tryParse(value);
}
