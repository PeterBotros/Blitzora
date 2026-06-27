import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final DateTime time;
  final Color primary, card, fg, muted, border;

  const ChatBubble({super.key, required this.message, required this.isUser,
      required this.time, required this.primary, required this.card,
      required this.fg, required this.muted, required this.border});

  @override
  Widget build(BuildContext context) {
    final timeStr =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(width: 30, height: 30,
              decoration: BoxDecoration(color: primary.withOpacity(0.15), shape: BoxShape.circle),
              child: Icon(Icons.smart_toy_outlined, color: primary, size: 16)),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isUser ? primary.withOpacity(0.18) : card,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(14),
                      topRight: const Radius.circular(14),
                      bottomLeft: Radius.circular(isUser ? 14 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 14),
                    ),
                    border: Border.all(
                      color: isUser ? primary.withOpacity(0.35) : border),
                  ),
                  child: Text(message,
                    style: TextStyle(color: isUser ? primary : fg, fontSize: 13, height: 1.5)),
                ),
                const SizedBox(height: 3),
                Text(timeStr, style: TextStyle(color: muted, fontSize: 10)),
              ],
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}
