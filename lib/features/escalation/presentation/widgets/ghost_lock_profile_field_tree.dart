import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_profile_field_node.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 高级字段树：分组可折叠，叶子按「失焦或回车」提交。
///
/// 纯展示组件，不读 Provider；写操作由上层传 [onSubmit] 进来。
class GhostLockProfileFieldTree extends StatelessWidget {
  const GhostLockProfileFieldTree({
    super.key,
    required this.nodes,
    required this.invalidPaths,
    required this.onSubmit,
  });

  final List<GhostLockProfileFieldNode> nodes;

  /// 违规字段的完整路径集合。
  final List<String> invalidPaths;

  /// 叶子提交：完整点分路径 + 新值。
  final void Function(String path, int value) onSubmit;

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
                  onSubmit: onSubmit,
                )
              : _LeafField(
                  node: node,
                  invalid: invalidPaths.contains(node.path),
                  onSubmit: onSubmit,
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
    required this.onSubmit,
  });

  final GhostLockProfileFieldNode node;
  final List<String> invalidPaths;
  final void Function(String path, int value) onSubmit;

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
          onSubmit: onSubmit,
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
class _LeafField extends HookWidget {
  const _LeafField({
    required this.node,
    required this.invalid,
    required this.onSubmit,
  });

  final GhostLockProfileFieldNode node;
  final bool invalid;
  final void Function(String path, int value) onSubmit;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final TextEditingController controller = useTextEditingController(
      text: _textOf(node),
    );
    final FocusNode focusNode = useFocusNode();

    void submit() {
      final String text = controller.text.trim();
      if (text.isEmpty) return;
      final int? value = int.tryParse(text);
      if (value == null) return;
      if (node.provided && value == node.value) return;
      onSubmit(node.path, value);
    }

    // 失焦即提交：避免每敲一个字符打一次原生调用。
    useEffect(() {
      void onFocusChanged() {
        if (!focusNode.hasFocus) submit();
      }

      focusNode.addListener(onFocusChanged);
      return () => focusNode.removeListener(onFocusChanged);
    }, <Object?>[
      focusNode,
      controller,
      node.path,
      node.value,
      node.provided,
    ]);

    // 服务端值变化且未聚焦时回填，避免打断正在输入的内容。
    useEffect(() {
      final String next = _textOf(node);
      if (!focusNode.hasFocus && controller.text != next) controller.text = next;
      return null;
    }, <Object?>[node.value, node.provided, focusNode, controller]);

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
              focusNode: focusNode,
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => submit(),
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
