import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_execution_field.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/ghost_lock_profile_field_tree.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/ghost_lock_profile_tab_hint.dart';

/// CPU 对由设备/会话决定，编辑器只展示不写入。
const Set<String> _cpuPairPaths = <String>{
  'execution.selected_cpus.main',
  'execution.selected_cpus.consumer',
};

/// 通用参数页：每行一个 execution 调参，改动由保存按钮统一提交。
class GhostLockProfileGeneralTab extends HookConsumerWidget {
  const GhostLockProfileGeneralTab({
    super.key,
    required this.general,
    required this.draft,
  });

  final List<GhostLockExecutionField> general;
  final ProfileEditDraft draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: GhostLockProfileTabHint(
            text: context.l10n.escalationGhostLockProfileTabGeneralHint,
          ),
        ),
        for (final GhostLockExecutionField field in general)
          _GeneralFieldRow(
            field: field,
            readOnly: _cpuPairPaths.contains(field.path),
            draft: draft,
          ),
      ],
    );
  }
}

/// 通用参数行：末段键名 + 数字输入框 + override 标记。
///
/// [readOnly] 为真时（CPU 对）只展示当前值，不写盘。
class _GeneralFieldRow extends HookWidget {
  const _GeneralFieldRow({
    required this.field,
    required this.readOnly,
    required this.draft,
  });

  final GhostLockExecutionField field;
  final bool readOnly;
  final ProfileEditDraft draft;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    final TextEditingController controller = useTextEditingController(
      text: '${field.value}',
    );

    /* 服务端值变化就强制回填：保存后字段可能因合并而变，旧文本要跟着更新。 */
    final ObjectRef<int> synced = useRef<int>(field.value);
    useEffect(() {
      if (synced.value == field.value) return null;
      synced.value = field.value;
      final String next = '${field.value}';
      if (controller.text != next) controller.text = next;
      return null;
    }, <Object?>[field.value, controller]);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 12.w,
            child: readOnly
                ? Icon(
                    Icons.lock_outline_rounded,
                    size: 11.sp,
                    color: scheme.onSurfaceVariant,
                  )
                : field.overridden
                ? Icon(Icons.circle, size: 6.sp, color: scheme.primary)
                : null,
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: !readOnly,
              onChanged: readOnly
                  ? null
                  : (String text) {
                      final int? value = int.tryParse(text.trim());
                      final Map<String, int> next = Map<String, int>.of(
                        draft.value,
                      );
                      if (value == null) {
                        next.remove(field.path);
                      } else {
                        next[field.path] = value;
                      }
                      draft.value = next;
                    },
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              textInputAction: TextInputAction.next,
              style: TextStyle(fontSize: 13.sp),
              decoration: InputDecoration(
                isDense: true,
                labelText: _lastSegment(field.path),
                labelStyle: TextStyle(
                  fontFamily: AppFonts.code,
                  fontSize: 12.sp,
                ),
                helperText: field.path,
                helperStyle: TextStyle(
                  fontSize: 10.sp,
                  color: scheme.onSurfaceVariant,
                ),
                border: const OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 8.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _lastSegment(String path) => path.split('.').last;
}
