/// 把一个 HOCON 对象拍平成「点分路径 → 值文本」的有序表。
///
/// 同时兼容两种输入：
/// - 渲染器产物：`key = value`、`key = { ... }`、带引号的字符串；
/// - 原生 conf：`key { ... }`（无等号）、行尾 `#` 注释、裸值。
///
/// 数组与解析失败的行原样跳过，不抛异常。
Map<String, String> flattenHocon(String text) {
  final Map<String, String> result = <String, String>{};
  final List<String> path = <String>[];

  for (final String rawLine in text.split('\n')) {
    final String line = _stripComment(rawLine).trim();
    if (line.isEmpty) continue;

    if (line == '}') {
      if (path.isNotEmpty) path.removeLast();
      continue;
    }

    // 块起始：`key {` 或 `key = {`。
    if (line.endsWith('{')) {
      final int colon = line.indexOf('=');
      final String key = _unquote(
        (colon >= 0
                ? line.substring(0, colon)
                : line.substring(0, line.length - 1))
            .trim(),
      );
      if (key.isNotEmpty) path.add(key);
      continue;
    }

    final int eq = line.indexOf('=');
    if (eq <= 0) continue;

    final String key = _unquote(line.substring(0, eq).trim());
    final String value = line.substring(eq + 1).trim();
    if (key.isEmpty || value.isEmpty) continue;
    result[<String>[...path, key].join('.')] = _unquote(value);
  }
  return result;
}

/// 去掉行尾 `#` 注释（引号内的 `#` 保留）。
String _stripComment(String line) {
  bool quoted = false;
  for (int i = 0; i < line.length; i++) {
    final String c = line[i];
    if (c == '"') {
      quoted = !quoted;
    } else if (c == '#' && !quoted) {
      return line.substring(0, i);
    }
  }
  return line;
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
