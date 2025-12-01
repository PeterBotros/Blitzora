/// Input validation utilities
class InputValidator {
  /// Validates email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validates phone number format
  static bool isValidPhone(String phone) {
    return RegExp(r'^\+?[\d\s-()]+$').hasMatch(phone);
  }

  /// Validates password strength
  static bool isValidPassword(String password) {
    return password.length >= 8;
  }

  /// Validates if string is not empty
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}
