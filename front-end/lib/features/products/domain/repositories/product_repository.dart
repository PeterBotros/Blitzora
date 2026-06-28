import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    String? categoryId,
    String? search,
    int skip,
    int limit,
  });
  Future<Either<Failure, ProductEntity>> getProductById(String id);
}
