/// Application-wide constants
class AppConstants {
  // API
  // Override at run time with:
  // flutter run --dart-define=API_BASE_URL=http://<YOUR_PC_LAN_IP>:8001/api/v1
  // Examples:
  // - Android emulator: http://10.0.2.2:8001/api/v1
  // - Real Android device: http://192.168.x.x:8001/api/v1 (your PC LAN IP)
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.1.8:8001/api/v1',
  );
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
