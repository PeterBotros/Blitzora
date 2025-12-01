import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../theme/app_transitions.dart';
import 'app_routes.dart';

/// Route generator for the application
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.auth:
        return _buildRoute(
          const AuthPage(),
          settings: settings,
        );

      case AppRoutes.login:
        return _buildRoute(
          const SignInPage(),
          settings: settings,
        );

      case AppRoutes.signup:
        return _buildRoute(
          const SignUpPage(),
          settings: settings,
        );

      case AppRoutes.home:
        return _buildRoute(
          const HomePage(),
          settings: settings,
        );

      case AppRoutes.profile:
        return _buildRoute(
          const ProfilePage(),
          settings: settings,
        );

      default:
        return _buildRoute(
          _errorPage(settings.name ?? 'Unknown'),
          settings: settings,
        );
    }
  }

  /// Build a route with custom transition
  static PageRoute<dynamic> _buildRoute(
    Widget page, {
    RouteSettings? settings,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return AppTransitions.standard(
            context, animation, secondaryAnimation, child);
      },
      transitionDuration: AppTransitions.duration,
    );
  }

  /// Error page for unknown routes
  static Widget _errorPage(String routeName) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Route "$routeName" not found',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
