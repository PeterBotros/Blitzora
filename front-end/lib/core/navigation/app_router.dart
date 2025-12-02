import 'package:flutter/material.dart';
import '../routes/route_generator.dart';
import '../routes/app_routes.dart';

/// Main router widget that wraps the app navigation
class AppRouter extends StatelessWidget {
  final Widget child;

  const AppRouter({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blitzora',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: AppRoutes.auth,
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
