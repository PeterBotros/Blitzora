import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/constants/app_constants.dart';
import '../features/auth/data/datasources/example_local_datasource.dart';
import '../features/auth/data/datasources/example_remote_datasource.dart';
import '../features/auth/data/repositories/example_repository_impl.dart';
import '../features/auth/domain/repositories/example_repository.dart';
import '../features/auth/domain/usecases/get_example.dart';
import '../features/auth/presentation/bloc/example_bloc.dart';

/// Service locator instance
final sl = GetIt.instance;

/// Initialize dependency injection
Future<void> init() async {
  //! Features - Example
  // Bloc
  sl.registerFactory(
    () => ExampleBloc(getExample: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetExample(sl()));

  // Repository
  sl.registerLazySingleton<ExampleRepository>(
    () => ExampleRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ExampleRemoteDataSource>(
    () => ExampleRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<ExampleLocalDataSource>(
    () => ExampleLocalDataSourceImpl(),
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
