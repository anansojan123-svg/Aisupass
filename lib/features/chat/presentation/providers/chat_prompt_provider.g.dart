// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_prompt_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 提示词只读数据源。

@ProviderFor(chatPromptQueryDatasource)
const chatPromptQueryDatasourceProvider = ChatPromptQueryDatasourceProvider._();

/// 提示词只读数据源。

final class ChatPromptQueryDatasourceProvider
    extends
        $FunctionalProvider<
          ChatPromptQueryDatasource,
          ChatPromptQueryDatasource,
          ChatPromptQueryDatasource
        >
    with $Provider<ChatPromptQueryDatasource> {
  /// 提示词只读数据源。
  const ChatPromptQueryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatPromptQueryDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatPromptQueryDatasourceHash();

  @$internal
  @override
  $ProviderElement<ChatPromptQueryDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChatPromptQueryDatasource create(Ref ref) {
    return chatPromptQueryDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatPromptQueryDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatPromptQueryDatasource>(value),
    );
  }
}

String _$chatPromptQueryDatasourceHash() =>
    r'8d2f2f6ceb71c24c5f6321998be3c2f805c1636f';

/// 提示词写数据源。

@ProviderFor(chatPromptActionDatasource)
const chatPromptActionDatasourceProvider =
    ChatPromptActionDatasourceProvider._();

/// 提示词写数据源。

final class ChatPromptActionDatasourceProvider
    extends
        $FunctionalProvider<
          ChatPromptActionDatasource,
          ChatPromptActionDatasource,
          ChatPromptActionDatasource
        >
    with $Provider<ChatPromptActionDatasource> {
  /// 提示词写数据源。
  const ChatPromptActionDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatPromptActionDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatPromptActionDatasourceHash();

  @$internal
  @override
  $ProviderElement<ChatPromptActionDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChatPromptActionDatasource create(Ref ref) {
    return chatPromptActionDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatPromptActionDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatPromptActionDatasource>(value),
    );
  }
}

String _$chatPromptActionDatasourceHash() =>
    r'670506163d6b048303e5bf99a3fd2f2f071016af';

/// 提示词只读仓储。

@ProviderFor(chatPromptQueryRepository)
const chatPromptQueryRepositoryProvider = ChatPromptQueryRepositoryProvider._();

/// 提示词只读仓储。

final class ChatPromptQueryRepositoryProvider
    extends
        $FunctionalProvider<
          ChatPromptQueryRepository,
          ChatPromptQueryRepository,
          ChatPromptQueryRepository
        >
    with $Provider<ChatPromptQueryRepository> {
  /// 提示词只读仓储。
  const ChatPromptQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatPromptQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatPromptQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatPromptQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChatPromptQueryRepository create(Ref ref) {
    return chatPromptQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatPromptQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatPromptQueryRepository>(value),
    );
  }
}

String _$chatPromptQueryRepositoryHash() =>
    r'9fa73efa40348ee5bbbf3cda5ce6952bd7335256';

/// 提示词写仓储。

@ProviderFor(chatPromptActionRepository)
const chatPromptActionRepositoryProvider =
    ChatPromptActionRepositoryProvider._();

/// 提示词写仓储。

final class ChatPromptActionRepositoryProvider
    extends
        $FunctionalProvider<
          ChatPromptActionRepository,
          ChatPromptActionRepository,
          ChatPromptActionRepository
        >
    with $Provider<ChatPromptActionRepository> {
  /// 提示词写仓储。
  const ChatPromptActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatPromptActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatPromptActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatPromptActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChatPromptActionRepository create(Ref ref) {
    return chatPromptActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatPromptActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatPromptActionRepository>(value),
    );
  }
}

String _$chatPromptActionRepositoryHash() =>
    r'5eb16f516344814dbbd1b710213ae13c334025ab';

/// 常用提示词控制器：全局共享，增删改后整表落盘。

@ProviderFor(ChatPrompts)
const chatPromptsProvider = ChatPromptsProvider._();

/// 常用提示词控制器：全局共享，增删改后整表落盘。
final class ChatPromptsProvider
    extends $NotifierProvider<ChatPrompts, ChatPromptsState> {
  /// 常用提示词控制器：全局共享，增删改后整表落盘。
  const ChatPromptsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatPromptsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatPromptsHash();

  @$internal
  @override
  ChatPrompts create() => ChatPrompts();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatPromptsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatPromptsState>(value),
    );
  }
}

String _$chatPromptsHash() => r'229c11a8274d36a51142c5824baf0388d19026a5';

/// 常用提示词控制器：全局共享，增删改后整表落盘。

abstract class _$ChatPrompts extends $Notifier<ChatPromptsState> {
  ChatPromptsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ChatPromptsState, ChatPromptsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChatPromptsState, ChatPromptsState>,
              ChatPromptsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
