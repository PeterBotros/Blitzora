import 'package:flutter/material.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/routes/app_routes.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // TODO: Implement sign up logic
        await Future.delayed(const Duration(seconds: 1)); // Simulate API call

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully!'),
            ),
          );
          // Navigate to home after successful sign up
          AppNavigator.toHome(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Sign up failed: ${e.toString()}'),
              backgroundColor: AppColors.toColor(AppColors.lightDestructive),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _navigateToSignIn() {
    AppNavigator.pushNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Name Field
          Text(
            'Full Name',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isDark
                      ? AppColors.toColor(AppColors.darkForeground)
                      : AppColors.toColor(AppColors.lightForeground),
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            enabled: !_isLoading,
            decoration: InputDecoration(
              hintText: 'John Doe',
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
                    isDark ? AppColors.darkRing : AppColors.lightRing,
                  ),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            style: TextStyle(
              color: isDark
                  ? AppColors.toColor(AppColors.darkForeground)
                  : AppColors.toColor(AppColors.lightForeground),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              if (value.length < 2) {
                return 'Name must be at least 2 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Email Field
          Text(
            'Email',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isDark
                      ? AppColors.toColor(AppColors.darkForeground)
                      : AppColors.toColor(AppColors.lightForeground),
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            enabled: !_isLoading,
            decoration: InputDecoration(
              hintText: 'your@email.com',
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
                    isDark ? AppColors.darkRing : AppColors.lightRing,
                  ),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            style: TextStyle(
              color: isDark
                  ? AppColors.toColor(AppColors.darkForeground)
                  : AppColors.toColor(AppColors.lightForeground),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@') || !value.contains('.')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Password Field
          Text(
            'Password',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isDark
                      ? AppColors.toColor(AppColors.darkForeground)
                      : AppColors.toColor(AppColors.lightForeground),
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
            enabled: !_isLoading,
            decoration: InputDecoration(
              hintText: 'Create a password',
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
                    isDark ? AppColors.darkRing : AppColors.lightRing,
                  ),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: isDark
                      ? AppColors.toColor(AppColors.darkMutedForeground)
                      : AppColors.toColor(AppColors.lightMutedForeground),
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            style: TextStyle(
              color: isDark
                  ? AppColors.toColor(AppColors.darkForeground)
                  : AppColors.toColor(AppColors.lightForeground),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Confirm Password Field
          Text(
            'Confirm Password',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isDark
                      ? AppColors.toColor(AppColors.darkForeground)
                      : AppColors.toColor(AppColors.lightForeground),
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            enabled: !_isLoading,
            onFieldSubmitted: (_) => _handleSignUp(),
            decoration: InputDecoration(
              hintText: 'Confirm your password',
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
                    isDark ? AppColors.darkRing : AppColors.lightRing,
                  ),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: isDark
                      ? AppColors.toColor(AppColors.darkMutedForeground)
                      : AppColors.toColor(AppColors.lightMutedForeground),
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
            style: TextStyle(
              color: isDark
                  ? AppColors.toColor(AppColors.darkForeground)
                  : AppColors.toColor(AppColors.lightForeground),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),

          // Sign Up Button
          ElevatedButton(
            onPressed: _isLoading ? null : _handleSignUp,
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
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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
                          : AppColors.toColor(AppColors.lightMutedForeground),
                    ),
              ),
              TextButton(
                onPressed: _isLoading ? null : _navigateToSignIn,
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.toColor(
                      isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
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
