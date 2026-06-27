import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary: purple HSL(262,83%,58%) | Secondary: cyan HSL(198,93%,60%) | Accent: pink HSL(340,82%,62%)

  // Light mode
  static const HSLColor lightBackground = HSLColor.fromAHSL(1.0, 220, 0.25, 0.97);
  static const HSLColor lightForeground = HSLColor.fromAHSL(1.0, 240, 0.20, 0.10);
  static const HSLColor lightCard = HSLColor.fromAHSL(1.0, 0, 0, 1.0);
  static const HSLColor lightCardForeground = HSLColor.fromAHSL(1.0, 240, 0.20, 0.10);
  static const HSLColor lightPrimary = HSLColor.fromAHSL(1.0, 156, 0.72, 0.40);
  static const HSLColor lightPrimaryForeground = HSLColor.fromAHSL(1.0, 0, 0, 1.0);
  static const HSLColor lightSecondary = HSLColor.fromAHSL(1.0, 207, 0.85, 0.52);
  static const HSLColor lightSecondaryForeground = HSLColor.fromAHSL(1.0, 0, 0, 1.0);
  static const HSLColor lightAccent = HSLColor.fromAHSL(1.0, 14, 0.90, 0.60);
  static const HSLColor lightAccentForeground = HSLColor.fromAHSL(1.0, 0, 0, 1.0);
  static const HSLColor lightMuted = HSLColor.fromAHSL(1.0, 220, 0.15, 0.92);
  static const HSLColor lightMutedForeground = HSLColor.fromAHSL(1.0, 220, 0.10, 0.45);
  static const HSLColor lightDestructive = HSLColor.fromAHSL(1.0, 0, 0.84, 0.60);
  static const HSLColor lightDestructiveForeground = HSLColor.fromAHSL(1.0, 0, 0, 1.0);
  static const HSLColor lightBorder = HSLColor.fromAHSL(1.0, 220, 0.15, 0.88);
  static const HSLColor lightInput = HSLColor.fromAHSL(1.0, 220, 0.15, 0.88);
  static const HSLColor lightRing = HSLColor.fromAHSL(1.0, 156, 0.72, 0.40);

  // Dark mode
  static const HSLColor darkBackground = HSLColor.fromAHSL(1.0, 240, 0.15, 0.08);
  static const HSLColor darkForeground = HSLColor.fromAHSL(1.0, 240, 0.10, 0.95);
  static const HSLColor darkCard = HSLColor.fromAHSL(1.0, 240, 0.12, 0.12);
  static const HSLColor darkCardForeground = HSLColor.fromAHSL(1.0, 240, 0.10, 0.95);
  static const HSLColor darkPrimary = HSLColor.fromAHSL(1.0, 156, 0.72, 0.48);
  static const HSLColor darkPrimaryForeground = HSLColor.fromAHSL(1.0, 0, 0, 1.0);
  static const HSLColor darkSecondary = HSLColor.fromAHSL(1.0, 207, 0.85, 0.58);
  static const HSLColor darkSecondaryForeground = HSLColor.fromAHSL(1.0, 0, 0, 1.0);
  static const HSLColor darkAccent = HSLColor.fromAHSL(1.0, 14, 0.90, 0.64);
  static const HSLColor darkAccentForeground = HSLColor.fromAHSL(1.0, 0, 0, 1.0);
  static const HSLColor darkMuted = HSLColor.fromAHSL(1.0, 240, 0.10, 0.18);
  static const HSLColor darkMutedForeground = HSLColor.fromAHSL(1.0, 240, 0.08, 0.60);
  static const HSLColor darkDestructive = HSLColor.fromAHSL(1.0, 0, 0.84, 0.60);
  static const HSLColor darkDestructiveForeground = HSLColor.fromAHSL(1.0, 240, 0.10, 0.95);
  static const HSLColor darkBorder = HSLColor.fromAHSL(1.0, 240, 0.10, 0.20);
  static const HSLColor darkInput = HSLColor.fromAHSL(1.0, 240, 0.10, 0.20);
  static const HSLColor darkRing = HSLColor.fromAHSL(1.0, 156, 0.72, 0.48);

  static Color toColor(HSLColor hsl) => hsl.toColor();
  static Color primary(bool dark) => toColor(dark ? darkPrimary : lightPrimary);
  static Color secondary(bool dark) => toColor(dark ? darkSecondary : lightSecondary);
  static Color accent(bool dark) => toColor(dark ? darkAccent : lightAccent);
  static Color background(bool dark) => toColor(dark ? darkBackground : lightBackground);
  static Color card(bool dark) => toColor(dark ? darkCard : lightCard);
  static Color fg(bool dark) => toColor(dark ? darkForeground : lightForeground);
  static Color muted(bool dark) => toColor(dark ? darkMutedForeground : lightMutedForeground);
  static Color border(bool dark) => toColor(dark ? darkBorder : lightBorder);

  static ColorScheme get lightColorScheme => ColorScheme.light(
        primary: toColor(lightPrimary),
        onPrimary: toColor(lightPrimaryForeground),
        secondary: toColor(lightSecondary),
        onSecondary: toColor(lightSecondaryForeground),
        tertiary: toColor(lightAccent),
        error: toColor(lightDestructive),
        onError: toColor(lightDestructiveForeground),
        surface: toColor(lightCard),
        onSurface: toColor(lightCardForeground),
        surfaceContainerHighest: toColor(lightMuted),
        onSurfaceVariant: toColor(lightMutedForeground),
        outline: toColor(lightBorder),
      );

  static ColorScheme get darkColorScheme => ColorScheme.dark(
        primary: toColor(darkPrimary),
        onPrimary: toColor(darkPrimaryForeground),
        secondary: toColor(darkSecondary),
        onSecondary: toColor(darkSecondaryForeground),
        tertiary: toColor(darkAccent),
        error: toColor(darkDestructive),
        onError: toColor(darkDestructiveForeground),
        surface: toColor(darkCard),
        onSurface: toColor(darkCardForeground),
        surfaceContainerHighest: toColor(darkMuted),
        onSurfaceVariant: toColor(darkMutedForeground),
        outline: toColor(darkBorder),
      );
}
