import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/tool_schema.dart';
import 'package:Aisupass/features/escalation/domain/models/run_log_diagnosis.dart';
import 'package:Aisupass/features/escalation/domain/models/run_log_meta.dart';
import 'package:Aisupass/features/escalation/presentation/providers/run_log_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/run_log_query_provider.dart';

/// 运行日志只读工具。
List<ChatToolDefinition> runLogTools(Ref ref) => <ChatToolDefinition>[
  ChatToolDefinition(
    name: 'run_log_list_runs',
    description:
        'List historical run logs, newest first. Each entry carries fileName '
        'that can be used by other run-log tools.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'limit': intProperty(
          description: 'Maximum number of entries to return, default 20.',
          minimum: 1,
          maximum: 100,
        ),
      },
    ),
    execute: (Map<String, dynamic> arguments) async {
      final int limit = intArg(arguments, 'limit', fallback: 20) ?? 20;
      final List<RunLogMeta> metas = await ref.read(runLogsProvider.future);
      return jsonEncode(<String, Object?>{
        'total': metas.length,
        'items': <Map<String, Object?>>[
          for (final RunLogMeta meta in metas.take(limit)) _metaJson(meta),
        ],
      });
    },
  ),
  ChatToolDefinition(
    name: 'run_log_read_body',
    description:
        'Read the body lines of one run log by its fileName.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'fileName': stringProperty(
          description: 'Run log fileName from run_log_list_runs.',
        ),
      },
      required: <String>['fileName'],
    ),
    execute: (Map<String, dynamic> arguments) async {
      final String fileName = requireString(arguments, 'fileName');
      final List<String> lines = await ref.read(
        runLogBodyProvider(fileName: fileName).future,
      );
      return jsonEncode(<String, Object?>{
        'fileName': fileName,
        'lineCount': lines.length,
        'lines': lines,
      });
    },
  ),
  ChatToolDefinition(
    name: 'run_log_export_all',
    description: 'Export all run logs as a single text payload.',
    parameters: noArgsSchema,
    execute: (Map<String, dynamic> arguments) async {
      final String text = await ref.read(
        exportAllRunLogsProvider.future,
      );
      return jsonEncode(<String, Object?>{'text': text});
    },
  ),
  ChatToolDefinition(
    name: 'run_log_diagnose',
    description:
        'Diagnose a failed run log. Returns a stable rule id, stage, evidence '
        'lines and exit code. exitCode defaults to the value recorded in the '
        'log metadata.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'fileName': stringProperty(
          description: 'Run log fileName from run_log_list_runs.',
        ),
        'exitCode': intProperty(
          description: 'Optional exit code override for diagnosis.',
        ),
      },
      required: <String>['fileName'],
    ),
    execute: (Map<String, dynamic> arguments) async {
      final String fileName = requireString(arguments, 'fileName');
      final List<RunLogMeta> metas = await ref.read(runLogsProvider.future);
      RunLogMeta? meta;
      for (final RunLogMeta item in metas) {
        if (item.fileName == fileName) {
          meta = item;
          break;
        }
      }
      if (meta == null) {
        throw ArgumentError('Run log not found: $fileName');
      }
      final List<String> lines = await ref.read(
        runLogBodyProvider(fileName: fileName).future,
      );
      final int exitCode =
          intArg(arguments, 'exitCode', fallback: meta.exitCode) ??
          meta.exitCode;
      final RunLogDiagnosis diagnosis = await ref.read(
        diagnoseRunLogProvider(lines: lines, exitCode: exitCode).future,
      );
      return jsonEncode(<String, Object?>{
        'ruleId': diagnosis.ruleId,
        'stage': diagnosis.stage,
        'evidence': diagnosis.evidence,
        'exitCode': diagnosis.exitCode,
        'isEmpty': diagnosis.isEmpty,
        'anyStage': diagnosis.anyStage,
        'isFallback': diagnosis.isFallback,
      });
    },
  ),
  ChatToolDefinition(
    name: 'run_log_delete',
    description: 'Delete one run log by its fileName.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'fileName': stringProperty(
          description: 'Run log fileName from run_log_list_runs.',
        ),
      },
      required: <String>['fileName'],
    ),
    execute: (Map<String, dynamic> arguments) async {
      final String fileName = requireString(arguments, 'fileName');
      final RunLogMeta? meta = await _findMeta(ref, fileName);
      if (meta == null) {
        throw ArgumentError('Run log not found: $fileName');
      }
      await ref.read(runLogActionsProvider).delete(meta);
      return jsonEncode(<String, Object?>{'deleted': fileName});
    },
  ),
  ChatToolDefinition(
    name: 'run_log_clear_all',
    description:
        'Delete every run log except the one currently being written.',
    parameters: noArgsSchema,
    execute: (Map<String, dynamic> arguments) async {
      await ref.read(runLogActionsProvider).clear();
      return jsonEncode(<String, Object?>{'cleared': true});
    },
  ),
];

Future<RunLogMeta?> _findMeta(Ref ref, String fileName) async {
  final List<RunLogMeta> metas = await ref.read(runLogsProvider.future);
  for (final RunLogMeta meta in metas) {
    if (meta.fileName == fileName) return meta;
  }
  return null;
}

Map<String, Object?> _metaJson(RunLogMeta meta) => <String, Object?>{
  'fileName': meta.fileName,
  'runId': meta.runId,
  'startedAt': meta.startedAt,
  'result': meta.result.name,
  'exitCode': meta.exitCode,
  'durationMs': meta.durationMs,
  'lineCount': meta.lineCount,
  'device': meta.device,
  'kernel': meta.kernel,
  'profile': meta.profile,
};
