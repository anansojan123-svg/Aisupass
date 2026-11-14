import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_tool.freezed.dart';

/// 工具执行函数，入参为模型给出的 JSON 参数。
typedef ChatToolExecutor =
    Future<String> Function(Map<String, dynamic> arguments);

/// 提供给模型的本地工具定义。
@freezed
abstract class ChatToolDefinition with _$ChatToolDefinition {
  const ChatToolDefinition._();

  const factory ChatToolDefinition({
    required String name,
    required String description,

    /// JSON Schema 形式的参数定义。
    required Map<String, dynamic> parameters,
    required ChatToolExecutor execute,
  }) = _ChatToolDefinition;
}
