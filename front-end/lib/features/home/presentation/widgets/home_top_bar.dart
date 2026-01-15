import 'package:flutter/material.dart';
import '../../../../core/navigation/app_navigator.dart';

class HomeTopBar extends StatelessWidget {
  final Color primaryColor;
  final Color accentColor;
  final Color cardColor;

  const HomeTopBar({
    super.key,
    required this.primaryColor,
    required this.accentColor,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Map shortcut button
          InkWell(
            onTap: () {
              AppNavigator.toMapScreen(context);
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.map_outlined,
                color: primaryColor,
                size: 26,
              ),
            ),
          ),
          // Right side icons
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined,
                    color: Colors.white),
                onPressed: () {},
              ),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined,
                        color: Colors.white),
                    onPressed: () {},
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              PopupMenuButton<_ProfileMenuAction>(
                offset: const Offset(0, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) {
                  switch (value) {
                    case _ProfileMenuAction.myProfile:
                      AppNavigator.toProfile(context);
                      break;
                    case _ProfileMenuAction.settings:
                      // TODO: Navigate to settings when implemented
                      break;
                    case _ProfileMenuAction.signOut:
                      // TODO: Handle sign out
                      break;
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem<_ProfileMenuAction>(
                    enabled: false,
                    child: Text(
                      'pepobemen504gmail.com',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem<_ProfileMenuAction>(
                    value: _ProfileMenuAction.myProfile,
                    child: Text('My Profile'),
                  ),
                  PopupMenuItem<_ProfileMenuAction>(
                    value: _ProfileMenuAction.settings,
                    child: Text('Settings'),
                  ),
                  PopupMenuItem<_ProfileMenuAction>(
                    value: _ProfileMenuAction.signOut,
                    child: Text('Sign Out'),
                  ),
                ],
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'P',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _ProfileMenuAction { myProfile, settings, signOut }
