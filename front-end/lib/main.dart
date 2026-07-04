import 'package:blitzora/features/cart/presentation/bloc/cart_event.dart';
import 'package:blitzora/features/profile/presentation/bloc/profile_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'core/theme/app_theme.dart';
import 'core/routes/route_generator.dart';
import 'core/routes/app_routes.dart';
import 'injection/injection_container.dart' as di;

import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'core/services/storage_service.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/home/presentation/bloc/home_event.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/chatbot/presentation/bloc/chatbot_bloc.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/products/presentation/bloc/product_bloc.dart';
import 'features/orders/presentation/bloc/order_bloc.dart';
import 'features/prescription/presentation/bloc/prescription_bloc.dart';
import 'features/products/presentation/bloc/favorite/favorite_bloc.dart';
import 'features/products/presentation/bloc/favorite/favorite_event.dart';
import 'features/home/presentation/bloc/notification_bloc.dart';
import 'features/home/presentation/bloc/notification_event.dart';
import 'features/home/presentation/bloc/reminder_bloc.dart';
import 'features/home/presentation/bloc/reminder_event.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await di.init();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const BlitzoraApp(),
    ),
  );
}

class BlitzoraApp extends StatelessWidget {
  const BlitzoraApp({super.key});

  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.dark);

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = di.sl<di.StorageService>().isLoggedIn;

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) {
            final bloc = di.sl<AuthBloc>();
            if (di.sl<StorageService>().isLoggedIn) {
              bloc.add(const GetCurrentUserEvent());
            }
            return bloc;
          },
        ),
        BlocProvider<HomeBloc>(
          create: (_) => di.sl<HomeBloc>()..add(const LoadHomeEvent()),
        ),
        BlocProvider<CartBloc>(
          create: (_) => di.sl<CartBloc>()..add(const LoadCartEvent()),
        ),
        BlocProvider<ChatbotBloc>(create: (_) => di.sl<ChatbotBloc>()),
        BlocProvider<ProfileBloc>(
          create: (_) => di.sl<ProfileBloc>()..add(const LoadProfileEvent()),
        ),
        BlocProvider<ProductBloc>(create: (_) => di.sl<ProductBloc>()),
        BlocProvider<OrderBloc>(create: (_) => di.sl<OrderBloc>()),
        BlocProvider<PrescriptionBloc>(
            create: (_) => di.sl<PrescriptionBloc>()),
        BlocProvider<FavoriteBloc>(
          create: (_) => di.sl<FavoriteBloc>()..add(const LoadFavoritesEvent()),
        ),
        BlocProvider<NotificationBloc>(
          create: (_) => di.sl<NotificationBloc>()..add(const LoadNotificationsEvent()),
        ),
        BlocProvider<ReminderBloc>(
          create: (_) => di.sl<ReminderBloc>()..add(const LoadRemindersEvent()),
        ),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (context, currentMode, child) => MaterialApp(
          title: 'Blitzora',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.login,
          onGenerateRoute: RouteGenerator.generateRoute,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: MediaQuery.of(context)
                  .textScaler
                  .clamp(minScaleFactor: 0.8, maxScaleFactor: 1.2),
            ),
            child: child!,
          ),
        ),
      ),
    );
  }
}
