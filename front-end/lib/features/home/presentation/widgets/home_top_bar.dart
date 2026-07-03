import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../presentation/bloc/notification_bloc.dart';
import '../../presentation/bloc/notification_state.dart';

class HomeTopBar extends StatelessWidget {
  final Color primaryColor;
  final Color accentColor;
  final Color cardColor;

  const HomeTopBar(
      {super.key,
      required this.primaryColor,
      required this.accentColor,
      required this.cardColor});

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'good_morning'.tr();
    if (h < 17) return 'good_afternoon'.tr();
    return 'good_evening'.tr();
  }

  void _handleSignOut(BuildContext context) {
    context.read<AuthBloc>().add(const LogoutEvent());
    AppNavigator.toLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;
        final name = user?.fullName ?? user?.username ?? 'there';
        final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
          child: Row(children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_greeting,
                        style: TextStyle(
                            color: primaryColor.withOpacity(0.7),
                            fontSize: 12)),
                    Text('hello_user'.tr(args: [name]),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ]),
            ),
            BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, notificationState) {
                final unreadCount = notificationState is NotificationsLoaded
                    ? notificationState.unreadCount
                    : 0;
                return Badge(
                  isLabelVisible: unreadCount > 0,
                  label: Text('$unreadCount'),
                  backgroundColor: accentColor,
                  child: IconButton(
                    icon: Icon(Icons.notifications_outlined,
                        color: Theme.of(context).colorScheme.onSurface),
                    onPressed: () {
                      AppNavigator.pushNamed(context, AppRoutes.notifications);
                    },
                  ),
                );
              },
            ),

            // ── Cart icon ───────────────────────────────────────────────────
            BlocBuilder<CartBloc, CartState>(
              builder: (context, cartState) {
                final itemCount =
                    cartState is CartLoaded ? cartState.cart.items.length : 0;
                return Badge(
                  isLabelVisible: itemCount > 0,
                  label: Text('$itemCount'),
                  backgroundColor: accentColor,
                  child: IconButton(
                    icon: Icon(Icons.shopping_cart_outlined,
                        color: Theme.of(context).colorScheme.onSurface),
                    onPressed: () {
                      AppNavigator.pushNamed(context, AppRoutes.cart);
                    },
                  ),
                );
              },
            ),
            SizedBox(
              width: 15,
            ),
            PopupMenuButton<_Action>(
              offset: const Offset(0, 44),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onSelected: (v) {
                if (v == _Action.profile) AppNavigator.toProfile(context);
                if (v == _Action.settings)
                  AppNavigator.pushNamed(context, AppRoutes.settings);
                if (v == _Action.signOut) _handleSignOut(context);
              },
              itemBuilder: (_) => [
                if (user != null) ...[
                  PopupMenuItem(
                      enabled: false,
                      child: Text(name,
                          style: const TextStyle(fontWeight: FontWeight.w600))),
                  if (user.email.isNotEmpty)
                    PopupMenuItem(
                        enabled: false,
                        child: Text(user.email,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade500))),
                  const PopupMenuDivider(),
                ],
                const PopupMenuItem(
                    value: _Action.profile,
                    child: Row(children: [
                      Icon(Icons.person_outline, size: 18),
                      SizedBox(width: 10),
                      Text('My profile')
                    ])),
                const PopupMenuItem(
                    value: _Action.settings,
                    child: Row(children: [
                      Icon(Icons.settings_outlined, size: 18),
                      SizedBox(width: 10),
                      Text('Settings')
                    ])),
                const PopupMenuItem(
                    value: _Action.signOut,
                    child: Row(children: [
                      Icon(Icons.logout, size: 18, color: Colors.red),
                      SizedBox(width: 10),
                      Text('Sign out', style: TextStyle(color: Colors.red))
                    ])),
              ],
              child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                      color: primaryColor, shape: BoxShape.circle),
                  child: Center(
                      child: Text(initial,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)))),
            ),
          ]),
        );
      },
    );
  }
}

enum _Action { profile, settings, signOut }
