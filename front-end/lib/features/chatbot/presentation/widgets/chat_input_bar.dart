import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ChatInputBar extends StatefulWidget {
  final Color primary, card, fg, muted, border;
  final void Function(String) onSend;

  const ChatInputBar({super.key, required this.primary, required this.card,
      required this.fg, required this.muted, required this.border, required this.onSend});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final has = _controller.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      decoration: BoxDecoration(
        color: widget.card,
        border: Border(top: BorderSide(color: widget.border)),
      ),
      child: Row(children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: widget.border),
            ),
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => _send(),
              maxLines: 4, minLines: 1,
              style: TextStyle(color: widget.fg, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'ask_about_medicines'.tr(),
                hintStyle: TextStyle(color: widget.muted, fontSize: 14),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 44, height: 44,
          decoration: BoxDecoration(
            color: _hasText ? widget.primary : widget.primary.withOpacity(0.25),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: _hasText ? _send : null,
            icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
          ),
        ),
      ]),
    );
  }
}
