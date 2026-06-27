import 'package:flutter/material.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_bar.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  const ChatMessage({required this.text, required this.isUser, required this.time});
}

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hi! I'm Blitz, your pharmacy assistant. I can help you find medicines, check pharmacy hours, or answer dosage questions.",
      isUser: false,
      time: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
  ];

  final _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSend(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true, time: DateTime.now()));
      _isTyping = true;
    });

    _scrollToBottom();

    // Simulate bot response
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text: _mockReply(text),
          isUser: false,
          time: DateTime.now(),
        ));
      });
      _scrollToBottom();
    });
  }

  String _mockReply(String input) {
    final q = input.toLowerCase();
    if (q.contains('ibuprofen') || q.contains('paracetamol') || q.contains('medicine'))
      return 'Yes! El Ezaby Maadi (0.8 km) and Seif Dokki (1.4 km) carry that product. Want me to add it to your cart?';
    if (q.contains('dosage') || q.contains('dose'))
      return 'Standard adult dose is 400–500 mg every 6–8 hours with food. Do not exceed the daily limit without consulting a doctor.';
    if (q.contains('open') || q.contains('hours'))
      return 'El Ezaby Maadi is open 08:00 – 00:00. Seif Dokki is open 24 hrs. Would you like directions?';
    if (q.contains('deliver'))
      return 'Both El Ezaby and Seif offer delivery in your area. Estimated time is 20–40 minutes.';
    return "I can only help with pharmacy and medicine-related questions through the Blitzora app. Try asking about a medicine, pharmacy hours, or your order.";
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
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: primary.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: primary.withOpacity(0.3)),
            ),
            child: Icon(Icons.smart_toy_outlined, color: primary, size: 20),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Blitz assistant', style: TextStyle(color: fg, fontSize: 15, fontWeight: FontWeight.w600)),
            Row(children: [
              Container(width: 7, height: 7,
                decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
              const SizedBox(width: 4),
              Text('Online', style: TextStyle(color: muted, fontSize: 11)),
            ]),
          ]),
        ]),
      ),
      body: Column(children: [
        // messages
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length + (_isTyping ? 1 : 0),
            itemBuilder: (_, i) {
              if (_isTyping && i == _messages.length) {
                return _TypingIndicator(primary: primary, card: card, border: border);
              }
              final msg = _messages[i];
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
        // input
        ChatInputBar(
          primary: primary, card: card, fg: fg, muted: muted, border: border,
          onSend: _handleSend,
        ),
      ]),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  final Color primary, card, border;
  const _TypingIndicator({required this.primary, required this.card, required this.border});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Container(width: 30, height: 30,
          decoration: BoxDecoration(color: primary.withOpacity(0.15), shape: BoxShape.circle),
          child: Icon(Icons.smart_toy_outlined, color: primary, size: 16)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: card, borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4), topRight: Radius.circular(14),
              bottomLeft: Radius.circular(14), bottomRight: Radius.circular(14)),
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
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _anim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(width: 7, height: 7,
        decoration: BoxDecoration(color: widget.primary, shape: BoxShape.circle)));
  }
}
