import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/colors/app_colors.dart';
import '../bloc/chatbot_bloc.dart';
import '../bloc/chatbot_event.dart';
import '../bloc/chatbot_state.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_bar.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final _scrollController = ScrollController();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      // Replace the static welcome message with the translated one
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<ChatbotBloc>().add(
            InitChatbotEvent('chatbot_welcome'.tr()),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSend(String text) {
    if (text.trim().isEmpty) return;
    context.read<ChatbotBloc>().add(SendChatMessageEvent(text.trim()));
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final primary = AppColors.primary(dark);
    final bg = AppColors.background(dark);
    final card = AppColors.card(dark);
    final fg = AppColors.fg(dark);
    final muted = AppColors.muted(dark);
    final border = AppColors.border(dark);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: primary.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: primary.withOpacity(0.3)),
            ),
            child:
                Icon(Icons.smart_toy_outlined, color: primary, size: 20),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('blitz_assistant'.tr(),
                style: TextStyle(
                    color: fg,
                    fontSize: 15,
                    fontWeight: FontWeight.w600)),
            Row(children: [
              Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                      color: Colors.green, shape: BoxShape.circle)),
              const SizedBox(width: 4),
              Text('online'.tr(), style: TextStyle(color: muted, fontSize: 11)),
            ]),
          ]),
        ]),
      ),
      body: BlocConsumer<ChatbotBloc, ChatbotState>(
        listener: (context, state) {
          // Scroll to bottom whenever new content arrives
          _scrollToBottom();
        },
        builder: (context, state) {
          final messages = state.messages;
          final isStreaming = state is ChatbotStreaming;
          final isSending = state is ChatbotSending;
          final currentResponse =
              state is ChatbotStreaming ? state.currentResponse : null;
          final hasError = state is ChatbotError;

          return Column(
            children: [
              // Messages list
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length +
                      (isSending ? 1 : 0) +
                      (isStreaming ? 1 : 0),
                  itemBuilder: (_, i) {
                    // Typing indicator while waiting for first chunk
                    if (isSending && i == messages.length) {
                      return _TypingIndicator(
                          primary: primary, card: card, border: border);
                    }

                    // Streaming bot response in progress
                    if (isStreaming && i == messages.length) {
                      return ChatBubble(
                        message: currentResponse!.isEmpty
                            ? '...'
                            : currentResponse,
                        isUser: false,
                        time: DateTime.now(),
                        primary: primary,
                        card: card,
                        fg: fg,
                        muted: muted,
                        border: border,
                      );
                    }

                    final msg = messages[i];
                    return ChatBubble(
                      message: msg.text,
                      isUser: msg.isUser,
                      time: msg.time,
                      primary: primary,
                      card: card,
                      fg: fg,
                      muted: muted,
                      border: border,
                    );
                  },
                ),
              ),

              // Error banner
              if (hasError)
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade700.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: Colors.red.shade700.withOpacity(0.4)),
                  ),
                  child: Row(children: [
                    Icon(Icons.error_outline,
                        color: Colors.red.shade400, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        (state as ChatbotError).error,
                        style: TextStyle(
                            color: Colors.red.shade400, fontSize: 12),
                      ),
                    ),
                  ]),
                ),

              // Input bar
              ChatInputBar(
                primary: primary,
                card: card,
                fg: fg,
                muted: muted,
                border: border,
                onSend: _handleSend,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  final Color primary, card, border;
  const _TypingIndicator(
      {required this.primary, required this.card, required this.border});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child:
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: primary.withOpacity(0.15),
                shape: BoxShape.circle),
            child:
                Icon(Icons.smart_toy_outlined, color: primary, size: 16)),
        const SizedBox(width: 8),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
              color: card,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(14),
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
              border: Border.all(color: border)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            _Dot(primary: primary, delay: 0),
            const SizedBox(width: 4),
            _Dot(primary: primary, delay: 150),
            const SizedBox(width: 4),
            _Dot(primary: primary, delay: 300),
          ]),
        ),
      ]),
    );
  }
}

class _Dot extends StatefulWidget {
  final Color primary;
  final int delay;
  const _Dot({required this.primary, required this.delay});
  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _anim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
              color: widget.primary, shape: BoxShape.circle)),
    );
  }
}
