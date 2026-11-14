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

/// 保存动作：写回本文档 / 另存为新文档 / 导出到本地文件。
enum _SaveAction { writeBack, saveAsDocument, exportFile }

/// GhostKey 用户内核表的字段编辑器。
///
/// 只有用户导入文档可编辑；release 是匹配键，只读。
class KernelProfileEditPage extends HookConsumerWidget {
  const KernelProfileEditPage({super.key, required this.name});

  /// 目标用户文档名（含 `.conf`）。
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final AsyncValue<KernelProfileEditorState> editorAsync = ref.watch(
      kernelProfileEditorProvider(name: name),
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
                    itemBuilder: (BuildContext _) =>
                        <PopupMenuEntry<_SaveAction>>[
                          _menuEntry(
                            value: _SaveAction.writeBack,
                            icon: Icons.save_alt_rounded,
                            title: l10n.kernelProfileEditWriteBack,
                            subtitle: l10n.kernelProfileEditWriteBackHint,
                          ),
                          _menuEntry(
                            value: _SaveAction.saveAsDocument,
                            icon: Icons.content_copy_rounded,
                            title: l10n.kernelProfileEditSaveAs,
                            subtitle: l10n.kernelProfileEditSaveAsHint,
                          ),
                          _menuEntry(
                            value: _SaveAction.exportFile,
                            icon: Icons.file_download_outlined,
                            title: l10n.kernelProfileEditExport,
                            subtitle: l10n.kernelProfileEditExportHint,
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
              ref.invalidate(kernelProfileEditorProvider(name: name)),
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
      ToastMessage.error(
        l10n.kernelProfileEditInvalidFields(invalid.join(', ')),
      );
      return;
    }
    if (changed.isEmpty) {
      ToastMessage.warning(l10n.kernelProfileEditNoChange);
      return;
    }

    busy.value = true;
    try {
      switch (action) {
        case _SaveAction.writeBack:
          final result = await ref
              .read(kernelProfileActionsProvider)
              .saveEditor(name: state.name, values: changed);
          if (!context.mounted) return;
          if (result.ok) {
            draft.value = const <String, String>{};
            ToastMessage.success(l10n.kernelProfileEditSaved);
          } else {
            ToastMessage.error(kernelProfileEditErrorText(l10n, result));
          }
        case _SaveAction.saveAsDocument:
          if (!context.mounted) return;
          final String? documentName = await _promptDocumentName(
            context,
            _defaultCopyName(state.name),
          );
          if (documentName == null) return;
          final String saved = await ref
              .read(kernelProfileActionsProvider)
              .saveEditorAs(
                name: state.name,
                documentName: documentName,
                values: changed,
              );
          if (!context.mounted) return;
          if (saved.isEmpty) {
            ToastMessage.error(l10n.kernelProfileEditSaveFailed);
          } else {
            draft.value = const <String, String>{};
            ToastMessage.success(l10n.kernelProfileEditSavedAs(saved));
          }
        case _SaveAction.exportFile:
          final String text = await ref
              .read(kernelProfileActionsProvider)
              .renderEditor(name: state.name, values: changed);
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

  /// 另存为的默认名字：原文档名去掉 `.conf` 后加 `-copy`。
  String _defaultCopyName(String name) {
    final String stem = name.toLowerCase().endsWith('.conf')
        ? name.substring(0, name.length - 5)
        : name;
    return '$stem-copy';
  }

  /// 输入新文档名；取消返回 null，留空按默认名生成。
  Future<String?> _promptDocumentName(BuildContext context, String initial) =>
      showDialog<String>(
        context: context,
        builder: (BuildContext _) => _DocumentNameDialog(initial: initial),
      );

  /// 让用户选择路径保存 .conf 文本。
  Future<void> _saveTextFile(
    BuildContext context,
    String release,
    String text,
  ) async {
    await FilePicker.saveFile(
      dialogTitle: context.l10n.kernelProfileEditExport,
      fileName: '${release.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_')}.conf',
      bytes: utf8.encode(text),
      type: FileType.any,
    );
  }
}

/// 另存为文档名输入框。
class _DocumentNameDialog extends HookWidget {
  const _DocumentNameDialog({required this.initial});

  final String initial;

  static const String _suffix = '.conf';

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final TextEditingController controller = useTextEditingController(
      text: initial,
    );

    void submit() {
      /* 用户手动补了后缀也剥掉，避免出现 xx.conf.conf。 */
      String name = controller.text.trim();
      if (name.toLowerCase().endsWith(_suffix)) {
        name = name.substring(0, name.length - _suffix.length).trim();
      }
      Navigator.of(context).pop(name);
    }

    return AlertDialog(
      title: Text(l10n.kernelProfileEditSaveAs),
      content: TextField(
        controller: controller,
        autofocus: true,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => submit(),
        decoration: InputDecoration(
          hintText: l10n.kernelProfileEditSaveAsHint,
          suffixText: _suffix,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.aiCancel),
        ),
        FilledButton(onPressed: submit, child: Text(l10n.aiSave)),
      ],
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
          SizedBox(height: 6.h),
          Text(
            '${l10n.kernelProfileEditDocument} · ${state.name}',
            style: TextStyle(
              fontSize: 11.sp,
              fontFamily: AppFonts.code,
              color: scheme.onSurfaceVariant,
            ),
          ),
          if (state.detail.isNotEmpty) ...<Widget>[
            SizedBox(height: 4.h),
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
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
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
