import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/route_generator.dart';
import 'core/routes/app_routes.dart';

void main() {
  runApp(const BlitzoraApp());
}

class BlitzoraApp extends StatelessWidget {
  const BlitzoraApp({super.key});

  /// Dynamic theme mode switcher
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          title: 'Blitzora',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,
          initialRoute: AppRoutes.login,
          onGenerateRoute: RouteGenerator.generateRoute,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: MediaQuery.of(context)
                    .textScaler
                    .clamp(minScaleFactor: 0.8, maxScaleFactor: 1.2),
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}
