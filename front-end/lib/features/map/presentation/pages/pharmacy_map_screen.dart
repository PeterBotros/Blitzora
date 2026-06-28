import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/constants/colors/app_colors.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/bloc/home_event.dart';
import '../../../home/presentation/bloc/home_state.dart';
import '../../../home/domain/entities/pharmacy_entity.dart';
import 'pharmacy_detail_page.dart';

class PharmacyMapScreen extends StatefulWidget {
  const PharmacyMapScreen({super.key});

  @override
  State<PharmacyMapScreen> createState() => _PharmacyMapScreenState();
}

class _PharmacyMapScreenState extends State<PharmacyMapScreen> {
  final MapController _mapController = MapController();
  // Default center: Cairo, Egypt
  LatLng _center = const LatLng(30.0444, 31.2357);
  final double _initialZoom = 13.0;

  LatLng? _userLocation;
  bool _isLocationLoading = false;
  PharmacyEntity? _selectedPharmacy;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const LoadHomeEvent());
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    if (!mounted) return;
    setState(() => _isLocationLoading = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnackBar('Location services are disabled.', Colors.orange);
        setState(() => _isLocationLoading = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showSnackBar('Location permission denied.', Colors.orange);
        setState(() => _isLocationLoading = false);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (!mounted) return;

      final loc = LatLng(position.latitude, position.longitude);
      setState(() {
        _userLocation = loc;
        _center = loc;
        _isLocationLoading = false;
      });
      _mapController.move(loc, _initialZoom);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLocationLoading = false);
      _showSnackBar('Could not get location.', Colors.orange);
    }
  }

  void _centerOnUser() {
    if (_userLocation != null) {
      _mapController.move(_userLocation!, _initialZoom);
    } else {
      _getCurrentLocation();
    }
  }

  void _zoomIn() {
    _mapController.move(_mapController.camera.center,
        (_mapController.camera.zoom + 1).clamp(5.0, 18.0));
  }

  void _zoomOut() {
    _mapController.move(_mapController.camera.center,
        (_mapController.camera.zoom - 1).clamp(5.0, 18.0));
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: color,
        duration: const Duration(seconds: 3)));
  }

  /// Build a marker for a pharmacy from real API data.
  /// If the pharmacy has lat/lng, place it precisely; otherwise scatter
  /// it around the map center so it still appears.
  Marker _buildMarker(PharmacyEntity pharmacy, int index, Color primary) {
    final lat = pharmacy.latitude ?? (_center.latitude + (index - 2) * 0.006);
    final lng =
        pharmacy.longitude ?? (_center.longitude + (index % 3 - 1) * 0.007);
    final point = LatLng(lat, lng);
    final isSelected = _selectedPharmacy?.id == pharmacy.id;

    return Marker(
      point: point,
      width: isSelected ? 60 : 48,
      height: isSelected ? 60 : 48,
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedPharmacy = pharmacy);
          _mapController.move(point, _mapController.camera.zoom);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? primary : Colors.red,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: isSelected ? 3 : 2),
            boxShadow: [
              BoxShadow(
                  color: (isSelected ? primary : Colors.red).withOpacity(0.4),
                  blurRadius: isSelected ? 12 : 6,
                  spreadRadius: isSelected ? 2 : 0,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Icon(Icons.local_pharmacy,
              color: Colors.white, size: isSelected ? 32 : 24),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final primary = AppColors.primary(dark);
    final bg = AppColors.background(dark);
    final card = AppColors.card(dark);
    final fg = AppColors.fg(dark);
    final muted = AppColors.muted(dark);
    final border = AppColors.border(dark);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Pharmacies Map'),
        actions: [
          IconButton(
            icon: _isLocationLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.my_location),
            onPressed: _centerOnUser,
            tooltip: 'My Location',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<HomeBloc>().add(const LoadHomeEvent()),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final pharmacies =
              state is HomeLoaded ? state.pharmacies : <PharmacyEntity>[];
          final isLoading = state is HomeLoading;

          return Stack(children: [
            // ── Map ──────────────────────────────────────────────────────
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _center,
                initialZoom: _initialZoom,
                minZoom: 5.0,
                maxZoom: 18.0,
                onTap: (_, __) => setState(() => _selectedPharmacy = null),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.blitzora.app',
                  maxZoom: 19,
                  subdomains: const ['a', 'b', 'c'],
                ),
                // User location
                if (_userLocation != null)
                  MarkerLayer(markers: [
                    Marker(
                      point: _userLocation!,
                      width: 50,
                      height: 50,
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.blue.withOpacity(0.5),
                                  blurRadius: 8,
                                  spreadRadius: 2)
                            ],
                          ),
                          child: const Icon(Icons.person_pin_circle,
                              color: Colors.white, size: 28)),
                    ),
                  ]),
                // Pharmacy markers from real API data
                if (pharmacies.isNotEmpty)
                  MarkerLayer(
                    markers: pharmacies
                        .asMap()
                        .entries
                        .map((e) => _buildMarker(e.value, e.key, primary))
                        .toList(),
                  ),
              ],
            ),

            // ── Loading overlay ───────────────────────────────────────────
            if (isLoading)
              Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator())),

            // ── Zoom controls ─────────────────────────────────────────────
            Positioned(
              right: 16,
              top: 16,
              child: Column(children: [
                _ZoomButton(icon: Icons.add, onTap: _zoomIn),
                const SizedBox(height: 2),
                _ZoomButton(icon: Icons.remove, onTap: _zoomOut),
              ]),
            ),

            // ── Selected pharmacy card ────────────────────────────────────
            if (_selectedPharmacy != null)
              Positioned(
                left: 16,
                right: 16,
                bottom: 24,
                child: _PharmacyCard(
                  pharmacy: _selectedPharmacy!,
                  primary: primary,
                  card: card,
                  fg: fg,
                  muted: muted,
                  border: border,
                  onViewDetails: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => PharmacyDetailPage(
                              pharmacy: _selectedPharmacy!))),
                  onClose: () => setState(() => _selectedPharmacy = null),
                ),
              )
            // ── Pharmacy count badge (when nothing selected) ───────────────
            else if (!isLoading && pharmacies.isNotEmpty)
              Positioned(
                bottom: 16,
                left: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: border),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2))
                    ],
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.local_pharmacy, color: primary, size: 20),
                    const SizedBox(width: 8),
                    Text('${pharmacies.length} pharmacies found',
                        style: TextStyle(
                            color: fg,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                  ]),
                ),
              ),
          ]);
        },
      ),
    );
  }
}

