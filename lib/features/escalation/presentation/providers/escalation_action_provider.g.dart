// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'escalation_action_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 提权链路执行数据源。

@ProviderFor(escalationActionDatasource)
const escalationActionDatasourceProvider =
    EscalationActionDatasourceProvider._();

/// 提权链路执行数据源。

final class EscalationActionDatasourceProvider
    extends
        $FunctionalProvider<
          EscalationActionDatasource,
          EscalationActionDatasource,
          EscalationActionDatasource
        >
    with $Provider<EscalationActionDatasource> {
  /// 提权链路执行数据源。
  const EscalationActionDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'escalationActionDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$escalationActionDatasourceHash();

  @$internal
  @override
  $ProviderElement<EscalationActionDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EscalationActionDatasource create(Ref ref) {
    return escalationActionDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EscalationActionDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EscalationActionDatasource>(value),
    );
  }
}

String _$escalationActionDatasourceHash() =>
    r'033cb08c2ea1d7d43ed2f87cf285a4f223d499e4';

/// 提权链路执行仓储。

@ProviderFor(escalationActionRepository)
const escalationActionRepositoryProvider =
    EscalationActionRepositoryProvider._();

/// 提权链路执行仓储。

final class EscalationActionRepositoryProvider
    extends
        $FunctionalProvider<
          EscalationActionRepository,
          EscalationActionRepository,
          EscalationActionRepository
        >
    with $Provider<EscalationActionRepository> {
  /// 提权链路执行仓储。
  const EscalationActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'escalationActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$escalationActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<EscalationActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EscalationActionRepository create(Ref ref) {
    return escalationActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EscalationActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EscalationActionRepository>(value),
    );
  }
}

String _$escalationActionRepositoryHash() =>
    r'874eb12d3417e136b6da44f7903cdf1a1a2dafe8';

/// 自动匹配并拼出执行载荷的那一行命令。
///
/// 「选哪份」归查询仓储，「拼命令」归执行仓储，两者的装配只在这里发生。

@ProviderFor(runPayload)
const runPayloadProvider = RunPayloadProvider._();

/// 自动匹配并拼出执行载荷的那一行命令。
///
/// 「选哪份」归查询仓储，「拼命令」归执行仓储，两者的装配只在这里发生。

final class RunPayloadProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// 自动匹配并拼出执行载荷的那一行命令。
  ///
  /// 「选哪份」归查询仓储，「拼命令」归执行仓储，两者的装配只在这里发生。
  const RunPayloadProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'runPayloadProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$runPayloadHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return runPayload(ref);
  }
}

String _$runPayloadHash() => r'a30cc1e659d1860e8f111ae4dd2d1bd4c9bc4193';

/// 用指定载荷拼出执行命令，跳过自动匹配。
///
/// 与 [runPayload] 共用执行仓储，区别只在「哪一条」是调用方给的，还是查出来的。
/// 用户在载荷清单里手动指定时走这里。

@ProviderFor(runPayloadChoice)
const runPayloadChoiceProvider = RunPayloadChoiceFamily._();

/// 用指定载荷拼出执行命令，跳过自动匹配。
///
/// 与 [runPayload] 共用执行仓储，区别只在「哪一条」是调用方给的，还是查出来的。
/// 用户在载荷清单里手动指定时走这里。

