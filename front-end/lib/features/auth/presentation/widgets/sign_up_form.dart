import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/routes/app_routes.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _navigateToSignIn() {
    AppNavigator.pushNamed(context, AppRoutes.login);
  }

  void _handleSignUp() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(RegisterEvent(
          email: _emailController.text.trim(),
          username: _usernameController.text.trim(),
          password: _passwordController.text,
          fullName: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
        ));
  }

  InputDecoration _inputDecoration(
      String hint, bool isDark, {Widget? prefix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: isDark
            ? AppColors.toColor(AppColors.darkMutedForeground)
            : AppColors.toColor(AppColors.lightMutedForeground),
      ),
      filled: true,
      fillColor: isDark
          ? AppColors.toColor(AppColors.darkInput)
          : AppColors.toColor(AppColors.lightInput),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        borderSide: BorderSide(
          color: isDark
              ? AppColors.toColor(AppColors.darkBorder)
              : AppColors.toColor(AppColors.lightBorder),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        borderSide: BorderSide(
          color: isDark
              ? AppColors.toColor(AppColors.darkBorder)
              : AppColors.toColor(AppColors.lightBorder),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        borderSide: BorderSide(
          color: AppColors.toColor(
              isDark ? AppColors.darkRing : AppColors.lightRing),
          width: 2,
        ),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      prefixIcon: prefix,
    );
  }

  Widget _label(String text, BuildContext context, bool isDark) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: isDark
                ? AppColors.toColor(AppColors.darkForeground)
                : AppColors.toColor(AppColors.lightForeground),
            fontWeight: FontWeight.w500,
          ),
    );
  }

  TextStyle _inputStyle(bool isDark) => TextStyle(
        color: isDark
            ? AppColors.toColor(AppColors.darkForeground)
            : AppColors.toColor(AppColors.lightForeground),
      );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthRegisterSuccess) {
          AppNavigator.toHome(context);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade700,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Username
              _label('Username', context, isDark),
              const SizedBox(height: 8),
              TextFormField(
                controller: _usernameController,
                textInputAction: TextInputAction.next,
                enabled: !isLoading,
                decoration: _inputDecoration('username', isDark),
                style: _inputStyle(isDark),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please enter your username';
                  if (v.length < 3) return 'Username must be at least 3 characters';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Full name
              _label('Full Name', context, isDark),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                enabled: !isLoading,
                decoration: _inputDecoration('John Doe', isDark),
                style: _inputStyle(isDark),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please enter your name';
                  if (v.length < 2) return 'Name must be at least 2 characters';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Phone
              _label('Phone Number', context, isDark),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                enabled: !isLoading,
                decoration: _inputDecoration('09123456789', isDark),
                style: _inputStyle(isDark),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please enter your phone number';
                  if (v.length < 10) return 'Invalid phone number';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Email
              _label('Email', context, isDark),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                enabled: !isLoading,
                decoration: _inputDecoration('your@email.com', isDark),
                style: _inputStyle(isDark),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please enter your email';
                  if (!v.contains('@') || !v.contains('.')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Password
              _label('Password', context, isDark),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.next,
                enabled: !isLoading,
                decoration: _inputDecoration('Create a password', isDark).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: isDark
                          ? AppColors.toColor(AppColors.darkMutedForeground)
                          : AppColors.toColor(AppColors.lightMutedForeground),
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                style: _inputStyle(isDark),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please enter your password';
                  if (v.length < 8) return 'Password must be at least 8 characters';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Confirm Password
              _label('Confirm Password', context, isDark),
              const SizedBox(height: 8),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                textInputAction: TextInputAction.done,
                enabled: !isLoading,
                onFieldSubmitted: (_) => _handleSignUp(),
                decoration:
                    _inputDecoration('Confirm your password', isDark).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: isDark
                          ? AppColors.toColor(AppColors.darkMutedForeground)
                          : AppColors.toColor(AppColors.lightMutedForeground),
                    ),
                    onPressed: () => setState(() =>
                        _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                ),
                style: _inputStyle(isDark),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please confirm your password';
                  if (v != _passwordController.text) return 'Passwords do not match';
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Sign Up Button
              ElevatedButton(
                onPressed: isLoading ? null : _handleSignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.toColor(
                    isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  ),
                  foregroundColor: AppColors.toColor(
                    isDark
                        ? AppColors.darkPrimaryForeground
                        : AppColors.lightPrimaryForeground,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  elevation: 0,
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
              ),
              const SizedBox(height: 24),

              // Sign In Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppColors.toColor(AppColors.darkMutedForeground)
                              : AppColors
                                  .toColor(AppColors.lightMutedForeground),
                        ),
                  ),
                  TextButton(
                    onPressed: isLoading ? null : _navigateToSignIn,
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.toColor(
                          isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
