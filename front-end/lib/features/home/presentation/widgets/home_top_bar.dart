import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class HomeTopBar extends StatelessWidget {
  final Color primaryColor;
  final Color accentColor;
  final Color cardColor;

  const HomeTopBar(
      {super.key,
      required this.primaryColor,
      required this.accentColor,
      required this.cardColor});

  void _handleSignOut(BuildContext context) {
    context.read<AuthBloc>().add(const LogoutEvent());
    AppNavigator.toLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final user = authState is AuthAuthenticated ? authState.user : null;
        final displayName = user?.fullName ?? user?.username ?? 'User';
        final initials =
            displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
          child: Row(
            children: [
              // greeting
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Good morning',
                        style: TextStyle(
                            color: primaryColor.withOpacity(0.7),
                            fontSize: 12)),
                    Text('Find your pharmacy',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              // notifications
              Stack(children: [
                IconButton(
                  icon: Icon(Icons.notifications_outlined,
                      color: Theme.of(context).colorScheme.onSurface),
                  onPressed: () {},
                ),
                Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            color: accentColor, shape: BoxShape.circle))),
              ]),
              // avatar / profile menu
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
                  PopupMenuItem(
                      enabled: false,
                      child: Text(displayName,
                          style: const TextStyle(fontWeight: FontWeight.w600))),
                  if (user?.email != null)
                    PopupMenuItem(
                        enabled: false,
                        child: Text(user!.email,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade500))),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                      value: _Action.profile, child: Text('My profile')),
                  const PopupMenuItem(
                      value: _Action.settings, child: Text('Settings')),
                  const PopupMenuItem(
                      value: _Action.signOut, child: Text('Sign out')),
                ],
                child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                        color: primaryColor, shape: BoxShape.circle),
                    child: Center(
                        child: Text(initials,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)))),
              ),
            ],
          ),
        );
      },
    );
  }
}

enum _Action { profile, settings, signOut }
