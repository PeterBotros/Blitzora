import 'package:flutter/material.dart';

class PharmacyCard extends StatelessWidget {
  final String name;
  final String address;
  final double rating;
  final String distance;
  final bool isOpen;
  final Color primaryColor;
  final Color accentColor;
  final Color cardColor;
  final Color foregroundColor;
  final Color mutedColor;
  final VoidCallback? onTap;

  const PharmacyCard(
      {super.key,
      required this.name,
      required this.address,
      required this.rating,
      required this.distance,
      required this.isOpen,
      required this.primaryColor,
      required this.accentColor,
      required this.cardColor,
      required this.foregroundColor,
      required this.mutedColor,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Theme.of(context).colorScheme.outline)),
        child: Column(children: [
          Row(children: [
            Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.local_pharmacy_outlined,
                    color: primaryColor, size: 22)),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(name,
                      style: TextStyle(
                          color: foregroundColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(address,
                      style: TextStyle(color: mutedColor, fontSize: 12),
                      overflow: TextOverflow.ellipsis),
                ])),
            Icon(Icons.arrow_forward_ios_rounded, color: mutedColor, size: 14),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            _Badge(
                label: isOpen ? 'Open now' : 'Closed',
                bg: isOpen
                    ? Colors.green.withOpacity(0.15)
                    : mutedColor.withOpacity(0.12),
                fg: isOpen ? Colors.green.shade400 : mutedColor),
            const SizedBox(width: 6),
            if (distance != '—')
              _Badge(
                  label: distance,
                  bg: accentColor.withOpacity(0.12),
                  fg: accentColor),
            const SizedBox(width: 6),
            _Badge(
                label: '★ $rating',
                bg: Colors.amber.withOpacity(0.12),
                fg: Colors.amber.shade400),
            const Spacer(),
            TextButton(
                onPressed: onTap,
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, minimumSize: Size.zero),
                child: Text('View',
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500))),
          ]),
        ]),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  const _Badge({required this.label, required this.bg, required this.fg});
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style:
              TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.w500)));
}
