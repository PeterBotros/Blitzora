import 'package:latlong2/latlong.dart';

/// Pharmacy marker data model for map display
class PharmacyMarker {
  final LatLng location;
  final String name;
  final String? address;

  PharmacyMarker({
    required this.location,
    required this.name,
    this.address,
  });
}

