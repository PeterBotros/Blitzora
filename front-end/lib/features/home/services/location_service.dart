import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_constants.dart';

/// Service for fetching location data from the backend
class LocationService {
  static const String backendBaseUrl = AppConstants.baseUrl;

  /// Get the first pharmacy location from the database
  /// Returns the address string, or null if not found
  static Future<String?> getDefaultLocation() async {
    try {
      final uri = Uri.parse('$backendBaseUrl/pharmacies/').replace(
        queryParameters: {
          'skip': '0',
          'limit': '1',
        },
      );

      final response = await http.get(
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

      if (response.statusCode != 200) {
        return null;
      }

      final List<dynamic> data = json.decode(response.body);
      if (data.isEmpty) {
        return null;
      }

      final pharmacy = data[0];
      final address = pharmacy['address']?.toString();

      // Return address if available, otherwise return name
      if (address != null && address.isNotEmpty) {
        return address;
      }

      return pharmacy['name']?.toString() ?? 'Location';
    } catch (e) {
      // Return null on error - widget will show fallback
      return null;
    }
  }
}
