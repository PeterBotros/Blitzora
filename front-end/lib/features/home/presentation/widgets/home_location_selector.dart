import 'package:flutter/material.dart';
import '../../services/location_service.dart';

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
  String _location = 'Loading...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    try {
      final location = await LocationService.getDefaultLocation();
      if (mounted) {
        setState(() {
          _location = location ?? 'Location not available';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _location = 'Location not available';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(Icons.location_on, color: widget.primaryColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: _isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.primaryColor,
                      ),
                    ),
                  )
                : Text(
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
            onPressed: _isLoading ? null : () {
              // Refresh location
              setState(() {
                _isLoading = true;
                _location = 'Loading...';
              });
              _loadLocation();
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

