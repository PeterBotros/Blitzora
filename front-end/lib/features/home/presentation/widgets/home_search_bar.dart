import 'package:flutter/material.dart';

class HomeSearchBar extends StatelessWidget {
  final Color cardColor;
  final Color mutedForegroundColor;
  final Color foregroundColor;

  const HomeSearchBar({
    super.key,
    required this.cardColor,
    required this.mutedForegroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search medicines, health pro',
            hintStyle: TextStyle(color: mutedForegroundColor),
            prefixIcon: Icon(Icons.search, color: mutedForegroundColor),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          style: TextStyle(color: foregroundColor),
        ),
      ),
    );
  }
}

