/// 把一个渲染后的 HOCON 对象拍平成「点分路径 → 值文本」的有序表。
///
/// 只覆盖 `HoconSupport.render` 产出的形态：`key = value`、`key = { ... }`
/// 嵌套对象、以及单行内联数组。解析失败的行原样跳过，不抛异常。
Map<String, String> flattenHocon(String text) {
  final Map<String, String> result = <String, String>{};
  final List<String> path = <String>[];

  for (final String rawLine in text.split('\n')) {
    final String line = rawLine.trim();
    if (line.isEmpty || line == '{' || line == '}') {
      if (line == '}') {
        if (path.isNotEmpty) path.removeLast();
      }
      continue;
    }

    final int eq = line.indexOf('=');
    if (eq <= 0) continue;

    final String key = _unquote(line.substring(0, eq).trim());
    final String value = line.substring(eq + 1).trim();
    if (key.isEmpty) continue;

    if (value == '{') {
      path.add(key);
      continue;
    }
    if (value.endsWith('}')) {
      // 形如 `key = {` 已在上面处理；带内容的收尾对象在本渲染器里不会出现。
      continue;
    }
    result[<String>[...path, key].join('.')] = _unquote(value);
  }
  return result;
}

/// 去掉渲染器加上的首尾引号，并还原转义。
String _unquote(String value) {
  if (value.length >= 2 && value.startsWith('"') && value.endsWith('"')) {
    return value
        .substring(1, value.length - 1)
        .replaceAll(r'\n', '\n')
        .replaceAll(r'\t', '\t')
        .replaceAll(r'\"', '"')
        .replaceAll(r'\\', r'\');
  }
  return value;
}
