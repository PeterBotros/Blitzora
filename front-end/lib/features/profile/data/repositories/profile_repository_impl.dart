import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final StorageService _storageService;

  ProfileRepositoryImpl(this._remoteDataSource, this._storageService);

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    try {
      return Right(await _remoteDataSource.getProfile());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile({
    String? fullName,
    String? username,
    String? phone,
  }) async {
    try {
      return Right(await _remoteDataSource.updateProfile(
        fullName: fullName,
        username: username,
        phone: phone,
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    await _storageService.clearAll();
    return const Right(null);
  }
}
