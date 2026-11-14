import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/routes/app_route.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/ai/domain/models/ai_config.dart';
import 'package:Aisupass/features/ai/presentation/providers/ai_config_query_provider.dart';
import 'package:Aisupass/features/ai/presentation/widgets/ai_brand_icon.dart';
import 'package:Aisupass/features/chat/domain/enums/chat_issue.dart';
import 'package:Aisupass/features/chat/domain/models/chat_turn.dart';
import 'package:Aisupass/features/chat/presentation/controllers/chat_page_controller.dart';
import 'package:Aisupass/features/chat/presentation/providers/chat_action_provider.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/chat_widgets/chat_empty_state.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/chat_widgets/chat_input_bar.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/chat_widgets/chat_message.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/chat_widgets/chat_notice.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/chat_widgets/chat_scroll_button.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/chat_widgets/chat_session_list.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// AI 对话页。
///
/// assistant 消息走无气泡瀑布流，user 消息走右侧气泡；
/// 工具结果挂在发起调用的轮次内，保证「调用 → 结果 → 继续输出」连续。
class ChatPage extends HookConsumerWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final bool isDesktop = isDesktopPlatform;

    final ChatState state = ref.watch(chatControllerProvider);
    final ChatController controller = ref.read(chatControllerProvider.notifier);
    final AsyncValue<AiConfigState> configAsync = ref.watch(aiConfigProvider);
    final AiConfig? config = configAsync.value?.current;
    final AiBrand? brand = resolveAiBrand(
      apiUrl: config?.apiUrl,
      modelName: config?.modelName,
      name: config?.name,
    );
    // 加载中不提示，避免首帧闪一下；加载完成或失败后仍无配置才提示。
    final bool needsConfig =
        state.issue == ChatIssue.noConfig ||
        (!configAsync.isLoading && config == null);

    final ScrollController scrollController = useScrollController();
    final ValueNotifier<bool> showJump = useState<bool>(false);
    final ValueNotifier<int> unread = useState<int>(0);
    final ObjectRef<int> lastTurnCount = useRef<int>(state.turns.length);

    final ChatPageController pageController = ChatPageController(
      ref: ref,
      showJump: showJump,
      unread: unread,
      scrollController: scrollController,
      notifySessionReady: (String title) => ToastMessage.success(
        l10n.chatSessionReady(title.isEmpty ? l10n.chatUntitled : title),
      ),
    );

    void handleSend(String text) {
      pageController.send(text);
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => pageController.jumpToLatest(),
      );
    }

    // 离开底部时浮出回到底部按钮，回到底部后清空未读。
    useEffect(() {
      scrollController.addListener(pageController.syncScrollPosition);
      return () => scrollController.removeListener(
        pageController.syncScrollPosition,
      );
    }, const <Object?>[]);

    // 新增轮次时，若用户正在回看历史，只累计未读，不打断阅读。
    useEffect(() {
      final int previous = lastTurnCount.value;
      lastTurnCount.value = state.turns.length;
      if (state.turns.length <= previous) return null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        pageController.markUnreadIfAway();
      });
      return null;
    }, <Object?>[state.turns.length]);

    // 后台会话跑完时给一次轻提示；用户正停留在该会话时由正文自己更新，不打扰。
    ref.listen<ChatJobsState>(chatJobsProvider, (
      ChatJobsState? previous,
      ChatJobsState next,
    ) {
      pageController.handleJobCompleted(next, previous?.completed);
    });

    // 头像与模型名只在每条用户消息后的首条 assistant 消息上出现，
    // 后续工具续跑的轮次不再重复，保持正文连续。
    final Set<String> headAssistantIds = <String>{};
    bool awaitingReply = false;
    for (final ChatTurn turn in state.turns) {
      if (turn.isUser) {
        awaitingReply = true;
      } else if (awaitingReply) {
        headAssistantIds.add(turn.id);
        awaitingReply = false;
      }
    }

    final Widget conversation = state.isEmpty
        ? ChatEmptyState(onSuggestion: handleSend)
        : Stack(
            children: <Widget>[
              ListView.builder(
                controller: scrollController,
                reverse: true,
                padding: EdgeInsets.fromLTRB(
                  isDesktop ? 24 : 16.w,
                  isDesktop ? 16 : 12.h,
                  isDesktop ? 24 : 16.w,
                  0,
                ),
                itemCount: state.turns.length,
                itemBuilder: (BuildContext context, int index) {
                  final ChatTurn turn =
                      state.turns[state.turns.length - 1 - index];
                  final Widget message = ChatMessageView(
                    key: ValueKey<String>(turn.id),
                    turn: turn,
                    brand: brand,
                    modelName: config?.modelName ?? '',
                    showModelName: headAssistantIds.contains(turn.id),
                    animate: index == 0,
                  );
                  // 除首轮外，每段新提问前加一条分隔线，便于区分多段对话。
                  if (!turn.isUser || index == state.turns.length - 1) {
                    return message;
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _SegmentDivider(),
                      message,
                    ],
                  );
                },
              ),
              Positioned(
                right: isDesktop ? 28 : 16.w,
                bottom: isDesktop ? 12 : 10.h,
                child: ChatScrollButton(
                  visible: showJump.value,
                  unread: unread.value,
                  onTap: () => pageController.jumpToLatest(animate: true),
                ),
              ),
            ],
          );

    final Widget body = Column(
      children: <Widget>[
        Expanded(
          child: isDesktop
              ? Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 860),
                    child: conversation,
                  ),
                )
              : conversation,
        ),
        if (needsConfig)
          ChatIssueBanner(
            message: l10n.chatIssueNoConfig,
            actionLabel: l10n.aiConfigTitle,
            onAction: () => context.push(AppRoute.aiConfig),
          ),
        ChatInputBar(
          streaming: state.streaming,
          onSend: handleSend,
          onStop: controller.stop,
        ),
      ],
    );

    // 日间对话区用纯白，夜间跟随主题底色。
    final Color pageBackground = context.isDark
        ? Theme.of(context).scaffoldBackgroundColor
        : context.colorScheme.surface;

    if (!isDesktop) {
      return Scaffold(
        backgroundColor: pageBackground,
        drawer: Drawer(
          child: SafeArea(
            child: ChatSessionList(
              onSelected: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: pageBackground,
          leading: Builder(
            builder: (BuildContext scaffoldContext) => IconButton(
              onPressed: () => Scaffold.of(scaffoldContext).openDrawer(),
              icon: Icon(Icons.history_rounded, size: 20.sp),
              tooltip: l10n.chatSessions,
            ),
          ),
          title: Text(l10n.chatTitle),
          actions: <Widget>[
            IconButton(
              onPressed: state.isEmpty
                  ? null
                  : () => pageController.startNewSession(),
              icon: Icon(Icons.add_comment_outlined, size: 20.sp),
              tooltip: l10n.chatNewSession,
            ),
            SizedBox(width: 4.w),
          ],
        ),
        body: SafeArea(top: false, child: body),
      );
    }

    return Scaffold(
      backgroundColor: pageBackground,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            width: 260,
            child: SafeArea(
              right: false,
              child: ChatSessionList(),
            ),
          ),
          Container(
            width: 1,
            color: context.colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 20, 8),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          if (context.canPop()) context.pop();
                        },
                        icon: const Icon(Icons.arrow_back_rounded),
                        tooltip:
                            MaterialLocalizations.of(context).backButtonTooltip,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          l10n.chatTitle,
                          style: context.textTheme.titleLarge?.copyWith(
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: state.isEmpty
                            ? null
                            : () => pageController.startNewSession(),
                        icon: const Icon(
                          Icons.add_comment_outlined,
                          size: 21,
                        ),
                        tooltip: l10n.chatNewSession,
                      ),
                    ],
                  ),
                ),
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 多段对话之间的分隔线。
class _SegmentDivider extends StatelessWidget {
  const _SegmentDivider();

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDesktopPlatform;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isDesktop ? 4 : 4.h),
      child: Divider(
        height: 1,
        thickness: 1,
        color: context.colorScheme.outlineVariant.withValues(alpha: 0.35),
      ),
    );
  }
}
