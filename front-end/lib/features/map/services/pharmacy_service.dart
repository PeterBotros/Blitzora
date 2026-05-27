import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../models/pharmacy_marker.dart';

/// Service for fetching nearby pharmacies
/// Can switch between Overpass API and backend API
class PharmacyService {
  // Set to true to use backend API (DB data), false for Overpass API
  static const bool useBackendAPI = true;
  // For Android emulator use 10.0.2.2; adjust host/port for your setup
  // Include API prefix
  static const String backendBaseUrl = 'http://10.0.2.2:8001/api/v1';

  /// Get nearby pharmacies
  ///
  /// [lat] - Latitude coordinate
  /// [lon] - Longitude coordinate
  /// [radiusKm] - Search radius in kilometers (default: 2km)
  ///
  /// Returns a list of PharmacyMarker objects
  static Future<List<PharmacyMarker>> getNearbyPharmacies(
    double lat,
    double lon, {
    double radiusKm = 2.0,
  }) async {
    if (useBackendAPI) {
      return _getFromBackend(lat, lon, radiusKm);
    } else {
      return _getFromOverpass(lat, lon, radiusKm);
    }
  }

  /// Get pharmacies from Overpass API
  static Future<List<PharmacyMarker>> _getFromOverpass(
    double lat,
    double lon,
    double radiusKm,
  ) async {
    const String overpassUrl = 'https://overpass-api.de/api/interpreter';

    // Convert radius from km to meters
    final int radiusMeters = (radiusKm * 1000).round();

    final String query = '''
[out:json];
(
  node["amenity"="pharmacy"](around:$radiusMeters, $lat, $lon);
);
out body;
''';

    try {
      final response = await http.post(
        Uri.parse(overpassUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'data': query},
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }

      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> elements = data['elements'] ?? [];

      return _parseOSMElements(elements);
    } on FormatException {
      throw Exception('Invalid JSON response from Overpass API');
    } catch (e) {
      if (e.toString().contains('Failed to fetch')) {
        rethrow;
      }
      throw Exception('Failed to fetch pharmacies from Overpass: $e');
    }
  }

  /// Get pharmacies from backend API
  static Future<List<PharmacyMarker>> _getFromBackend(
    double lat,
    double lon,
    double radiusKm,
  ) async {
    // Try nearby endpoint first
    try {
      return await _getNearbyFromBackend(lat, lon, radiusKm);
    } catch (e) {
      print('⚠️ Nearby endpoint failed: $e');
      print('🔄 Falling back to list all pharmacies...');
      // Fallback to getting all pharmacies and filtering client-side
      return await _getAllPharmaciesFromBackend(lat, lon, radiusKm);
    }
  }

  /// Get nearby pharmacies from backend API
  static Future<List<PharmacyMarker>> _getNearbyFromBackend(
    double lat,
    double lon,
    double radiusKm,
  ) async {
    http.Response? response;
    try {
      final uri = Uri.parse('$backendBaseUrl/pharmacies/nearby').replace(
        queryParameters: {
          'latitude': lat.toString(),
          'longitude': lon.toString(),
          'radius_km': radiusKm.toString(),
        },
      );

      print('🔍 Fetching nearby pharmacies from: $uri');

      response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      print('📡 Response status: ${response.statusCode}');
      print('📦 Response body: ${response.body}');

      if (response.statusCode != 200) {
        final errorBody =
            response.body.isNotEmpty ? json.decode(response.body) : null;
        final errorMessage = errorBody?['detail'] ?? response.reasonPhrase;
        throw Exception('HTTP ${response.statusCode}: $errorMessage');
      }

      final List<dynamic> data = json.decode(response.body);
      print('✅ Parsed ${data.length} pharmacies from nearby API');

      final markers = _parseBackendResponse(data);
      print('📍 Created ${markers.length} pharmacy markers');

      return markers;
    } on FormatException catch (e) {
      print('❌ FormatException: $e');
      print('Response body: ${response?.body ?? 'N/A'}');
      throw Exception('Invalid response format from backend: $e');
    } catch (e) {
      print('❌ Error fetching nearby pharmacies: $e');
      rethrow;
    }
  }

