import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../core/constants/app_constants.dart';
import '../core/storage/storage_service.dart';
import '../features/auth/presentation/bloc/example_bloc.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';

/// Service locator instance
final sl = GetIt.instance;

/// Initialize dependency injection
Future<void> init() async {
  //! Features - Auth
  // Bloc
  sl.registerFactory(
    () => ExampleBloc(),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      storageService: sl(),
    ),
  );

  //! Core
  sl.registerLazySingleton(() => Dio(
        BaseOptions(
          baseUrl: AppConstants.baseUrl,
          connectTimeout: AppConstants.connectionTimeout,
          receiveTimeout: AppConstants.receiveTimeout,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ));

  // Storage
  sl.registerLazySingleton<StorageService>(
    () => MemoryStorageService(),
  );
}
