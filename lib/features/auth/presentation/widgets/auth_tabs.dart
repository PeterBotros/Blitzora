import 'package:flutter/material.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class AuthTabs extends StatelessWidget {
  final bool isSignIn;
  final VoidCallback onToggle;

  const AuthTabs({
    super.key,
    required this.isSignIn,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.toColor(AppColors.darkMuted)
            : AppColors.toColor(AppColors.lightMuted),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      ),
      child: Row(
        children: [
          Expanded(
            child: _AuthTab(
              label: 'Sign In',
              isActive: isSignIn,
              onTap: isSignIn ? null : onToggle,
            ),
          ),
          Expanded(
            child: _AuthTab(
              label: 'Sign Up',
              isActive: !isSignIn,
              onTap: !isSignIn ? null : onToggle,
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _AuthTab({
    required this.label,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isActive
              ? (isDark
                  ? AppColors.toColor(AppColors.darkCard)
                  : AppColors.toColor(AppColors.lightCard))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isDark
                    ? AppColors.toColor(AppColors.darkForeground)
                    : AppColors.toColor(AppColors.lightForeground),
              ),
        ),
      ),
    );
  }
}
