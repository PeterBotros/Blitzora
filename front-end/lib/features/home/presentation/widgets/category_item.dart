import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color cardColor;
  final Color textColor;

  const CategoryItem({super.key, required this.icon, required this.label,
      required this.color, required this.cardColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        Container(width: 64, height: 64,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.25)),
          ),
          child: Icon(icon, color: color, size: 28)),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center),
      ]),
    );
  }
}