final class RunPayloadChoiceProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// 用指定载荷拼出执行命令，跳过自动匹配。
  ///
  /// 与 [runPayload] 共用执行仓储，区别只在「哪一条」是调用方给的，还是查出来的。
  /// 用户在载荷清单里手动指定时走这里。
  const RunPayloadChoiceProvider._({
    required RunPayloadChoiceFamily super.from,
    required Payload super.argument,
  }) : super(
         retry: null,
         name: r'runPayloadChoiceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$runPayloadChoiceHash();

  @override
  String toString() {
    return r'runPayloadChoiceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument = this.argument as Payload;
    return runPayloadChoice(ref, payload: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RunPayloadChoiceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$runPayloadChoiceHash() => r'8ccf60befdebf6f7959aaf38a6725b3b0541f4d8';

/// 用指定载荷拼出执行命令，跳过自动匹配。
///
/// 与 [runPayload] 共用执行仓储，区别只在「哪一条」是调用方给的，还是查出来的。
/// 用户在载荷清单里手动指定时走这里。

final class RunPayloadChoiceFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String>, Payload> {
  const RunPayloadChoiceFamily._()
    : super(
        retry: null,
        name: r'runPayloadChoiceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 用指定载荷拼出执行命令，跳过自动匹配。
  ///
  /// 与 [runPayload] 共用执行仓储，区别只在「哪一条」是调用方给的，还是查出来的。
  /// 用户在载荷清单里手动指定时走这里。

  RunPayloadChoiceProvider call({required Payload payload}) =>
      RunPayloadChoiceProvider._(argument: payload, from: this);

  @override
  String toString() => r'runPayloadChoiceProvider';
}

/// 把临时 root 移交给用户选定的 [manager]。
///
/// 管理器未安装时返回 [HandoffKind.managerMissing]，不抛异常。

@ProviderFor(handoffRoot)
const handoffRootProvider = HandoffRootFamily._();

/// 把临时 root 移交给用户选定的 [manager]。
///
/// 管理器未安装时返回 [HandoffKind.managerMissing]，不抛异常。

final class HandoffRootProvider
    extends
        $FunctionalProvider<
          AsyncValue<HandoffOutcome>,
          HandoffOutcome,
          FutureOr<HandoffOutcome>
        >
    with $FutureModifier<HandoffOutcome>, $FutureProvider<HandoffOutcome> {
  /// 把临时 root 移交给用户选定的 [manager]。
  ///
  /// 管理器未安装时返回 [HandoffKind.managerMissing]，不抛异常。
  const HandoffRootProvider._({
    required HandoffRootFamily super.from,
    required RootManager super.argument,
  }) : super(
         retry: null,
         name: r'handoffRootProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$handoffRootHash();

  @override
  String toString() {
    return r'handoffRootProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<HandoffOutcome> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<HandoffOutcome> create(Ref ref) {
    final argument = this.argument as RootManager;
    return handoffRoot(ref, manager: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HandoffRootProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$handoffRootHash() => r'9ccac61d7f99b1fecd78537b4d1d7ef08220d1ef';

/// 把临时 root 移交给用户选定的 [manager]。
///
/// 管理器未安装时返回 [HandoffKind.managerMissing]，不抛异常。

final class HandoffRootFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<HandoffOutcome>, RootManager> {
  const HandoffRootFamily._()
    : super(
        retry: null,
        name: r'handoffRootProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 把临时 root 移交给用户选定的 [manager]。
  ///
  /// 管理器未安装时返回 [HandoffKind.managerMissing]，不抛异常。

  HandoffRootProvider call({required RootManager manager}) =>
      HandoffRootProvider._(argument: manager, from: this);

  @override
  String toString() => r'handoffRootProvider';
}

/// root 管理器的写操作。
///
/// 形态同 `aiConfigActions`：无参 `keepAlive` 类持有 [Ref]，参数走方法入参。
/// 带参族函数会按参数缓存，同样的参数第二次调用不再执行方法体。

@ProviderFor(rootManagerActions)
const rootManagerActionsProvider = RootManagerActionsProvider._();

/// root 管理器的写操作。
///
/// 形态同 `aiConfigActions`：无参 `keepAlive` 类持有 [Ref]，参数走方法入参。
/// 带参族函数会按参数缓存，同样的参数第二次调用不再执行方法体。

final class RootManagerActionsProvider
    extends
        $FunctionalProvider<
          RootManagerActions,
          RootManagerActions,
          RootManagerActions
        >
    with $Provider<RootManagerActions> {
  /// root 管理器的写操作。
  ///
  /// 形态同 `aiConfigActions`：无参 `keepAlive` 类持有 [Ref]，参数走方法入参。
  /// 带参族函数会按参数缓存，同样的参数第二次调用不再执行方法体。
  const RootManagerActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rootManagerActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rootManagerActionsHash();

  @$internal
  @override
  $ProviderElement<RootManagerActions> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RootManagerActions create(Ref ref) {
    return rootManagerActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RootManagerActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RootManagerActions>(value),
    );
  }
}

String _$rootManagerActionsHash() =>
    r'f84a7be6ff0900100ae2492dfa6cd513dfe3a32f';

/// DirtyFrag 运行数据源。

@ProviderFor(dirtyFragActionDatasource)
const dirtyFragActionDatasourceProvider = DirtyFragActionDatasourceProvider._();

/// DirtyFrag 运行数据源。

final class DirtyFragActionDatasourceProvider
    extends
        $FunctionalProvider<
          DirtyFragActionDatasource,
          DirtyFragActionDatasource,
          DirtyFragActionDatasource
        >
    with $Provider<DirtyFragActionDatasource> {
  /// DirtyFrag 运行数据源。
  const DirtyFragActionDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dirtyFragActionDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dirtyFragActionDatasourceHash();

  @$internal
  @override
  $ProviderElement<DirtyFragActionDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DirtyFragActionDatasource create(Ref ref) {
    return dirtyFragActionDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DirtyFragActionDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DirtyFragActionDatasource>(value),
    );
  }
}

String _$dirtyFragActionDatasourceHash() =>
    r'6ac04d1f0b45f5b96f300b8e3802bd20d8ab79ea';

/// DirtyFrag 运行仓储。

@ProviderFor(dirtyFragActionRepository)
const dirtyFragActionRepositoryProvider = DirtyFragActionRepositoryProvider._();

/// DirtyFrag 运行仓储。

final class DirtyFragActionRepositoryProvider
    extends
        $FunctionalProvider<
          DirtyFragActionRepository,
          DirtyFragActionRepository,
          DirtyFragActionRepository
        >
    with $Provider<DirtyFragActionRepository> {
  /// DirtyFrag 运行仓储。
  const DirtyFragActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dirtyFragActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dirtyFragActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<DirtyFragActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DirtyFragActionRepository create(Ref ref) {
    return dirtyFragActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DirtyFragActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DirtyFragActionRepository>(value),
    );
  }
}

String _$dirtyFragActionRepositoryHash() =>
    r'ef5f252646f4858bb0b09d81cc228bdc53588636';

/// 本次开机是否已经注入过。

@ProviderFor(dirtyFragArmed)
const dirtyFragArmedProvider = DirtyFragArmedProvider._();

/// 本次开机是否已经注入过。

final class DirtyFragArmedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// 本次开机是否已经注入过。
  const DirtyFragArmedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dirtyFragArmedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dirtyFragArmedHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return dirtyFragArmed(ref);
  }
}

String _$dirtyFragArmedHash() => r'74006fbd33ad6ec1e4648fe31ac9be398ce7c5fb';

/// 运行默认值（设置页四个开关的当前值）。

@ProviderFor(dirtyFragRunDefaults)
const dirtyFragRunDefaultsProvider = DirtyFragRunDefaultsProvider._();

/// 运行默认值（设置页四个开关的当前值）。

final class DirtyFragRunDefaultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<DirtyFragRunDefaults>,
          DirtyFragRunDefaults,
          FutureOr<DirtyFragRunDefaults>
        >
    with
        $FutureModifier<DirtyFragRunDefaults>,
        $FutureProvider<DirtyFragRunDefaults> {
  /// 运行默认值（设置页四个开关的当前值）。
  const DirtyFragRunDefaultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dirtyFragRunDefaultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dirtyFragRunDefaultsHash();

  @$internal
  @override
  $FutureProviderElement<DirtyFragRunDefaults> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DirtyFragRunDefaults> create(Ref ref) {
    return dirtyFragRunDefaults(ref);
  }
}

String _$dirtyFragRunDefaultsHash() =>
    r'c147e91ade7a9f1c0aa3b9e122cdc55b8cc695e0';

/// DirtyFrag 设置页的写操作。
///
/// 同 [rootManagerActions]：无参类，参数走方法入参。

@ProviderFor(dirtyFragActions)
const dirtyFragActionsProvider = DirtyFragActionsProvider._();

/// DirtyFrag 设置页的写操作。
///
/// 同 [rootManagerActions]：无参类，参数走方法入参。

final class DirtyFragActionsProvider
    extends
        $FunctionalProvider<
          DirtyFragActions,
          DirtyFragActions,
          DirtyFragActions
        >
    with $Provider<DirtyFragActions> {
  /// DirtyFrag 设置页的写操作。
  ///
  /// 同 [rootManagerActions]：无参类，参数走方法入参。
  const DirtyFragActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dirtyFragActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dirtyFragActionsHash();

  @$internal
  @override
  $ProviderElement<DirtyFragActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DirtyFragActions create(Ref ref) {
    return dirtyFragActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DirtyFragActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DirtyFragActions>(value),
    );
  }
}

String _$dirtyFragActionsHash() => r'da9f3570dec10c45a19961219ce0d3c8745ed94d';

/// 跑一次 DirtyFrag，按块吐出证据。

@ProviderFor(runDirtyFrag)
const runDirtyFragProvider = RunDirtyFragFamily._();

/// 跑一次 DirtyFrag，按块吐出证据。

final class RunDirtyFragProvider
    extends
        $FunctionalProvider<
          AsyncValue<DirtyFragOutcome>,
          DirtyFragOutcome,
          Stream<DirtyFragOutcome>
        >
    with $FutureModifier<DirtyFragOutcome>, $StreamProvider<DirtyFragOutcome> {
  /// 跑一次 DirtyFrag，按块吐出证据。
  const RunDirtyFragProvider._({
    required RunDirtyFragFamily super.from,
    required ({RootManager manager, int? vrOffsetOverride}) super.argument,
  }) : super(
         retry: null,
         name: r'runDirtyFragProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$runDirtyFragHash();

  @override
  String toString() {
    return r'runDirtyFragProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<DirtyFragOutcome> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<DirtyFragOutcome> create(Ref ref) {
    final argument =
        this.argument as ({RootManager manager, int? vrOffsetOverride});
    return runDirtyFrag(
      ref,
      manager: argument.manager,
      vrOffsetOverride: argument.vrOffsetOverride,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RunDirtyFragProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$runDirtyFragHash() => r'4df47a1a78a0ab5fe45690f8c346b89c6e5a6fdb';

/// 跑一次 DirtyFrag，按块吐出证据。

final class RunDirtyFragFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<DirtyFragOutcome>,
          ({RootManager manager, int? vrOffsetOverride})
        > {
  const RunDirtyFragFamily._()
    : super(
        retry: null,
        name: r'runDirtyFragProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 跑一次 DirtyFrag，按块吐出证据。

  RunDirtyFragProvider call({
    required RootManager manager,
    int? vrOffsetOverride,
  }) => RunDirtyFragProvider._(
    argument: (manager: manager, vrOffsetOverride: vrOffsetOverride),
    from: this,
  );

  @override
  String toString() => r'runDirtyFragProvider';
}

/// 专家模式开关当前状态。

@ProviderFor(dirtyFragExpertMode)
const dirtyFragExpertModeProvider = DirtyFragExpertModeProvider._();

/// 专家模式开关当前状态。

final class DirtyFragExpertModeProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// 专家模式开关当前状态。
  const DirtyFragExpertModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dirtyFragExpertModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dirtyFragExpertModeHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return dirtyFragExpertMode(ref);
  }
}

String _$dirtyFragExpertModeHash() =>
    r'1609c1b937d215039251d22dcdd9933982d6aec5';

/// 开机自启开关当前状态。真相是组件启用态。

@ProviderFor(dirtyFragBootAutostart)
const dirtyFragBootAutostartProvider = DirtyFragBootAutostartProvider._();

/// 开机自启开关当前状态。真相是组件启用态。

final class DirtyFragBootAutostartProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// 开机自启开关当前状态。真相是组件启用态。
  const DirtyFragBootAutostartProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dirtyFragBootAutostartProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dirtyFragBootAutostartHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return dirtyFragBootAutostart(ref);
  }
}

String _$dirtyFragBootAutostartHash() =>
    r'50200e7bc0cf5292f007f4d2541f423eb393f6e7';

/// 从镜像或 OTA 直链算一次 vr 偏移。

@ProviderFor(deriveVrOffset)
const deriveVrOffsetProvider = DeriveVrOffsetFamily._();

/// 从镜像或 OTA 直链算一次 vr 偏移。

final class DeriveVrOffsetProvider
    extends
        $FunctionalProvider<
          AsyncValue<VrOffsetResult>,
          VrOffsetResult,
          FutureOr<VrOffsetResult>
        >
    with $FutureModifier<VrOffsetResult>, $FutureProvider<VrOffsetResult> {
  /// 从镜像或 OTA 直链算一次 vr 偏移。
  const DeriveVrOffsetProvider._({
    required DeriveVrOffsetFamily super.from,
    required ({String input, bool insecure}) super.argument,
  }) : super(
         retry: null,
         name: r'deriveVrOffsetProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$deriveVrOffsetHash();

  @override
  String toString() {
    return r'deriveVrOffsetProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<VrOffsetResult> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<VrOffsetResult> create(Ref ref) {
    final argument = this.argument as ({String input, bool insecure});
    return deriveVrOffset(
      ref,
      input: argument.input,
      insecure: argument.insecure,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DeriveVrOffsetProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$deriveVrOffsetHash() => r'fa51b920a1a22e1da6e8b196218d9ea37f4d5bad';

/// 从镜像或 OTA 直链算一次 vr 偏移。

final class DeriveVrOffsetFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<VrOffsetResult>,
          ({String input, bool insecure})
        > {
  const DeriveVrOffsetFamily._()
    : super(
        retry: null,
        name: r'deriveVrOffsetProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 从镜像或 OTA 直链算一次 vr 偏移。

  DeriveVrOffsetProvider call({required String input, bool insecure = false}) =>
      DeriveVrOffsetProvider._(
        argument: (input: input, insecure: insecure),
        from: this,
      );

  @override
  String toString() => r'deriveVrOffsetProvider';
}

/// 提取进度。只在被监听期间轮询，弹窗关掉就停。

@ProviderFor(vrDeriveProgress)
const vrDeriveProgressProvider = VrDeriveProgressProvider._();

/// 提取进度。只在被监听期间轮询，弹窗关掉就停。

final class VrDeriveProgressProvider
    extends
        $FunctionalProvider<
          AsyncValue<VrDeriveProgress>,
          VrDeriveProgress,
          Stream<VrDeriveProgress>
        >
    with $FutureModifier<VrDeriveProgress>, $StreamProvider<VrDeriveProgress> {
  /// 提取进度。只在被监听期间轮询，弹窗关掉就停。
  const VrDeriveProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vrDeriveProgressProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vrDeriveProgressHash();

  @$internal
  @override
  $StreamProviderElement<VrDeriveProgress> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<VrDeriveProgress> create(Ref ref) {
    return vrDeriveProgress(ref);
  }
}

String _$vrDeriveProgressHash() => r'6328101a05e6d604b5067d9539040d603605a839';

/// GhostKey 运行数据源。

@ProviderFor(ghostKeyActionDatasource)
const ghostKeyActionDatasourceProvider = GhostKeyActionDatasourceProvider._();

/// GhostKey 运行数据源。

final class GhostKeyActionDatasourceProvider
    extends
        $FunctionalProvider<
          GhostKeyActionDatasource,
          GhostKeyActionDatasource,
          GhostKeyActionDatasource
        >
    with $Provider<GhostKeyActionDatasource> {
  /// GhostKey 运行数据源。
  const GhostKeyActionDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ghostKeyActionDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ghostKeyActionDatasourceHash();

  @$internal
  @override
  $ProviderElement<GhostKeyActionDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GhostKeyActionDatasource create(Ref ref) {
    return ghostKeyActionDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GhostKeyActionDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GhostKeyActionDatasource>(value),
    );
  }
}

String _$ghostKeyActionDatasourceHash() =>
    r'a178747ce7856ec2332a96a50ed00ee4f52ff51b';

/// GhostKey 运行仓储。

@ProviderFor(ghostKeyActionRepository)
const ghostKeyActionRepositoryProvider = GhostKeyActionRepositoryProvider._();

/// GhostKey 运行仓储。

final class GhostKeyActionRepositoryProvider
    extends
        $FunctionalProvider<
          GhostKeyActionRepository,
          GhostKeyActionRepository,
          GhostKeyActionRepository
        >
    with $Provider<GhostKeyActionRepository> {
  /// GhostKey 运行仓储。
  const GhostKeyActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ghostKeyActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ghostKeyActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<GhostKeyActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GhostKeyActionRepository create(Ref ref) {
    return ghostKeyActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GhostKeyActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GhostKeyActionRepository>(value),
    );
  }
}

String _$ghostKeyActionRepositoryHash() =>
    r'b66eb0eb80d0c8df54920e10acd3a9206fb7a41f';

/// GhostKey 起跑前的六项就绪检查。

@ProviderFor(ghostKeyPreflight)
const ghostKeyPreflightProvider = GhostKeyPreflightProvider._();

/// GhostKey 起跑前的六项就绪检查。

final class GhostKeyPreflightProvider
    extends
        $FunctionalProvider<
          AsyncValue<GhostKeyPreflight>,
          GhostKeyPreflight,
          FutureOr<GhostKeyPreflight>
        >
    with
        $FutureModifier<GhostKeyPreflight>,
        $FutureProvider<GhostKeyPreflight> {
  /// GhostKey 起跑前的六项就绪检查。
  const GhostKeyPreflightProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ghostKeyPreflightProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ghostKeyPreflightHash();

  @$internal
  @override
  $FutureProviderElement<GhostKeyPreflight> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GhostKeyPreflight> create(Ref ref) {
    return ghostKeyPreflight(ref);
  }
}

String _$ghostKeyPreflightHash() => r'53ef1c0818cc66863c046c99d6bdb47ec170df4f';

/// 运行偏好（设置页两个开关的当前值）。

@ProviderFor(ghostKeyRunDefaults)
const ghostKeyRunDefaultsProvider = GhostKeyRunDefaultsProvider._();

/// 运行偏好（设置页两个开关的当前值）。

final class GhostKeyRunDefaultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<GhostKeyRunDefaults>,
          GhostKeyRunDefaults,
          FutureOr<GhostKeyRunDefaults>
        >
    with
        $FutureModifier<GhostKeyRunDefaults>,
        $FutureProvider<GhostKeyRunDefaults> {
  /// 运行偏好（设置页两个开关的当前值）。
  const GhostKeyRunDefaultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ghostKeyRunDefaultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ghostKeyRunDefaultsHash();

  @$internal
  @override
  $FutureProviderElement<GhostKeyRunDefaults> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GhostKeyRunDefaults> create(Ref ref) {
    return ghostKeyRunDefaults(ref);
  }
}

String _$ghostKeyRunDefaultsHash() =>
    r'95e2a28a80597ec5f480f85fa34efcd31f43d786';

/// GhostKey 设置页的写操作。
///
/// 同 [rootManagerActions]：无参类，参数走方法入参。

@ProviderFor(ghostKeyActions)
const ghostKeyActionsProvider = GhostKeyActionsProvider._();

/// GhostKey 设置页的写操作。
///
/// 同 [rootManagerActions]：无参类，参数走方法入参。

final class GhostKeyActionsProvider
    extends
        $FunctionalProvider<GhostKeyActions, GhostKeyActions, GhostKeyActions>
    with $Provider<GhostKeyActions> {
  /// GhostKey 设置页的写操作。
  ///
  /// 同 [rootManagerActions]：无参类，参数走方法入参。
  const GhostKeyActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ghostKeyActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ghostKeyActionsHash();

  @$internal
  @override
  $ProviderElement<GhostKeyActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GhostKeyActions create(Ref ref) {
    return ghostKeyActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GhostKeyActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GhostKeyActions>(value),
    );
  }
}

String _$ghostKeyActionsHash() => r'd131b7ce2923ae6a94d0f6f954495decd9872f6e';

/// 跑一次 GhostKey，按块吐出证据。

@ProviderFor(runGhostKey)
const runGhostKeyProvider = RunGhostKeyFamily._();

/// 跑一次 GhostKey，按块吐出证据。

final class RunGhostKeyProvider
    extends
        $FunctionalProvider<
          AsyncValue<GhostKeyOutcome>,
          GhostKeyOutcome,
          Stream<GhostKeyOutcome>
        >
    with $FutureModifier<GhostKeyOutcome>, $StreamProvider<GhostKeyOutcome> {
  /// 跑一次 GhostKey，按块吐出证据。
  const RunGhostKeyProvider._({
    required RunGhostKeyFamily super.from,
    required RootManager? super.argument,
  }) : super(
         retry: null,
         name: r'runGhostKeyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$runGhostKeyHash();

  @override
  String toString() {
    return r'runGhostKeyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<GhostKeyOutcome> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<GhostKeyOutcome> create(Ref ref) {
    final argument = this.argument as RootManager?;
    return runGhostKey(ref, manager: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RunGhostKeyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$runGhostKeyHash() => r'43cf80ac90026f3cb97df96e8c171575badb7639';

/// 跑一次 GhostKey，按块吐出证据。

final class RunGhostKeyFamily extends $Family
    with $FunctionalFamilyOverride<Stream<GhostKeyOutcome>, RootManager?> {
  const RunGhostKeyFamily._()
    : super(
        retry: null,
        name: r'runGhostKeyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 跑一次 GhostKey，按块吐出证据。

  RunGhostKeyProvider call({RootManager? manager}) =>
      RunGhostKeyProvider._(argument: manager, from: this);

  @override
  String toString() => r'runGhostKeyProvider';
}
