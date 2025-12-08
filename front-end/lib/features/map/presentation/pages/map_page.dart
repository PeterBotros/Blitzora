import 'package:flutter/material.dart';

import '../../../../core/constants/colors/app_colors.dart';

/// Map screen showing nearby pharmacies on a map view
class MapScreenPage extends StatelessWidget {
  const MapScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.toColor(AppColors.darkPrimary);
    final accentColor = AppColors.toColor(AppColors.darkAccent);
    final backgroundColor = AppColors.toColor(AppColors.darkBackground);
    final cardColor = AppColors.toColor(AppColors.darkCard);
    final foregroundColor = AppColors.toColor(AppColors.darkForeground);
    final mutedForegroundColor =
        AppColors.toColor(AppColors.darkMutedForeground);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: foregroundColor),
        title: Text(
          'Nearby Pharmacies',
          style: TextStyle(
            color: foregroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location_outlined),
            onPressed: () {
              // TODO: Center map on current location
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Map placeholder
          AspectRatio(
            aspectRatio: 3 / 2,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  // TODO: Replace with real map widget (e.g. GoogleMap)
                  Center(
                    child: Icon(
                      Icons.map_outlined,
                      size: 80,
                      color: primaryColor.withOpacity(0.5),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.place_outlined,
                            color: accentColor,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Showing pharmacies near your current location',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nearby Pharmacies',
                        style: TextStyle(
                          color: foregroundColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '3 found',
                        style: TextStyle(
                          color: mutedForegroundColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _PharmacyListTile(
                    name: 'MedPlus Pharmacy',
                    address: '123 Main Street, Downtown',
                    distance: '0.5 km',
                    rating: 4.8,
                    isOpen: true,
                    primaryColor: primaryColor,
                    foregroundColor: foregroundColor,
                    mutedColor: mutedForegroundColor,
                    cardColor: cardColor,
                  ),
                  _PharmacyListTile(
                    name: 'HealthCare Pharmacy',
                    address: '456 Park Avenue, Central',
                    distance: '1.2 km',
                    rating: 4.6,
                    isOpen: true,
                    primaryColor: primaryColor,
                    foregroundColor: foregroundColor,
                    mutedColor: mutedForegroundColor,
                    cardColor: cardColor,
                  ),
                  _PharmacyListTile(
                    name: 'Apollo Pharmacy',
                    address: '789 Oak Road, Eastside',
                    distance: '2.0 km',
                    rating: 4.9,
                    isOpen: false,
                    primaryColor: primaryColor,
                    foregroundColor: foregroundColor,
                    mutedColor: mutedForegroundColor,
                    cardColor: cardColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PharmacyListTile extends StatelessWidget {
  final String name;
  final String address;
  final String distance;
  final double rating;
  final bool isOpen;
  final Color primaryColor;
  final Color foregroundColor;
  final Color mutedColor;
  final Color cardColor;

  const _PharmacyListTile({
    required this.name,
    required this.address,
    required this.distance,
    required this.rating,
    required this.isOpen,
    required this.primaryColor,
    required this.foregroundColor,
    required this.mutedColor,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.local_pharmacy_outlined,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          color: foregroundColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.star_rounded,
                      color: Colors.amber[400],
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(
                        color: foregroundColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: mutedColor,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.place_outlined,
                      size: 14,
                      color: mutedColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      distance,
                      style: TextStyle(
                        color: mutedColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: mutedColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isOpen ? 'Open' : 'Closed',
                      style: TextStyle(
                        color: isOpen ? primaryColor : mutedColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


