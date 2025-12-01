import 'package:flutter/material.dart';
import 'injection/injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import 'core/routes/route_generator.dart';
import 'core/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blitzora',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Set to dark to match the design
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login, // Start with auth page
      onGenerateRoute: RouteGenerator.generateRoute,
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
