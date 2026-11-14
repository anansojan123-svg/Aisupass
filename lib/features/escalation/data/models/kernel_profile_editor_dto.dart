import 'package:Aisupass/features/escalation/domain/models/kernel_profile_editor.dart';
import 'package:Aisupass/generated/cve98260.g.dart' as pigeon;

/// [KernelProfileEditorState] 的传输形态，字段与 `pigeon` 一一对应。
class KernelProfileEditorDto {
  const KernelProfileEditorDto({
    required this.release,
    required this.vulnType,
    required this.detail,
    required this.fields,
  });

  final String release;
  final String vulnType;
  final String detail;
  final List<KernelProfileEditorFieldDto> fields;

  factory KernelProfileEditorDto.fromNative(
    pigeon.KernelProfileEditorState native,
  ) => KernelProfileEditorDto(
    release: native.release,
    vulnType: native.vulnType,
    detail: native.detail,
    fields: native.fields
        .map(KernelProfileEditorFieldDto.fromNative)
        .toList(growable: false),
  );

  KernelProfileEditorState toEntity() => KernelProfileEditorState(
    release: release,
    vulnType: vulnType,
    detail: detail,
    fields: fields
        .map((KernelProfileEditorFieldDto field) => field.toEntity())
        .toList(growable: false),
  );
}

/// 单个可编辑字段的传输形态。
class KernelProfileEditorFieldDto {
  const KernelProfileEditorFieldDto({
    required this.path,
    required this.value,
    required this.hex,
    required this.advanced,
  });

  final String path;
  final String value;
  final bool hex;
  final bool advanced;

  factory KernelProfileEditorFieldDto.fromNative(
    pigeon.KernelProfileFieldValue native,
  ) => KernelProfileEditorFieldDto(
    path: native.path,
    value: native.value,
    hex: native.hex,
    advanced: native.advanced,
  );

  KernelProfileEditorField toEntity() => KernelProfileEditorField(
    path: path,
    value: value,
    hex: hex,
    advanced: advanced,
  );
}
