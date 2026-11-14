/// 编辑器的单个字段。
class KernelProfileEditorField {
  const KernelProfileEditorField({
    required this.path,
    required this.value,
    required this.hex,
    required this.advanced,
  });

  /// 点分路径，如 `offset.timer_link`。
  final String path;

  /// 十进制字符串；空串表示 profile 未提供该字段。
  final String value;

  /// true 表示 64 位地址，按十六进制展示与输入。
  final bool hex;

  /// true 表示归入「高级布局」分组。
  final bool advanced;

  /// 末段键名，用于显示。
  String get name => path.split('.').last;
}

/// 一次编辑器读取结果；[release] 为空串表示没有可编辑的用户文档。
class KernelProfileEditorState {
  const KernelProfileEditorState({
    required this.release,
    required this.vulnType,
    required this.detail,
    required this.fields,
  });

  final String release;

  final String vulnType;

  final String detail;

  final List<KernelProfileEditorField> fields;

  bool get available => release.isNotEmpty;
}
