import 'package:flutter/material.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/auth_logo.dart';
import '../widgets/sign_in_form.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.toColor(AppColors.darkBackground),
                    AppColors.toColor(AppColors.darkBackground),
                  ],
                )
              : null,
          color: isDark ? null : AppColors.toColor(AppColors.lightBackground),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.toColor(AppColors.darkCard)
                      : AppColors.toColor(AppColors.lightCard),
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                  border: Border.all(
                    color: isDark
                        ? AppColors.toColor(AppColors.darkBorder)
                        : AppColors.toColor(AppColors.lightBorder),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AuthLogo(),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome Back',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.toColor(AppColors.darkForeground)
                                : AppColors.toColor(AppColors.lightForeground),
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? AppColors.toColor(
                                    AppColors.darkMutedForeground)
                                : AppColors.toColor(
                                    AppColors.lightMutedForeground),
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    const SignInForm(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
