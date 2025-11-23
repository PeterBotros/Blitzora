# Navigation System

This directory contains the navigation wrapper and routing system for the application.

## Files Overview

- **app_navigator.dart**: Navigation service with convenience methods
- **app_router.dart**: Router widget (alternative approach)
- **../routes/route_generator.dart**: Route generator for named routes
- **../routes/app_routes.dart**: Route name constants
- **../wrapper/app_wrapper.dart**: App wrapper widget

## Usage

### Basic Navigation

```dart
import 'package:blitzora/core/navigation/app_navigator.dart';

// Navigate to a page
AppNavigator.pushNamed(context, AppRoutes.auth);

// Navigate and replace current route
AppNavigator.pushReplacementNamed(context, AppRoutes.home);

// Navigate and clear stack
AppNavigator.pushNamedAndRemoveUntil(context, AppRoutes.home);

// Go back
AppNavigator.pop(context);
```

### Convenience Methods

```dart
// Navigate to Auth page
AppNavigator.toAuth(context);

// Navigate to Home (clears stack)
AppNavigator.toHome(context);

// Navigate to Dashboard
AppNavigator.toDashboard(context);
```

### Adding New Routes

1. **Add route constant** in `app_routes.dart`:
```dart
static const String newPage = '/new-page';
```

2. **Add route handler** in `route_generator.dart`:
```dart
case AppRoutes.newPage:
  return _buildRoute(
    const NewPage(),
    settings: settings,
  );
```

3. **Use in navigation**:
```dart
AppNavigator.pushNamed(context, AppRoutes.newPage);
```

## Route Transitions

The app uses custom transitions defined in `app_transitions.dart`:
- **Standard**: Fade transition (default)
- **Slide Right**: Slide from right
- **Slide Up**: Slide from bottom
- **Scale**: Scale animation

To use a different transition, modify `_buildRoute` in `route_generator.dart`.

## Architecture

The navigation system follows clean architecture principles:
- Routes are centralized in `app_routes.dart`
- Route generation is handled by `route_generator.dart`
- Navigation logic is abstracted in `app_navigator.dart`
- All navigation goes through the wrapper system

