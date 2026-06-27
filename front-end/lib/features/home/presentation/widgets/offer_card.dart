import 'package:flutter/material.dart';

class OfferCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String title;
  final String discount;
  final String description;
  final String validity;
  final Color primaryColor;
  final Color cardColor;
  final Color foregroundColor;
  final Color mutedColor;

  const OfferCard({super.key, required this.icon, required this.iconColor,
      required this.iconBackgroundColor, required this.title,
      required this.discount, required this.description, required this.validity,
      required this.primaryColor, required this.cardColor,
      required this.foregroundColor, required this.mutedColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).colorScheme.outline)),
      child: Row(children: [
        Container(width: 48, height: 48,
          decoration: BoxDecoration(color: iconBackgroundColor, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: iconColor, size: 24)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(title, style: TextStyle(color: foregroundColor, fontSize: 14, fontWeight: FontWeight.w600))),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(color: primaryColor.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
              child: Text(discount, style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.bold))),
          ]),
          const SizedBox(height: 3),
          Text(description, style: TextStyle(color: mutedColor, fontSize: 12)),
          const SizedBox(height: 4),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(validity, style: TextStyle(color: mutedColor, fontSize: 11)),
            TextButton(onPressed: () {},
              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
              child: Text('Apply', style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.w500))),
          ]),
        ])),
      ]),
    );
  }
}
