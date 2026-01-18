/// Application-wide constants
class AppConstants {
  // API
  // For Android emulator use 10.0.2.2, for iOS simulator use localhost, for Windows use localhost
  // Change to 'http://localhost:8001/api/v1' when running on Windows desktop or iOS simulator
  static const String baseUrl = 'http://10.0.2.2:8001/api/v1';
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';

  // Pagination
  static const int defaultPageSize = 20;

  // Private constructor to prevent instantiation
  AppConstants._();
}
