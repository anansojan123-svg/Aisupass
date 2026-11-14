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
import 'package:Aisupass/core/utils/escalation_reason.dart';
import 'package:Aisupass/features/escalation/domain/models/device_identity.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_active_source.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_profile_config.dart';
import 'package:Aisupass/features/escalation/presentation/controllers/ghost_lock_profile_controller.dart';
import 'package:Aisupass/features/escalation/presentation/pages/tabs/ghost_lock_profile/ghost_lock_profile_tabs.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/ghost_lock_profile_field_tree.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/ghost_lock_profile_menu_entry.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/ghost_lock_profile_status_bar.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// 保存方式：写回当前文件 / 另存为新文档 / 导出到本地。
enum _SaveAction { writeBack, saveAs, export }

/// GhostLock 内核表编辑器：通用参数、路由、高级字段三个页签。
///
/// 所有编辑都落在会话里，保存时才决定写回生效配置或覆盖目标文档。
class GhostLockProfilePage extends HookConsumerWidget {
  const GhostLockProfilePage({super.key, this.name = ''});

  /// 编辑目标文档名；空串表示内置/设备态。
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final GhostLockProfileActions actions = ref.watch(
      ghostLockProfileActionsProvider,
    );
    final GhostLockProfileController flow = useMemoized(
      () => GhostLockProfileController(ref: ref),
      const <Object?>[],
    );
    final AsyncValue<DeviceIdentity> identityAsync = ref.watch(
      currentDeviceIdentityProvider,
    );
    final String deviceRelease = identityAsync.value?.kernelRelease ?? '';
    final ValueNotifier<GhostLockProfileConfig?> draft =
        useState<GhostLockProfileConfig?>(null);
    final ValueNotifier<Object?> failure = useState<Object?>(null);
    /* 会话有可覆盖目标时才允许「保存」；内置/设备态只能另存。 */
    final ValueNotifier<bool> canSaveDirect = useState<bool>(false);
    /* 输入框只登记不提交，保存按钮统一取值。 */
    final ProfileEditDraft editDraft = useState<Map<String, int>>(
      const <String, int>{},
    );

    Future<void> openSession() async {
      if (deviceRelease.isEmpty) return;
      try {
        final GhostLockProfileConfig next = await actions.beginEditSession(
          name: name,
          deviceRelease: deviceRelease,
        );
        final bool live = await actions.editSessionIsLive();
        final String target = await actions.editSessionTarget();
        canSaveDirect.value = live || target.isNotEmpty;
        draft.value = next;
        failure.value = null;
      } catch (error) {
        failure.value = error;
      }
    }

    useEffect(() {
      openSession();
      return () {
        actions.endEditSession();
      };
    }, <Object?>[deviceRelease, name]);

    final GhostLockProfileConfig? config = draft.value;
    /* 生效来源是只读查询，由写操作失效后自动重取。 */
    final GhostLockActiveSource source =
        ref.watch(ghostLockActiveSourceProvider).value ??
        const GhostLockActiveSource(builtin: '', user: '');

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.escalationGhostLockProfileEdit),
        actions: <Widget>[
          PopupMenuButton<_SaveAction>(
            tooltip: l10n.aiSave,
            icon: Icon(Icons.save_rounded, size: 20.sp),
            onSelected: (_SaveAction action) => _handleSaveAction(
              context,
              action,
              config,
              draft,
              editDraft,
              flow,
            ),
            itemBuilder: (BuildContext menuContext) =>
                <PopupMenuEntry<_SaveAction>>[
                  ghostLockProfileMenuEntry<_SaveAction>(
                    menuContext,
                    value: _SaveAction.writeBack,
                    icon: Icons.save_alt_rounded,
                    title: l10n.escalationGhostLockProfileWriteBack,
                    subtitle: canSaveDirect.value
                        ? l10n.escalationGhostLockProfileWriteBackHint
                        : l10n.escalationGhostLockProfileWriteBackDisabled,
                    enabled: canSaveDirect.value,
                  ),
                  ghostLockProfileMenuEntry<_SaveAction>(
                    menuContext,
                    value: _SaveAction.saveAs,
                    icon: Icons.content_copy_rounded,
                    title: l10n.escalationGhostLockProfileSaveAs,
                    subtitle: l10n.escalationGhostLockProfileSaveAsHint,
                  ),
                  ghostLockProfileMenuEntry<_SaveAction>(
                    menuContext,
                    value: _SaveAction.export,
                    icon: Icons.file_download_outlined,
                    title: l10n.escalationGhostLockProfileExport,
                    subtitle: l10n.escalationGhostLockProfileExportHint,
                  ),
                ],
          ),
        ],
      ),
      body: config == null
          ? (failure.value != null
                ? RefError(onRetry: openSession)
                : const Loading())
          : Column(
              children: <Widget>[
                GhostLockProfileStatusBar(
                  config: config,
                  builtin: source.builtin,
                  user: source.user,
                ),
                Expanded(
                  child: config.hasProfile
                      ? GhostLockProfileTabs(
                          config: config,
                          draft: editDraft,
                          onUpdated: (GhostLockProfileConfig next) =>
                              draft.value = next,
                        )
                      : Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32.w),
                            child: Text(
                              l10n.kernelProfileEditorNotEditable,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.5.sp,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  /// 保存菜单的统一入口：按动作调编排，界面提示与状态更新留在这里。
  Future<void> _handleSaveAction(
    BuildContext context,
    _SaveAction action,
    GhostLockProfileConfig? config,
    ValueNotifier<GhostLockProfileConfig?> draft,
    ProfileEditDraft editDraft,
    GhostLockProfileController flow,
  ) async {
    switch (action) {
      case _SaveAction.writeBack:
        try {
          final GhostLockProfileConfig? next = await flow.commitDraft(
            config: config,
            values: editDraft.value,
          );
          if (!context.mounted) return;
          if (next == null) {
            ToastMessage.error(
              context.l10n.escalationGhostLockProfileWriteFailed,
            );
            return;
          }
          draft.value = next;
          editDraft.value = const <String, int>{};
          ToastMessage.success(context.l10n.escalationGhostLockProfileSaved);
        } catch (error) {
          if (!context.mounted) return;
          ToastMessage.error(ghostLockSubmitErrorText(context.l10n, error));
        }
      case _SaveAction.saveAs:
        try {
          await flow.commitDraft(config: config, values: editDraft.value);
          final String created = await flow.saveAsNew();
          if (!context.mounted) return;
          if (created.isEmpty) {
            ToastMessage.error(
              context.l10n.escalationGhostLockProfileWriteFailed,
            );
            return;
          }
          editDraft.value = const <String, int>{};
          ToastMessage.success(
            context.l10n.escalationGhostLockProfileSavedAsNew(created),
          );
        } catch (error) {
          if (!context.mounted) return;
          ToastMessage.error(error);
        }
      case _SaveAction.export:
        if (config == null) return;
        try {
          // Android/iOS 的 saveFile 必须随内容提交，先取渲染文本再落盘。
          final String text = await flow.renderExport(release: config.release);
          if (!context.mounted) return;
          if (text.isEmpty) {
            ToastMessage.error(
              context.l10n.escalationGhostLockProfileWriteFailed,
            );
            return;
          }
          await FilePicker.saveFile(
            dialogTitle: context.l10n.escalationGhostLockProfileExport,
            fileName:
                '${config.release.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_')}.conf',
            bytes: utf8.encode(text),
            type: FileType.any,
          );
        } catch (error) {
          ToastMessage.error(error);
        }
    }
  }
}
