import 'package:flutter/material.dart';
import '../constants/colors/app_colors.dart';

/// Sidebar theme configuration
class SidebarTheme {
  SidebarTheme._();

  /// Light mode sidebar theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor:
          AppColors.toColor(AppColors.lightSidebarBackground),
      colorScheme: ColorScheme.light(
        primary: AppColors.toColor(AppColors.lightSidebarPrimary),
        onPrimary: AppColors.toColor(AppColors.lightSidebarPrimaryForeground),
        surface: AppColors.toColor(AppColors.lightSidebarBackground),
        onSurface: AppColors.toColor(AppColors.lightSidebarForeground),
        surfaceVariant: AppColors.toColor(AppColors.lightSidebarAccent),
        onSurfaceVariant:
            AppColors.toColor(AppColors.lightSidebarAccentForeground),
        outline: AppColors.toColor(AppColors.lightSidebarBorder),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.toColor(AppColors.lightSidebarBorder),
        thickness: 1,
      ),
    );
  }

  /// Dark mode sidebar theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor:
          AppColors.toColor(AppColors.darkSidebarBackground),
      colorScheme: ColorScheme.dark(
        primary: AppColors.toColor(AppColors.darkSidebarPrimary),
        onPrimary: AppColors.toColor(AppColors.darkSidebarPrimaryForeground),
        surface: AppColors.toColor(AppColors.darkSidebarBackground),
        onSurface: AppColors.toColor(AppColors.darkSidebarForeground),
        surfaceVariant: AppColors.toColor(AppColors.darkSidebarAccent),
        onSurfaceVariant:
            AppColors.toColor(AppColors.darkSidebarAccentForeground),
        outline: AppColors.toColor(AppColors.darkSidebarBorder),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.toColor(AppColors.darkSidebarBorder),
        thickness: 1,
      ),
    );
  }

  /// Get sidebar colors for light mode
  static SidebarColors get lightColors => SidebarColors(
        background: AppColors.toColor(AppColors.lightSidebarBackground),
        foreground: AppColors.toColor(AppColors.lightSidebarForeground),
        primary: AppColors.toColor(AppColors.lightSidebarPrimary),
        primaryForeground:
            AppColors.toColor(AppColors.lightSidebarPrimaryForeground),
        accent: AppColors.toColor(AppColors.lightSidebarAccent),
        accentForeground:
            AppColors.toColor(AppColors.lightSidebarAccentForeground),
        border: AppColors.toColor(AppColors.lightSidebarBorder),
        ring: AppColors.toColor(AppColors.lightSidebarRing),
      );

  /// Get sidebar colors for dark mode
  static SidebarColors get darkColors => SidebarColors(
        background: AppColors.toColor(AppColors.darkSidebarBackground),
        foreground: AppColors.toColor(AppColors.darkSidebarForeground),
        primary: AppColors.toColor(AppColors.darkSidebarPrimary),
        primaryForeground:
            AppColors.toColor(AppColors.darkSidebarPrimaryForeground),
        accent: AppColors.toColor(AppColors.darkSidebarAccent),
        accentForeground:
            AppColors.toColor(AppColors.darkSidebarAccentForeground),
        border: AppColors.toColor(AppColors.darkSidebarBorder),
        ring: AppColors.toColor(AppColors.darkSidebarRing),
      );
}

/// Sidebar color values
class SidebarColors {
  final Color background;
  final Color foreground;
  final Color primary;
  final Color primaryForeground;
  final Color accent;
  final Color accentForeground;
  final Color border;
  final Color ring;

  const SidebarColors({
    required this.background,
    required this.foreground,
    required this.primary,
    required this.primaryForeground,
    required this.accent,
    required this.accentForeground,
    required this.border,
    required this.ring,
  });
}
