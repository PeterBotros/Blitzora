import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Main app wrapper that provides theme and navigation
class AppWrapper extends StatelessWidget {
  final Widget child;

  const AppWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blitzora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      onGenerateRoute: (settings) {
        // This will be handled by AppRouter if using named routes
        // For now, return the child directly
        return MaterialPageRoute(
          builder: (context) => child,
          settings: settings,
        );
      },
      builder: (context, child) {
        return MediaQuery(
          // Ensure consistent text scaling
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.of(context).textScaler.clamp(
                  minScaleFactor: 0.8,
                  maxScaleFactor: 1.2,
                ),
          ),
          child: child!,
        );
      },
    );
  }
}
