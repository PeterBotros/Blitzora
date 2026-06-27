import 'package:flutter/material.dart';
import '../constants/colors/app_colors.dart';

class AppTheme {
  AppTheme._();

  static const double radius = 16.0;
  static const double radiusMd = 14.0;
  static const double radiusSm = 12.0;

  static ThemeData get lightTheme {
    final cs = AppColors.lightColorScheme;
    return _base(cs, Brightness.light,
        bg: AppColors.toColor(AppColors.lightBackground),
        card: AppColors.toColor(AppColors.lightCard),
        border: AppColors.toColor(AppColors.lightBorder),
        input: AppColors.toColor(AppColors.lightInput),
        ring: AppColors.toColor(AppColors.lightRing),
        fg: AppColors.toColor(AppColors.lightForeground),
        muted: AppColors.toColor(AppColors.lightMutedForeground));
  }

  static ThemeData get darkTheme {
    final cs = AppColors.darkColorScheme;
    return _base(cs, Brightness.dark,
        bg: AppColors.toColor(AppColors.darkBackground),
        card: AppColors.toColor(AppColors.darkCard),
        border: AppColors.toColor(AppColors.darkBorder),
        input: AppColors.toColor(AppColors.darkInput),
        ring: AppColors.toColor(AppColors.darkRing),
        fg: AppColors.toColor(AppColors.darkForeground),
        muted: AppColors.toColor(AppColors.darkMutedForeground));
  }

  static ThemeData _base(
    ColorScheme cs,
    Brightness brightness, {
    required Color bg,
    required Color card,
    required Color border,
    required Color input,
    required Color ring,
    required Color fg,
    required Color muted,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: bg,
        foregroundColor: fg,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: card,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: input,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: BorderSide(color: ring, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: BorderSide(color: cs.error),
        ),
        hintStyle: TextStyle(color: muted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSm)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: fg,
          side: BorderSide(color: border),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSm)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: cs.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSm)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.toColor(
          brightness == Brightness.dark ? AppColors.darkMuted : AppColors.lightMuted,
        ),
        labelStyle: TextStyle(color: muted),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          side: BorderSide(color: border),
        ),
      ),
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),
      dialogTheme: DialogThemeData(
        backgroundColor: card,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: card,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: card,
        indicatorColor: cs.primary.withOpacity(0.15),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: cs.primary, size: 24);
          }
          return IconThemeData(color: muted, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: cs.primary);
          }
          return TextStyle(fontSize: 11, color: muted);
        }),
      ),
    );
  }
}
