import 'package:blitzora/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/api_client.dart';
import '../core/services/storage_service.dart';

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

export '../core/services/storage_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  sl.registerLazySingleton<StorageService>(() => StorageService(sl()));
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));

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
}
