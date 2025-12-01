import 'package:flutter/material.dart';

class PromoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String largeText;
  final String smallText;
  final Color cardColor;
  final Color textColor;
  final Color mutedColor;

  const PromoCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.largeText,
    required this.smallText,
    required this.cardColor,
    required this.textColor,
    required this.mutedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 12),
          Text(
            largeText,
            style: TextStyle(
              color: iconColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            smallText,
            style: TextStyle(
              color: mutedColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

