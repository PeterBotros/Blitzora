import 'package:flutter/material.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../injection/injection_container.dart' as di;
import '../../domain/repositories/auth_repository.dart';
import '../../data/models/login_request.dart';
import '../../data/models/register_request.dart';
import '../../../../core/errors/exceptions.dart';

class AuthForm extends StatefulWidget {
  final bool isSignIn;

  const AuthForm({super.key, required this.isSignIn});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;
  late final AuthRepository _authRepository;

  @override
  void initState() {
    super.initState();
    _authRepository = di.sl<AuthRepository>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (widget.isSignIn) {
          // Login
          final loginRequest = LoginRequest(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
          await _authRepository.login(loginRequest);
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Sign in successful!'),
                backgroundColor: Colors.green,
              ),
            );
            AppNavigator.toHome(context);
          }
        } else {
          // Register
          final registerRequest = RegisterRequest(
            email: _emailController.text.trim(),
            username: _usernameController.text.trim(),
            password: _passwordController.text,
          );
          await _authRepository.register(registerRequest);
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account created successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            AppNavigator.toHome(context);
          }
        }
      } on ValidationException catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message),
              backgroundColor: AppColors.toColor(AppColors.lightDestructive),
            ),
          );
        }
      } on NetworkException catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Network error: ${e.message}'),
              backgroundColor: AppColors.toColor(AppColors.lightDestructive),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Username Field (only for registration)
          if (!widget.isSignIn) ...[
            Text(
              'Username',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isDark
                        ? AppColors.toColor(AppColors.darkForeground)
                        : AppColors.toColor(AppColors.lightForeground),
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _usernameController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              enabled: !_isLoading,
              decoration: InputDecoration(
                hintText: 'username',
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
                if (!widget.isSignIn) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  if (value.length < 3) {
                    return 'Username must be at least 3 characters';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
          ],

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
              if (!value.contains('@')) {
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
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleSubmit(),
            decoration: InputDecoration(
              hintText: 'Enter your password',
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
              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),

          // Submit Button
          ElevatedButton(
            onPressed: _isLoading ? null : _handleSubmit,
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
                : Text(
                    widget.isSignIn ? 'Sign In' : 'Sign Up',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
