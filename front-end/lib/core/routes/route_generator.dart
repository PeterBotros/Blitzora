import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_routes.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/chatbot/presentation/pages/chatbot_page.dart';
import '../../core/wrapper/main_wrapper.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/products/presentation/pages/favorites_page.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../features/home/presentation/pages/prescription_upload_page.dart';
import '../../features/home/presentation/pages/pill_reminder_page.dart';
import '../../features/home/presentation/pages/track_order_page.dart';
import '../../features/home/presentation/pages/notifications_page.dart';
import '../../features/home/presentation/bloc/notification_bloc.dart';
import '../../features/home/presentation/bloc/notification_event.dart';
import '../../injection/injection_container.dart' as di;

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.auth:
        return _fade(const AuthPage());
      case AppRoutes.login:
        return _fade(const SignInPage());
      case AppRoutes.signup:
        return _fade(const SignUpPage());
      case AppRoutes.home:
        return _fade(const MainWrapper());
      case AppRoutes.mapScreen:
        return _slide(const MapScreenPage());
      case AppRoutes.profile:
        return _slide(const ProfilePage());
      case AppRoutes.chatbot:
        return _slide(const ChatbotPage());
      case AppRoutes.settings:
        return _slide(const SettingsPage());
      case AppRoutes.cart:
        return _fade(const CartPage());
      case AppRoutes.favorites:
        return _slide(const FavoritesPage());
      case AppRoutes.prescriptionUpload:
        return _slide(const PrescriptionUploadPage());
      case AppRoutes.pillReminder:
        return _slide(const PillReminderPage());
      case AppRoutes.trackOrder:
        final trackArgs = settings.arguments as Map<String, String?>?;
        return _slide(TrackOrderPage(orderId: trackArgs?['orderId']));
      case AppRoutes.notifications:
        return _slide(BlocProvider(
          create: (_) => di.sl<NotificationBloc>()..add(const LoadNotificationsEvent()),
          child: const NotificationsPage(),
        ));
      // AppRoutes.products is intentionally removed:
      // Products are embedded inside MainWrapper's IndexedStack.
      // Use MainWrapper.goToCategory() or selectTab(2) to navigate there.
      default:
        return _fade(const SignInPage());
    }
  }

  static PageRouteBuilder _fade(Widget page) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 250),
      );

  static PageRouteBuilder _slide(Widget page) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0), end: Offset.zero)
              .animate(
                  CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 300),
      );
}
