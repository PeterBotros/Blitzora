import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/pharmacy_marker.dart';

/// Pharmacy Map Screen - Shows nearby pharmacies on OpenStreetMap
class PharmacyMapScreen extends StatefulWidget {
  const PharmacyMapScreen({super.key});

  @override
  State<PharmacyMapScreen> createState() => _PharmacyMapScreenState();
}

class _PharmacyMapScreenState extends State<PharmacyMapScreen> {
  final MapController _mapController = MapController();
  // Default center (San Francisco) - will be updated with user location
  LatLng _initialCenter = const LatLng(37.7749000, -122.4194000);
  final double _initialZoom = 14.0;

  List<PharmacyMarker> _pharmacies = [];
  bool _isLoading = true;
  String? _errorMessage;
  LatLng? _userLocation;
  bool _isLocationLoading = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadNearbyPharmacies();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  /// Get current user location
  Future<void> _getCurrentLocation() async {
    if (!mounted) return;

    setState(() {
      _isLocationLoading = true;
    });

    try {
      // Check location permission
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        setState(() {
          _isLocationLoading = false;
        });
        _showLocationError('Location services are disabled. Please enable them in settings.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (!mounted) return;
          setState(() {
            _isLocationLoading = false;
          });
          _showLocationError('Location permissions are denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        setState(() {
          _isLocationLoading = false;
        });
        _showLocationError('Location permissions are permanently denied. Please enable them in settings.');
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;

      final userLocation = LatLng(position.latitude, position.longitude);
      
      setState(() {
        _userLocation = userLocation;
        _initialCenter = userLocation;
        _isLocationLoading = false;
      });

      // Center map on user location
      _mapController.move(userLocation, _initialZoom);
      
      // Reload pharmacies based on user location
      _loadNearbyPharmacies();
    } catch (e) {
      if (!mounted) return;
      
      print('❌ Error getting location: $e');
      setState(() {
        _isLocationLoading = false;
      });
      _showLocationError('Failed to get location: $e');
    }
  }

  /// Show location error message
  void _showLocationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Center map on user location
  void _centerOnUserLocation() {
    if (_userLocation != null) {
      _mapController.move(_userLocation!, _initialZoom);
    } else {
      _getCurrentLocation();
    }
  }

  /// Load nearby pharmacies (mock data — no backend required)
  Future<void> _loadNearbyPharmacies() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate a brief load so the UI feels real, then populate with
    // a handful of mock pharmacies scattered around the current center.
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    final centerLat = _userLocation?.latitude ?? _initialCenter.latitude;
    final centerLon = _userLocation?.longitude ?? _initialCenter.longitude;

    final mockPharmacies = <PharmacyMarker>[
      PharmacyMarker(
        location: LatLng(centerLat + 0.004, centerLon + 0.003),
        name: 'Sunrise Pharmacy',
        address: '123 Main Street',
      ),
      PharmacyMarker(
        location: LatLng(centerLat - 0.003, centerLon + 0.005),
        name: 'HealthFirst Pharmacy',
        address: '456 Oak Avenue',
      ),
      PharmacyMarker(
        location: LatLng(centerLat + 0.002, centerLon - 0.004),
        name: 'CarePlus Pharmacy',
        address: '789 Pine Road',
      ),
    ];

    setState(() {
      _pharmacies = mockPharmacies;
      _isLoading = false;
    });
  }

  /// Zoom in on the map
  void _zoomIn() {
    final currentZoom = _mapController.camera.zoom;
    final newZoom = (currentZoom + 1).clamp(5.0, 18.0);
    _mapController.move(_mapController.camera.center, newZoom);
  }

  /// Zoom out on the map
  void _zoomOut() {
    final currentZoom = _mapController.camera.zoom;
    final newZoom = (currentZoom - 1).clamp(5.0, 18.0);
    _mapController.move(_mapController.camera.center, newZoom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacies Map'),
        actions: [
          IconButton(
            icon: _isLocationLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.my_location),
            onPressed: _centerOnUserLocation,
            tooltip: 'My Location',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNearbyPharmacies,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialCenter,
              initialZoom: _initialZoom,
              minZoom: 5.0,
              maxZoom: 18.0,
            ),
            children: [
              // OpenStreetMap tiles - using HOT (Humanitarian OpenStreetMap Team) tiles as they're more reliable
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.blitzora.app',
                maxZoom: 19,
                subdomains: const ['a', 'b', 'c'],
                // Alternative tile providers if needed:
                // CartoDB Voyager: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png'
                // Standard OSM: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
              ),
              // User location marker
              if (_userLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _userLocation!,
                      width: 50,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              // Pharmacy markers
              MarkerLayer(
                markers: _pharmacies.map((pharmacy) {
                  return Marker(
                    point: pharmacy.location,
                    width: 50,
                    height: 50,
                    child: GestureDetector(
                      onTap: () => _showPharmacyInfo(pharmacy),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.local_pharmacy,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          // Loading indicator
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          // Error message
          if (_errorMessage != null && !_isLoading)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        if (mounted) {
                          setState(() {
                            _errorMessage = null;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          // Zoom controls
          Positioned(
            right: 16,
            top: 16,
            child: Column(
              children: [
                // Zoom in button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _zoomIn,
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.add,
                          color: Colors.black87,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                // Zoom out button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _zoomOut,
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.remove,
                          color: Colors.black87,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Pharmacy count badge
          if (!_isLoading && _pharmacies.isNotEmpty)
            Positioned(
              bottom: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_pharmacy,
                      color: Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_pharmacies.length} pharmacies found',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Show pharmacy information in a dialog
  void _showPharmacyInfo(PharmacyMarker pharmacy) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.local_pharmacy, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                pharmacy.name,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (pharmacy.address != null) ...[
              const Text(
                'Address:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(pharmacy.address!),
              const SizedBox(height: 12),
            ],
            const Text(
              'Coordinates:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Lat: ${pharmacy.location.latitude.toStringAsFixed(6)}\n'
              'Lon: ${pharmacy.location.longitude.toStringAsFixed(6)}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