  /// Get all pharmacies from backend and filter client-side
  static Future<List<PharmacyMarker>> _getAllPharmaciesFromBackend(
    double lat,
    double lon,
    double radiusKm,
  ) async {
    http.Response? response;
    try {
      final uri = Uri.parse('$backendBaseUrl/pharmacies/').replace(
        queryParameters: {
          'skip': '0',
          'limit': '100',
        },
      );

      print('🔍 Fetching all pharmacies from: $uri');

      response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode != 200) {
        final errorBody =
            response.body.isNotEmpty ? json.decode(response.body) : null;
        final errorMessage = errorBody?['detail'] ?? response.reasonPhrase;
        throw Exception('HTTP ${response.statusCode}: $errorMessage');
      }

      final List<dynamic> data = json.decode(response.body);
      print('✅ Parsed ${data.length} pharmacies from list API');

      // Parse all pharmacies
      final allMarkers = _parseBackendResponse(data);

      // Filter by distance client-side
      final nearbyMarkers = _filterByDistance(allMarkers, lat, lon, radiusKm);
      print('📍 Filtered to ${nearbyMarkers.length} nearby pharmacies');

      return nearbyMarkers;
    } on FormatException catch (e) {
      print('❌ FormatException: $e');
      throw Exception('Invalid response format from backend: $e');
    } catch (e) {
      print('❌ Error fetching all pharmacies: $e');
      throw Exception('Failed to fetch pharmacies from backend: $e');
    }
  }

  /// Filter pharmacies by distance (Haversine formula)
  static List<PharmacyMarker> _filterByDistance(
    List<PharmacyMarker> pharmacies,
    double centerLat,
    double centerLon,
    double radiusKm,
  ) {
    final filtered = <PharmacyMarker>[];

    for (final pharmacy in pharmacies) {
      final distance = _calculateDistance(
        centerLat,
        centerLon,
        pharmacy.location.latitude,
        pharmacy.location.longitude,
      );

      if (distance <= radiusKm) {
        filtered.add(pharmacy);
      }
    }

    return filtered;
  }

  /// Calculate distance between two coordinates using Haversine formula
  /// Returns distance in kilometers
  static double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  static double _toRadians(double degrees) {
    return degrees * (math.pi / 180.0);
  }

  /// Parse OSM elements into PharmacyMarker objects
  static List<PharmacyMarker> _parseOSMElements(List<dynamic> elements) {
    final List<PharmacyMarker> pharmacies = [];

    for (final element in elements) {
      if (element['type'] == 'node' &&
          element['lat'] != null &&
          element['lon'] != null) {
        final double pharmacyLat = element['lat'].toDouble();
        final double pharmacyLon = element['lon'].toDouble();

        final Map<String, dynamic>? tags = element['tags'];
        final String name = tags?['name'] ?? tags?['name:en'] ?? 'Pharmacy';
        final String? address = tags?['addr:full'] ??
            tags?['addr:street'] ??
            (tags?['addr:housenumber'] != null && tags?['addr:street'] != null
                ? '${tags!['addr:housenumber']} ${tags['addr:street']}'
                : null);

        pharmacies.add(
          PharmacyMarker(
            location: LatLng(pharmacyLat, pharmacyLon),
            name: name,
            address: address,
          ),
        );
      }
    }

    return pharmacies;
  }

  /// Parse backend API response into PharmacyMarker objects
  static List<PharmacyMarker> _parseBackendResponse(List<dynamic> data) {
    final List<PharmacyMarker> pharmacies = [];

    for (final item in data) {
      try {
        if (item is Map<String, dynamic>) {
          print(
              '🔍 Parsing item: ${item['name']} - lat: ${item['latitude']}, lon: ${item['longitude']}');

          if (item['latitude'] != null && item['longitude'] != null) {
            final lat = item['latitude'] is num
                ? (item['latitude'] as num).toDouble()
                : double.tryParse(item['latitude'].toString());
            final lon = item['longitude'] is num
                ? (item['longitude'] as num).toDouble()
                : double.tryParse(item['longitude'].toString());

            print('📍 Parsed coordinates: lat=$lat, lon=$lon');

            if (lat != null && lon != null) {
              pharmacies.add(
                PharmacyMarker(
                  location: LatLng(lat, lon),
                  name: item['name']?.toString() ?? 'Pharmacy',
                  address: item['address']?.toString(),
                ),
              );
              print('✅ Added pharmacy: ${item['name']}');
            } else {
              print('⚠️ Invalid coordinates for ${item['name']}');
            }
          } else {
            print('⚠️ Missing coordinates for ${item['name']}');
          }
        }
      } catch (e) {
        print('❌ Error parsing item: $e');
        // Skip invalid entries
        continue;
      }
    }

    return pharmacies;
  }
}
