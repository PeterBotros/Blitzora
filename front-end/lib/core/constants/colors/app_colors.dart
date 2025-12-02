import 'package:flutter/material.dart';

/// Application color system using HSL values
class AppColors {
  AppColors._();

  // ==================== Light Mode Colors ====================
  static const HSLColor lightBackground =
      HSLColor.fromAHSL(1.0, 220, 0.25, 0.97);
  static const HSLColor lightForeground =
      HSLColor.fromAHSL(1.0, 220, 0.20, 0.10);
  static const HSLColor lightCard = HSLColor.fromAHSL(1.0, 0, 0, 1.0);
  static const HSLColor lightCardForeground =
      HSLColor.fromAHSL(1.0, 220, 0.20, 0.10);
  static const HSLColor lightPopover = HSLColor.fromAHSL(1.0, 0, 0, 1.0);
  static const HSLColor lightPopoverForeground =
      HSLColor.fromAHSL(1.0, 220, 0.20, 0.10);
  static const HSLColor lightPrimary =
      HSLColor.fromAHSL(1.0, 262, 0.83, 0.58); // purple
  static const HSLColor lightPrimaryForeground =
      HSLColor.fromAHSL(1.0, 0, 0, 1.0);
  static const HSLColor lightSecondary =
      HSLColor.fromAHSL(1.0, 198, 0.93, 0.60); // cyan/blue
  static const HSLColor lightSecondaryForeground =
      HSLColor.fromAHSL(1.0, 0, 0, 1.0);
  static const HSLColor lightMuted = HSLColor.fromAHSL(1.0, 220, 0.15, 0.92);
  static const HSLColor lightMutedForeground =
      HSLColor.fromAHSL(1.0, 220, 0.10, 0.45);
  static const HSLColor lightAccent =
      HSLColor.fromAHSL(1.0, 340, 0.82, 0.62); // pink
  static const HSLColor lightAccentForeground =
      HSLColor.fromAHSL(1.0, 0, 0, 1.0);
  static const HSLColor lightDestructive =
      HSLColor.fromAHSL(1.0, 0, 0.84, 0.60); // red
  static const HSLColor lightDestructiveForeground =
      HSLColor.fromAHSL(1.0, 0, 0, 1.0);
  static const HSLColor lightBorder = HSLColor.fromAHSL(1.0, 220, 0.15, 0.88);
  static const HSLColor lightInput = HSLColor.fromAHSL(1.0, 220, 0.15, 0.88);
  static const HSLColor lightRing = HSLColor.fromAHSL(1.0, 262, 0.83, 0.58);

  // ==================== Dark Mode Colors ====================
  static const HSLColor darkBackground =
      HSLColor.fromAHSL(1.0, 240, 0.15, 0.08);
  static const HSLColor darkForeground =
      HSLColor.fromAHSL(1.0, 240, 0.10, 0.95);
  static const HSLColor darkCard = HSLColor.fromAHSL(1.0, 240, 0.12, 0.12);
  static const HSLColor darkCardForeground =
      HSLColor.fromAHSL(1.0, 240, 0.10, 0.95);
  static const HSLColor darkPopover = HSLColor.fromAHSL(1.0, 240, 0.12, 0.12);
  static const HSLColor darkPopoverForeground =
      HSLColor.fromAHSL(1.0, 240, 0.10, 0.95);
  static const HSLColor darkPrimary = HSLColor.fromAHSL(1.0, 262, 0.83, 0.65);
  static const HSLColor darkPrimaryForeground =
      HSLColor.fromAHSL(1.0, 0, 0, 1.0);
  static const HSLColor darkSecondary = HSLColor.fromAHSL(1.0, 198, 0.93, 0.65);
  static const HSLColor darkSecondaryForeground =
      HSLColor.fromAHSL(1.0, 0, 0, 1.0);
  static const HSLColor darkMuted = HSLColor.fromAHSL(1.0, 240, 0.10, 0.18);
  static const HSLColor darkMutedForeground =
      HSLColor.fromAHSL(1.0, 240, 0.08, 0.60);
  static const HSLColor darkAccent = HSLColor.fromAHSL(1.0, 340, 0.82, 0.68);
  static const HSLColor darkAccentForeground =
      HSLColor.fromAHSL(1.0, 0, 0, 1.0);
  static const HSLColor darkDestructive =
      HSLColor.fromAHSL(1.0, 0, 0.84, 0.60); // red
  static const HSLColor darkDestructiveForeground =
      HSLColor.fromAHSL(1.0, 240, 0.10, 0.95);
  static const HSLColor darkBorder = HSLColor.fromAHSL(1.0, 240, 0.10, 0.20);
  static const HSLColor darkInput = HSLColor.fromAHSL(1.0, 240, 0.10, 0.20);
  static const HSLColor darkRing = HSLColor.fromAHSL(1.0, 262, 0.83, 0.65);

