import 'package:flutter/material.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/auth_logo.dart';
import '../widgets/sign_in_form.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg   = AppColors.background(dark);
    final card = AppColors.card(dark);
    final fg   = AppColors.fg(dark);
    final muted = AppColors.muted(dark);
    final border = AppColors.border(dark);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                  border: Border.all(color: border)),
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  const AuthLogo(),
                  const SizedBox(height: 22),
                  Text('Welcome to Blitzora', textAlign: TextAlign.center,
                    style: TextStyle(color: fg, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text('Your trusted medicine delivery partner', textAlign: TextAlign.center,
                    style: TextStyle(color: muted, fontSize: 13)),
                  const SizedBox(height: 28),
                  const SignInForm(),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
