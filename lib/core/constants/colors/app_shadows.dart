import 'package:flutter/material.dart';

/// Application shadow definitions
class AppShadows {
  AppShadows._();

  // ==================== Light Mode Shadows ====================
  /// Soft shadow with purple tint
  static const BoxShadow lightSoft = BoxShadow(
    color: Color.fromRGBO(139, 92, 246, 0.2), // hsl(262 83% 58% / 0.2)
    offset: Offset(0, 4),
    blurRadius: 20,
    spreadRadius: -4,
  );

  /// Medium shadow with purple tint
  static const BoxShadow lightMedium = BoxShadow(
    color: Color.fromRGBO(139, 92, 246, 0.35), // hsl(262 83% 58% / 0.35)
    offset: Offset(0, 8),
    blurRadius: 30,
    spreadRadius: -6,
  );

  /// App shadow (elevated from bottom)
  static const BoxShadow lightApp = BoxShadow(
    color: Color.fromRGBO(139, 92, 246, 0.12), // hsl(262 83% 58% / 0.12)
    offset: Offset(0, -2),
    blurRadius: 16,
    spreadRadius: 0,
  );

  // ==================== Dark Mode Shadows ====================
  /// Soft shadow with purple tint (dark)
  static const BoxShadow darkSoft = BoxShadow(
    color: Color.fromRGBO(167, 139, 250, 0.4), // hsl(262 83% 65% / 0.4)
    offset: Offset(0, 4),
    blurRadius: 20,
    spreadRadius: -4,
  );

  /// Medium shadow with purple tint (dark)
  static const BoxShadow darkMedium = BoxShadow(
    color: Color.fromRGBO(167, 139, 250, 0.5), // hsl(262 83% 65% / 0.5)
    offset: Offset(0, 8),
    blurRadius: 30,
    spreadRadius: -6,
  );

  /// App shadow (elevated from bottom) (dark)
  static const BoxShadow darkApp = BoxShadow(
    color: Color.fromRGBO(167, 139, 250, 0.3), // hsl(262 83% 65% / 0.3)
    offset: Offset(0, -2),
    blurRadius: 16,
    spreadRadius: 0,
  );

  // ==================== Helper Lists ====================
  static List<BoxShadow> get lightShadows => [lightSoft];
  static List<BoxShadow> get lightMediumShadows => [lightMedium];
  static List<BoxShadow> get lightAppShadows => [lightApp];
  static List<BoxShadow> get darkShadows => [darkSoft];
  static List<BoxShadow> get darkMediumShadows => [darkMedium];
  static List<BoxShadow> get darkAppShadows => [darkApp];
}
