import 'package:Aisupass/features/escalation/data/datasources/kernel_profile_query_datasource.dart';
import 'package:Aisupass/features/escalation/data/models/kernel_profile_dto.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile_editor.dart';
import 'package:Aisupass/features/escalation/domain/repositories/kernel_profile_query_repository.dart';

/// 只读仓储实现。DTO -> Entity 转换点之一。
class KernelProfileQueryRepositoryImpl implements KernelProfileQueryRepository {
  const KernelProfileQueryRepositoryImpl({required this._datasource});

  final KernelProfileQueryDatasource _datasource;

  @override
  Future<List<KernelProfile>> listImported() async {
    final List<KernelProfileDto> dtos = await _datasource
        .listImportedProfiles();
    return dtos
        .map((KernelProfileDto dto) => dto.toEntity())
        .toList(growable: false);
  }

  @override
  Future<List<KernelProfile>> listBuiltin() async {
    final List<KernelProfileDto> dtos = await _datasource.listBuiltinProfiles();
    return dtos
        .map((KernelProfileDto dto) => dto.toEntity())
        .toList(growable: false);
  }

  @override
  Future<String> readContent({required String name, required String release}) =>
      _datasource.readProfileText(name: name, release: release);

  @override
  Future<KernelProfileEditorState> readEditor({required String name}) async =>
      (await _datasource.readEditor(name: name)).toEntity();

  @override
  Future<String> activeImportedProfile() => _datasource.activeImportedProfile();
}