// ── Zoom button helper ────────────────────────────────────────────────────────
class _ZoomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ZoomButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Icon(icon, color: Colors.black87, size: 24))),
        ),
      );
}

// ── Selected pharmacy bottom card ─────────────────────────────────────────────
class _PharmacyCard extends StatelessWidget {
  final PharmacyEntity pharmacy;
  final Color primary, card, fg, muted, border;
  final VoidCallback onViewDetails;
  final VoidCallback onClose;

  const _PharmacyCard({
    required this.pharmacy,
    required this.primary,
    required this.card,
    required this.fg,
    required this.muted,
    required this.border,
    required this.onViewDetails,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.local_pharmacy_outlined,
                  color: primary, size: 22)),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(pharmacy.name,
                    style: TextStyle(
                        color: fg, fontSize: 15, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis),
                if (pharmacy.address != null)
                  Text(pharmacy.address!,
                      style: TextStyle(color: muted, fontSize: 12),
                      overflow: TextOverflow.ellipsis),
              ])),
          IconButton(
              icon: Icon(Icons.close, color: muted, size: 18),
              onPressed: onClose,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints()),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: pharmacy.isOpen
                      ? Colors.green.withOpacity(0.12)
                      : muted.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20)),
              child: Text(pharmacy.isOpen ? 'Open now' : 'Closed',
                  style: TextStyle(
                      color: pharmacy.isOpen ? Colors.green.shade400 : muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600))),
          if (pharmacy.opensAt != null) ...[
            const SizedBox(width: 8),
            Text('${pharmacy.opensAt} – ${pharmacy.closesAt}',
                style: TextStyle(color: muted, fontSize: 12)),
          ],
          const Spacer(),
          ElevatedButton(
              onPressed: onViewDetails,
              style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: const Text('View details',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
        ]),
      ]),
    );
  }
}
