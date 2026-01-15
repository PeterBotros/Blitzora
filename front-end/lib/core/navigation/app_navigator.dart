import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

/// Navigation service for the application
class AppNavigator {
  AppNavigator._();

  /// Navigate to a named route
  static Future<T?> pushNamed<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate and replace current route
  static Future<T?> pushReplacementNamed<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed<T, T>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate and remove all previous routes
  static Future<T?> pushNamedAndRemoveUntil<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }

  /// Navigate back
  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }

  /// Navigate back until predicate
  static void popUntil(
      BuildContext context, bool Function(Route<dynamic>) predicate) {
    Navigator.popUntil(context, predicate);
  }

  /// Check if can pop
  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  // ==================== Convenience Methods ====================

  /// Navigate to Auth page
  static Future<T?> toAuth<T>(BuildContext context) {
    return pushNamed<T>(context, AppRoutes.auth);
  }

  /// Navigate to Home/Dashboard
  static Future<T?> toHome<T>(BuildContext context) {
    return pushNamedAndRemoveUntil<T>(
      context,
      AppRoutes.home,
    );
  }

  /// Navigate to Dashboard
  static Future<T?> toDashboard<T>(BuildContext context) {
    return pushNamed<T>(context, AppRoutes.dashboard);
  }

  /// Navigate to Map screen
  static Future<T?> toMapScreen<T>(BuildContext context) {
    return pushNamed<T>(context, AppRoutes.mapScreen);
  }

  /// Navigate to Profile
  static Future<T?> toProfile<T>(BuildContext context) {
    return pushNamed<T>(context, AppRoutes.profile);
  }
}
