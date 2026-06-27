class ApiConstants {
  ApiConstants._();

  // Change to your machine IP if running on a physical device
  // Android emulator: 10.0.2.2  |  iOS simulator: localhost
  static const String baseUrl = 'http://10.0.2.2:8001/api/v1';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String me = '/auth/me';

  // Products
  static const String products = '/products';

  // Pharmacies
  static const String pharmacies = '/pharmacies';
  static const String nearbyPharmacies = '/pharmacies/nearby';

  // Categories
  static const String categories = '/categories';

  // Cart
  static const String cart = '/cart';
  static const String cartAdd = '/cart/add';

  // Orders
  static const String orders = '/orders';

  // Chatbot
  static const String chatbot = '/chatbot/chat';
}
