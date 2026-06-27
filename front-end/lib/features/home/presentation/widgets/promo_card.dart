import 'package:flutter/material.dart';

class PromoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String largeText;
  final String smallText;
  final Color cardColor;
  final Color textColor;
  final Color mutedColor;

  const PromoCard({super.key, required this.icon, required this.iconColor,
      required this.largeText, required this.smallText, required this.cardColor,
      required this.textColor, required this.mutedColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 36, height: 36, decoration: BoxDecoration(
          color: iconColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: iconColor, size: 20)),
        const SizedBox(height: 10),
        Text(largeText, style: TextStyle(color: iconColor, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(smallText, style: TextStyle(color: mutedColor, fontSize: 12)),
      ]),
    );
  }
}
