import 'package:blitzora/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/api_client.dart';
import '../core/services/storage_service.dart';
import '../core/services/notification_service.dart';
import '../features/home/data/datasources/reminder_local_datasource.dart';
import '../features/home/data/datasources/reminder_remote_datasource.dart';
import '../features/home/data/repositories/reminder_repository_impl.dart';
import '../features/home/domain/repositories/reminder_repository.dart';
import '../features/home/presentation/bloc/reminder_bloc.dart';

import '../features/auth/data/datasources/auth_remote_datasource.dart';

import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/register_usecase.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';

import '../features/home/data/datasources/home_remote_datasource.dart';
import '../features/home/data/repositories/home_repository_impl.dart';
import '../features/home/domain/repositories/home_repository.dart';
import '../features/home/domain/usecases/get_categories_usecase.dart';
import '../features/home/domain/usecases/get_offers_usecase.dart';
import '../features/home/domain/usecases/get_pharmacies_usecase.dart';
import '../features/home/presentation/bloc/home_bloc.dart';

import '../features/products/data/datasources/product_remote_datasource.dart';
import '../features/products/data/repositories/product_repository_impl.dart';
import '../features/products/domain/repositories/product_repository.dart';
import '../features/products/domain/usecases/get_products_usecase.dart';
import '../features/products/presentation/bloc/product_bloc.dart';

import '../features/cart/data/datasources/cart_remote_datasource.dart';
import '../features/cart/data/repositories/cart_repository_impl.dart';
import '../features/cart/domain/repositories/cart_repository.dart';
import '../features/cart/domain/usecases/add_cart_item_usecase.dart';
import '../features/cart/domain/usecases/get_cart_usecase.dart';
import '../features/cart/domain/usecases/remove_cart_item_usecase.dart';
import '../features/cart/domain/usecases/update_cart_item_usecase.dart';
import '../features/cart/presentation/bloc/cart_bloc.dart';

import '../features/chatbot/data/datasources/chatbot_remote_datasource.dart';
import '../features/chatbot/data/repositories/chatbot_repository_impl.dart';
import '../features/chatbot/domain/repositories/chatbot_repository.dart';
import '../features/chatbot/domain/usecases/send_message_usecase.dart';
import '../features/chatbot/presentation/bloc/chatbot_bloc.dart';

import '../features/profile/data/datasources/profile_remote_datasource.dart';
import '../features/profile/data/repositories/profile_repository_impl.dart';
import '../features/profile/domain/repositories/profile_repository.dart';
import '../features/profile/domain/usecases/get_profile_usecase.dart';
import '../features/profile/domain/usecases/update_profile_usecase.dart';
import '../features/profile/presentation/bloc/profile_bloc.dart';

import '../features/orders/data/datasources/order_remote_datasource.dart';
import '../features/orders/data/repositories/order_repository_impl.dart';
import '../features/orders/domain/repositories/order_repository.dart';
import '../features/orders/domain/usecases/create_order_usecase.dart';
import '../features/orders/domain/usecases/get_order_status_usecase.dart';
import '../features/orders/presentation/bloc/order_bloc.dart';

import '../features/prescription/data/datasources/prescription_remote_datasource.dart';
import '../features/prescription/data/repositories/prescription_repository_impl.dart';
import '../features/prescription/domain/repositories/prescription_repository.dart';
import '../features/prescription/domain/usecases/upload_prescription_usecase.dart';
import '../features/prescription/presentation/bloc/prescription_bloc.dart';

// Favorites
import '../features/products/data/datasources/favorite_remote_datasource.dart';
import '../features/products/data/repositories/favorite_repository_impl.dart';
import '../features/products/domain/repositories/favorite_repository.dart';
import '../features/products/presentation/bloc/favorite/favorite_bloc.dart';

// Notifications
import '../features/home/data/datasources/notification_remote_datasource.dart';
import '../features/home/data/repositories/notification_repository_impl.dart';
import '../features/home/domain/repositories/notification_repository.dart';
import '../features/home/presentation/bloc/notification_bloc.dart';

export '../core/services/storage_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  sl.registerLazySingleton<StorageService>(() => StorageService(sl()));
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));

  // Reminders
  sl.registerLazySingleton<ReminderLocalDataSource>(
      () => ReminderLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<ReminderRemoteDataSource>(
      () => ReminderRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ReminderRepository>(
      () => ReminderRepositoryImpl(sl()));
  sl.registerFactory(
      () => ReminderBloc(sl(), sl()));

  final notificationService = NotificationService();
  await notificationService.init();
  sl.registerLazySingleton<NotificationService>(() => notificationService);

  // Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl(), sl()));
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerFactory(() => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      getCurrentUserUseCase: sl(),
      authRepository: sl()));

  // Home
  sl.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetPharmaciesUseCase(sl()));
  sl.registerLazySingleton(() => GetOffersUseCase(sl()));
  sl.registerFactory(() => HomeBloc(
      getCategoriesUseCase: sl(),
      getPharmaciesUseCase: sl(),
      getOffersUseCase: sl()));

  // Products
  sl.registerLazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerFactory(() => ProductBloc(getProductsUseCase: sl()));

  // Cart
  sl.registerLazySingleton<CartRemoteDataSource>(
      () => CartRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetCartUseCase(sl()));
  sl.registerLazySingleton(() => AddCartItemUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCartItemUseCase(sl()));
  sl.registerLazySingleton(() => RemoveCartItemUseCase(sl()));
  sl.registerFactory(() => CartBloc(
      getCartUseCase: sl(),
      addCartItemUseCase: sl(),
      updateCartItemUseCase: sl(),
      removeCartItemUseCase: sl()));

  // Chatbot
  sl.registerLazySingleton<ChatbotRemoteDataSource>(
      () => ChatbotRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ChatbotRepository>(
      () => ChatbotRepositoryImpl(sl()));
  sl.registerLazySingleton(() => SendMessageUseCase(sl()));
  sl.registerFactory(() => ChatbotBloc(sendMessageUseCase: sl()));

  // Profile
  sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerFactory(() => ProfileBloc(
      getProfileUseCase: sl(),
      updateProfileUseCase: sl(),
      profileRepository: sl()));

  // Orders
  sl.registerLazySingleton<OrderRemoteDataSource>(() => OrderRemoteDataSourceImpl());
  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(sl()));
  sl.registerLazySingleton(() => CreateOrderUseCase(sl()));
  sl.registerLazySingleton(() => GetOrderStatusUseCase(sl()));
  sl.registerFactory(() => OrderBloc(
      createOrderUseCase: sl(),
      getOrderStatusUseCase: sl()));

  // Prescription
  sl.registerLazySingleton<PrescriptionRemoteDataSource>(() => PrescriptionRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<PrescriptionRepository>(() => PrescriptionRepositoryImpl(sl()));
  sl.registerLazySingleton(() => UploadPrescriptionUseCase(sl()));
  sl.registerFactory(() => PrescriptionBloc(uploadPrescriptionUseCase: sl()));

  // Favorites
  sl.registerLazySingleton<FavoriteRemoteDataSource>(
      () => FavoriteRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<FavoriteRepository>(
      () => FavoriteRepositoryImpl(sl()));
  sl.registerFactory(() => FavoriteBloc(
      favoriteRepository: sl(),
      profileBloc: sl()));

  // Notifications
  sl.registerLazySingleton<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(sl()));
  sl.registerFactory(() => NotificationBloc(sl(), sl()));
}

