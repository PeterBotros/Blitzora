import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product_entity.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, List<ProductEntity>>> getFavorites();
  Future<Either<Failure, ProductEntity>> addFavorite(String productId);
  Future<Either<Failure, void>> removeFavorite(String productId);
}
