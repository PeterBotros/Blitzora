import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/example_entity.dart';
import '../../domain/repositories/example_repository.dart';
import '../datasources/example_local_datasource.dart';
import '../datasources/example_remote_datasource.dart';

class ExampleRepositoryImpl implements ExampleRepository {
  final ExampleRemoteDataSource remoteDataSource;
  final ExampleLocalDataSource localDataSource;

  ExampleRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, ExampleEntity>> getExample() async {
    try {
      // Try to get from remote first
      final remoteExample = await remoteDataSource.getExample();
      // Cache it locally
      await localDataSource.cacheExample(remoteExample);
      return Right(remoteExample);
    } on ServerException catch (e) {
      // If remote fails, try local cache
      try {
        final localExample = await localDataSource.getLastExample();
        return Right(localExample);
      } on CacheException {
        return Left(ServerFailure(e.message));
      }
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}


