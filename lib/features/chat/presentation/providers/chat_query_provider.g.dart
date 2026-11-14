// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 会话只读数据源。

@ProviderFor(chatSessionQueryDatasource)
const chatSessionQueryDatasourceProvider =
    ChatSessionQueryDatasourceProvider._();

/// 会话只读数据源。

final class ChatSessionQueryDatasourceProvider
    extends
        $FunctionalProvider<
          ChatSessionQueryDatasource,
          ChatSessionQueryDatasource,
          ChatSessionQueryDatasource
        >
    with $Provider<ChatSessionQueryDatasource> {
  /// 会话只读数据源。
  const ChatSessionQueryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatSessionQueryDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatSessionQueryDatasourceHash();

  @$internal
  @override
  $ProviderElement<ChatSessionQueryDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChatSessionQueryDatasource create(Ref ref) {
    return chatSessionQueryDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatSessionQueryDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatSessionQueryDatasource>(value),
    );
  }
}

String _$chatSessionQueryDatasourceHash() =>
    r'10b7feb8f0d49b213358156fbcb034e281efbee0';

/// 会话只读仓储。

@ProviderFor(chatSessionQueryRepository)
const chatSessionQueryRepositoryProvider =
    ChatSessionQueryRepositoryProvider._();

/// 会话只读仓储。

final class ChatSessionQueryRepositoryProvider
    extends
        $FunctionalProvider<
          ChatSessionQueryRepository,
          ChatSessionQueryRepository,
          ChatSessionQueryRepository
        >
    with $Provider<ChatSessionQueryRepository> {
  /// 会话只读仓储。
  const ChatSessionQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatSessionQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatSessionQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatSessionQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChatSessionQueryRepository create(Ref ref) {
    return chatSessionQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatSessionQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatSessionQueryRepository>(value),
    );
  }
}

String _$chatSessionQueryRepositoryHash() =>
    r'459cc02639a587dc485f3eba717586ed3774c7ad';

/// 磁盘上的全部会话。

@ProviderFor(storedChatSessions)
const storedChatSessionsProvider = StoredChatSessionsProvider._();

/// 磁盘上的全部会话。

final class StoredChatSessionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChatSession>>,
          List<ChatSession>,
          FutureOr<List<ChatSession>>
        >
    with
        $FutureModifier<List<ChatSession>>,
        $FutureProvider<List<ChatSession>> {
  /// 磁盘上的全部会话。
  const StoredChatSessionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storedChatSessionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storedChatSessionsHash();

  @$internal
  @override
  $FutureProviderElement<List<ChatSession>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ChatSession>> create(Ref ref) {
    return storedChatSessions(ref);
  }
}

String _$storedChatSessionsHash() =>
    r'e3fecc05acb8e380d1a10332f23c2600c24e5e08';

/// 上次选中的会话 id；无记录返回空串。

@ProviderFor(storedChatSessionId)
const storedChatSessionIdProvider = StoredChatSessionIdProvider._();

/// 上次选中的会话 id；无记录返回空串。

final class StoredChatSessionIdProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// 上次选中的会话 id；无记录返回空串。
  const StoredChatSessionIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storedChatSessionIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storedChatSessionIdHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return storedChatSessionId(ref);
  }
}

String _$storedChatSessionIdHash() =>
    r'49f4cdd10a7619f411eb92670ceb3d87ee1e190e';
