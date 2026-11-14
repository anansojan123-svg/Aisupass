import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/features/chat/domain/models/chat_session.dart';
import 'package:Aisupass/features/chat/presentation/providers/chat_action_provider.dart';

/// 对话页的交互编排。
///
/// 只负责「读 Provider → 调度 → 通知页面」的顺序，不持有 `BuildContext`、
/// 不弹提示；轻提示由页面以回调注入。
class ChatPageController {
  ChatPageController({
    required this._ref,
    required this._showJump,
    required this._unread,
    required this._scrollController,
    required this._notifySessionReady,
  });

  /// 判定「用户已离开底部」的滚动距离。
  static const double _awayThreshold = 120;

  final WidgetRef _ref;
  final ValueNotifier<bool> _showJump;
  final ValueNotifier<int> _unread;
  final ScrollController _scrollController;
  final void Function(String title) _notifySessionReady;

  bool get _isAway =>
      _scrollController.hasClients &&
      _scrollController.position.pixels > _awayThreshold;

  /// 回到底部并清空未读。
  void jumpToLatest({bool animate = false}) {
    if (!_scrollController.hasClients) return;
    _unread.value = 0;
    if (animate) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    } else {
      _scrollController.jumpTo(0);
    }
  }

  /// 离开底部时浮出回到底部按钮，回到底部后清空未读。
  void syncScrollPosition() {
    if (!_scrollController.hasClients) return;
    final bool away = _isAway;
    if (_showJump.value != away) _showJump.value = away;
    if (!away && _unread.value != 0) _unread.value = 0;
  }

  /// 用户正在回看历史时，只累计未读，不打断阅读。
  void markUnreadIfAway() {
    if (_isAway) _unread.value += 1;
  }

  /// 发送一条消息。
  void send(String text) {
    _unread.value = 0;
    _ref.read(chatControllerProvider.notifier).send(text);
  }

  /// 新建会话并回到底部。
  Future<void> startNewSession() async {
    await _ref.read(chatControllerProvider.notifier).startNewSession();
    _unread.value = 0;
    jumpToLatest();
  }

  /// 后台会话跑完时给一次轻提示；用户正停留在该会话时不打扰。
  void handleJobCompleted(ChatJobsState next, String? previousId) {
    final String? id = next.completed;
    if (id == null || id == previousId) return;

    String title = '';
    for (final ChatSession session
        in _ref.read(chatSessionsProvider).sessions) {
      if (session.id == id) {
        title = session.title.trim();
        break;
      }
    }
    _notifySessionReady(title);
    _ref.read(chatJobsProvider.notifier).acknowledge(id);
  }
}
