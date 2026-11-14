import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_profile_field_node.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 编辑中的表单状态：字段随输入写进这里，保存时一次性提交。
///
/// 只有用户真正改过的字段会留在里面，未触碰的字段不参与提交。
class ProfileEditDraft {
  final Map<String, int> _changed = <String, int>{};

  /// 输入变化时调用；清空或非法输入视为撤销该字段的修改。
  void update(String path, String text) {
    final int? value = int.tryParse(text.trim());
    if (value == null) {
      _changed.remove(path);
    } else {
      _changed[path] = value;
    }
  }

  Map<String, int> collect() => Map<String, int>.of(_changed);

  void clear() => _changed.clear();
}

/// 高级字段树：分组可折叠，叶子是纯输入框，改动由保存按钮统一提交。
class GhostLockProfileFieldTree extends StatelessWidget {
  const GhostLockProfileFieldTree({
    super.key,
    required this.nodes,
    required this.invalidPaths,
    required this.draft,
  });

  final List<GhostLockProfileFieldNode> nodes;

  /// 违规字段的完整路径集合。
  final List<String> invalidPaths;

  final ProfileEditDraft draft;

  @override
  Widget build(BuildContext context) {
    if (nodes.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (final GhostLockProfileFieldNode node in nodes)
          node.isGroup
              ? _GroupNode(
                  node: node,
                  invalidPaths: invalidPaths,
                  draft: draft,
                )
              : _LeafField(
                  node: node,
                  invalid: invalidPaths.contains(node.path),
                  draft: draft,
                ),
      ],
    );
  }
}

/// 分组节点：标题为末段键名，副标题为 override 子节点数。
class _GroupNode extends StatelessWidget {
  const _GroupNode({
    required this.node,
    required this.invalidPaths,
    required this.draft,
  });

  final GhostLockProfileFieldNode node;
  final List<String> invalidPaths;
  final ProfileEditDraft draft;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final int overridden = _countOverridden(node);

    return ExpansionTile(
      tilePadding: EdgeInsets.symmetric(horizontal: 16.w),
      childrenPadding: EdgeInsets.zero,
      title: Text(
        node.name,
        style: TextStyle(
          fontFamily: AppFonts.code,
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: node.overridden ? scheme.primary : scheme.onSurface,
        ),
      ),
      subtitle: overridden == 0
          ? null
          : Text(
              '$overridden ${l10n.escalationGhostLockProfileOverridden}',
              style: TextStyle(fontSize: 11.sp, color: scheme.primary),
            ),
      children: <Widget>[
        GhostLockProfileFieldTree(
          nodes: node.children,
          invalidPaths: invalidPaths,
          draft: draft,
        ),
      ],
    );
  }

  int _countOverridden(GhostLockProfileFieldNode node) {
    if (!node.isGroup) return node.overridden ? 1 : 0;
    return node.children.fold<int>(
      0,
      (int sum, GhostLockProfileFieldNode child) => sum + _countOverridden(child),
    );
  }
}

/// 叶子字段：数字输入框，允许负数；未提供时留空并显示提示。
///
/// 输入只写进 [ProfileEditDraft]，保存按钮统一提交。
class _LeafField extends HookWidget {
  const _LeafField({
    required this.node,
    required this.invalid,
    required this.draft,
  });

  final GhostLockProfileFieldNode node;
  final bool invalid;
  final ProfileEditDraft draft;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final TextEditingController controller = useTextEditingController(
      text: _textOf(node),
    );

    /* 服务端值变化就强制回填：保存后字段可能因合并而变，旧文本要跟着更新。 */
    final ObjectRef<String> synced = useRef<String>(_textOf(node));
    useEffect(() {
      final String next = _textOf(node);
      if (synced.value == next) return null;
      synced.value = next;
      if (controller.text != next) controller.text = next;
      return null;
    }, <Object?>[node.value, node.provided, controller]);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 8.w,
            child: node.overridden
                ? Icon(Icons.circle, size: 6.sp, color: scheme.primary)
                : null,
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: (String text) => draft.update(node.path, text),
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              textInputAction: TextInputAction.next,
              style: TextStyle(fontSize: 13.sp),
              decoration: InputDecoration(
                isDense: true,
                labelText: node.name,
                labelStyle: TextStyle(fontSize: 12.sp),
                hintText: node.provided
                    ? null
                    : l10n.escalationGhostLockProfileNotProvided,
                helperText: node.path,
                helperStyle: TextStyle(
                  fontSize: 10.sp,
                  color: scheme.onSurfaceVariant,
                ),
                errorText:
                    invalid ? l10n.escalationGhostLockProfileInvalidField : null,
                errorStyle: TextStyle(fontSize: 10.sp),
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

  String _textOf(GhostLockProfileFieldNode field) =>
      field.provided ? '${field.value}' : '';
}
