# Color System Documentation

This directory contains the complete color system for the application using HSL values.

## Files Overview

- **app_colors.dart**: Main color definitions (light/dark mode + sidebar colors)
- **app_gradients.dart**: Gradient definitions for both themes
- **app_shadows.dart**: Shadow definitions with purple tints

## Usage Examples

### Using Colors

```dart
import 'package:flutter/material.dart';
import 'package:blitzora/core/colors/app_colors.dart';

// Get a color
Color primaryColor = AppColors.toColor(AppColors.lightPrimary);

// Use in widget
Container(
  color: AppColors.toColor(AppColors.lightBackground),
  child: Text(
    'Hello',
    style: TextStyle(
      color: AppColors.toColor(AppColors.lightForeground),
    ),
  ),
)
```

### Using Gradients

```dart
import 'package:blitzora/core/colors/app_gradients.dart';

Container(
  decoration: BoxDecoration(
    gradient: AppGradients.lightPrimary,
  ),
)
```

### Using Shadows

```dart
import 'package:blitzora/core/colors/app_shadows.dart';

Container(
  decoration: BoxDecoration(
    color: Colors.white,
    boxShadow: AppShadows.lightShadows,
  ),
)
```

### Using Theme Colors

The colors are automatically applied through `AppTheme.lightTheme` and `AppTheme.darkTheme`:

```dart
import 'package:blitzora/core/theme/app_theme.dart';

MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system,
  // ...
)
```

### Accessing Theme Colors in Widgets

```dart
// Using Theme.of(context)
Container(
  color: Theme.of(context).colorScheme.primary,
  child: Text(
    'Text',
    style: TextStyle(
      color: Theme.of(context).colorScheme.onPrimary,
    ),
  ),
)
```

## Color Palette

### Light Mode
- **Primary**: Purple (HSL: 262 83% 58%)
- **Secondary**: Cyan/Blue (HSL: 198 93% 60%)
- **Accent**: Pink (HSL: 340 82% 62%)
- **Destructive**: Red (HSL: 0 84% 60%)

### Dark Mode
- **Primary**: Purple (HSL: 262 83% 65%)
- **Secondary**: Cyan/Blue (HSL: 198 93% 65%)
- **Accent**: Pink (HSL: 340 82% 68%)
- **Destructive**: Red (HSL: 0 84% 60%)

## Design Tokens

### Border Radius
- **radius**: 16px (1rem)
- **radiusMd**: 14px (radius - 2px)
- **radiusSm**: 12px (radius - 4px)

### Transitions
- **Duration**: 300ms
- **Curve**: cubic-bezier(0.4, 0, 0.2, 1)

Available in `AppTheme.radius`, `AppTheme.radiusMd`, `AppTheme.radiusSm`