  // ==================== Sidebar Colors (Light) ====================
  static const HSLColor lightSidebarBackground =
      HSLColor.fromAHSL(1.0, 0, 0, 0.98);
  static const HSLColor lightSidebarForeground =
      HSLColor.fromAHSL(1.0, 240, 0.053, 0.261);
  static const HSLColor lightSidebarPrimary =
      HSLColor.fromAHSL(1.0, 240, 0.059, 0.10);
  static const HSLColor lightSidebarPrimaryForeground =
      HSLColor.fromAHSL(1.0, 0, 0, 0.98);
  static const HSLColor lightSidebarAccent =
      HSLColor.fromAHSL(1.0, 240, 0.048, 0.959);
  static const HSLColor lightSidebarAccentForeground =
      HSLColor.fromAHSL(1.0, 240, 0.059, 0.10);
  static const HSLColor lightSidebarBorder =
      HSLColor.fromAHSL(1.0, 220, 0.13, 0.91);
  static const HSLColor lightSidebarRing =
      HSLColor.fromAHSL(1.0, 217.2, 0.912, 0.598);

  // ==================== Sidebar Colors (Dark) ====================
  static const HSLColor darkSidebarBackground =
      HSLColor.fromAHSL(1.0, 240, 0.059, 0.10);
  static const HSLColor darkSidebarForeground =
      HSLColor.fromAHSL(1.0, 240, 0.048, 0.959);
  static const HSLColor darkSidebarPrimary =
      HSLColor.fromAHSL(1.0, 224.3, 0.763, 0.48);
  static const HSLColor darkSidebarPrimaryForeground =
      HSLColor.fromAHSL(1.0, 0, 0, 1.0);
  static const HSLColor darkSidebarAccent =
      HSLColor.fromAHSL(1.0, 240, 0.037, 0.159);
  static const HSLColor darkSidebarAccentForeground =
      HSLColor.fromAHSL(1.0, 240, 0.048, 0.959);
  static const HSLColor darkSidebarBorder =
      HSLColor.fromAHSL(1.0, 240, 0.037, 0.159);
  static const HSLColor darkSidebarRing =
      HSLColor.fromAHSL(1.0, 217.2, 0.912, 0.598);

  // ==================== Helper Methods ====================
  /// Convert HSLColor to Color
  static Color toColor(HSLColor hsl) => hsl.toColor();

  /// Get light mode color scheme
  static ColorScheme get lightColorScheme => ColorScheme.light(
        primary: toColor(lightPrimary),
        onPrimary: toColor(lightPrimaryForeground),
        secondary: toColor(lightSecondary),
        onSecondary: toColor(lightSecondaryForeground),
        error: toColor(lightDestructive),
        onError: toColor(lightDestructiveForeground),
        surface: toColor(lightCard),
        onSurface: toColor(lightCardForeground),
        surfaceContainerHighest: toColor(lightMuted),
        onSurfaceVariant: toColor(lightMutedForeground),
        outline: toColor(lightBorder),
        outlineVariant: toColor(lightInput),
      );

  /// Get dark mode color scheme
  static ColorScheme get darkColorScheme => ColorScheme.dark(
        primary: toColor(darkPrimary),
        onPrimary: toColor(darkPrimaryForeground),
        secondary: toColor(darkSecondary),
        onSecondary: toColor(darkSecondaryForeground),
        error: toColor(darkDestructive),
        onError: toColor(darkDestructiveForeground),
        surface: toColor(darkCard),
        onSurface: toColor(darkCardForeground),
        surfaceContainerHighest: toColor(darkMuted),
        onSurfaceVariant: toColor(darkMutedForeground),
        outline: toColor(darkBorder),
        outlineVariant: toColor(darkInput),
      );
}
