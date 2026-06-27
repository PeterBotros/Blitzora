import 'package:flutter/material.dart';

class HomeLocationSelector extends StatefulWidget {
  final Color primaryColor;
  final Color foregroundColor;

  const HomeLocationSelector({
    super.key,
    required this.primaryColor,
    required this.foregroundColor,
  });

  @override
  State<HomeLocationSelector> createState() => _HomeLocationSelectorState();
}

class _HomeLocationSelectorState extends State<HomeLocationSelector> {
  String _location = '123 Main Street, San Francisco, CA';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(Icons.location_on, color: widget.primaryColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _location,
              style: TextStyle(
                color: widget.foregroundColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Let the user pick a different location
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Change',
              style: TextStyle(
                color: widget.primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

