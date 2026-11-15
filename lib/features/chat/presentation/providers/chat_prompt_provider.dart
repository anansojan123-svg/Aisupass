import 'package:Aisupass/core/storage/storage_providers.dart';
import 'package:Aisupass/features/chat/data/datasources/chat_prompt_action_datasource.dart';
import 'package:Aisupass/features/chat/data/datasources/chat_prompt_query_datasource.dart';
import 'package:Aisupass/features/chat/data/repositories/chat_prompt_action_repository_impl.dart';
import 'package:Aisupass/features/chat/data/repositories/chat_prompt_query_repository_impl.dart';
import 'package:Aisupass/features/chat/domain/models/chat_prompt.dart';
import 'package:Aisupass/features/chat/domain/repositories/chat_prompt_action_repository.dart';
import 'package:Aisupass/features/chat/domain/repositories/chat_prompt_query_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'chat_prompt_provider.g.dart';

/// 提示词只读数据源。
@riverpod
ChatPromptQueryDatasource chatPromptQueryDatasource(Ref ref) =>
    ChatPromptQueryDatasource(
      preferences: ref.watch(preferencesStoreProvider),
    );

/// 提示词写数据源。
@riverpod
ChatPromptActionDatasource chatPromptActionDatasource(Ref ref) =>
    ChatPromptActionDatasource(
      preferences: ref.watch(preferencesStoreProvider),
    );

/// 提示词只读仓储。
@riverpod
ChatPromptQueryRepository chatPromptQueryRepository(Ref ref) =>
    ChatPromptQueryRepositoryImpl(
      datasource: ref.watch(chatPromptQueryDatasourceProvider),
    );

/// 提示词写仓储。
@riverpod
ChatPromptActionRepository chatPromptActionRepository(Ref ref) =>
    ChatPromptActionRepositoryImpl(
      datasource: ref.watch(chatPromptActionDatasourceProvider),
    );

/// 提示词列表状态。
@immutable
class ChatPromptsState {
  const ChatPromptsState({
    this.prompts = const <ChatPrompt>[],
    this.loaded = false,
  });

  final List<ChatPrompt> prompts;

  /// 是否已完成首次磁盘读取，未完成前 UI 不展示空态文案。
  final bool loaded;
}

/// 常用提示词控制器：全局共享，增删改后整表落盘。
@Riverpod(keepAlive: true)
class ChatPrompts extends _$ChatPrompts {
  bool _disposed = false;

  ChatPromptActionRepository get _action =>
      ref.read(chatPromptActionRepositoryProvider);

  @override
  ChatPromptsState build() {
    ref.onDispose(() => _disposed = true);
    // 同步 build 无法 await，先返回空态，读盘完成后再刷新。
    Future<void>(_restore);
    return const ChatPromptsState();
  }

  Future<void> _restore() async {
    final List<ChatPrompt> prompts = await ref
        .read(chatPromptQueryRepositoryProvider)
        .loadAll();
    if (_disposed) return;
    state = ChatPromptsState(prompts: prompts, loaded: true);
  }

  /// 新建或更新一条提示词；[id] 为空表示新建。
  Future<void> save({
    String? id,
    required String title,
    required String content,
  }) async {
    final String text = content.trim();
    if (text.isEmpty) return;

    final List<ChatPrompt> next = <ChatPrompt>[...state.prompts];
    if (id == null) {
      next.add(
        ChatPrompt(
          id: const Uuid().v4(),
          title: title.trim(),
          content: text,
          createdAt: DateTime.now(),
        ),
      );
    } else {
      final int index = next.indexWhere((ChatPrompt item) => item.id == id);
      if (index < 0) return;
      next[index] = next[index].copyWith(
        title: title.trim(),
        content: text,
      );
    }
    state = ChatPromptsState(
      prompts: List<ChatPrompt>.unmodifiable(next),
      loaded: true,
    );
    await _action.writeAll(next);
  }

  /// 删除一条提示词。
  Future<void> remove(String id) async {
    final List<ChatPrompt> next = state.prompts
        .where((ChatPrompt item) => item.id != id)
        .toList(growable: false);
    state = ChatPromptsState(
      prompts: List<ChatPrompt>.unmodifiable(next),
      loaded: true,
    );
    await _action.writeAll(next);
  }
}
