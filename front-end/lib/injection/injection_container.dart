import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../core/constants/app_constants.dart';
import '../features/auth/presentation/bloc/example_bloc.dart';

/// Service locator instance
final sl = GetIt.instance;

/// Initialize dependency injection
Future<void> init() async {
  //! Features - Auth
  // Bloc
  sl.registerFactory(
    () => ExampleBloc(),
  );

  //! Core
  sl.registerLazySingleton(() => Dio(
        BaseOptions(
          baseUrl: AppConstants.baseUrl,
          connectTimeout: AppConstants.connectionTimeout,
          receiveTimeout: AppConstants.receiveTimeout,
        ),
      ));
}
