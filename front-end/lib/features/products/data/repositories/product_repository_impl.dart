import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remote;
  ProductRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts(
      {String? categoryId,
      String? search,
      int skip = 0,
      int limit = 20}) async {
    try {
      final result = await _remote.getProducts(
          categoryId: categoryId, search: search, skip: skip, limit: limit);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(String id) async {
    try {
      return Right(await _remote.getProductById(id));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
