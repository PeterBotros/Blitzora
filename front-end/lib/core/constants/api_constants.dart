class ApiConstants {
  ApiConstants._();
  static const String baseUrl = 'http://10.0.2.2:8001/api/v1';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String me = '/auth/me';
  static const String products = '/products/';
  static const String pharmacies = '/pharmacies/';
  static const String nearbyPharmacies = '/pharmacies/nearby/';
  static const String categories = '/categories/';
  static const String offers = '/offers/';
  static const String cart = '/cart/';
  static const String cartAdd = '/cart/add';
  static const String orders = '/orders/';
  static const String chatbot = '/chatbot/chat';
  static const String notifications = '/notifications/';
  static const String favorites = '/favorites/';
  static const String reminders = '/reminders/';
  static const String prescriptions = '/prescriptions/';
}
