import 'package:flutter/material.dart';

/// Application gradient definitions
class AppGradients {
  AppGradients._();

  // ==================== Light Mode Gradients ====================
  /// Primary gradient: purple to cyan
  static const Gradient lightPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 139, 92, 246), // hsl(262 83% 58%)
      Color.fromARGB(255, 14, 165, 233), // hsl(198 93% 60%)
    ],
  );

  /// Secondary gradient: cyan to teal
  static const Gradient lightSecondary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 14, 165, 233), // hsl(198 93% 60%)
      Color.fromARGB(255, 20, 184, 166), // hsl(170 80% 55%)
    ],
  );

  /// Hero gradient: purple -> cyan -> pink
  static const Gradient lightHero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 139, 92, 246), // hsl(262 83% 58%)
      Color.fromARGB(255, 14, 165, 233), // hsl(198 93% 60%)
      Color.fromARGB(255, 236, 72, 153), // hsl(340 82% 62%)
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// App background gradient
  static const Gradient lightAppBg = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 245, 243, 255), // hsl(262 70% 96%)
      Color.fromARGB(255, 240, 253, 255), // hsl(198 80% 97%)
    ],
  );

  // ==================== Dark Mode Gradients ====================
  /// Primary gradient: purple to cyan (dark)
  static const Gradient darkPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 167, 139, 250), // hsl(262 83% 65%)
      Color.fromARGB(255, 56, 189, 248), // hsl(198 93% 65%)
    ],
  );

  /// Secondary gradient: cyan to teal (dark)
  static const Gradient darkSecondary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 56, 189, 248), // hsl(198 93% 65%)
      Color.fromARGB(255, 45, 212, 191), // hsl(170 80% 60%)
    ],
  );

  /// Hero gradient: purple -> cyan -> pink (dark)
  static const Gradient darkHero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 167, 139, 250), // hsl(262 83% 65%)
      Color.fromARGB(255, 56, 189, 248), // hsl(198 93% 65%)
      Color.fromARGB(255, 244, 114, 182), // hsl(340 82% 68%)
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// App background gradient (dark)
  static const Gradient darkAppBg = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 20, 21, 26), // hsl(240 15% 8%)
      Color.fromARGB(255, 23, 24, 30), // hsl(240 12% 10%)
    ],
  );
}
