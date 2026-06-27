import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cart_entity.dart';
import '../entities/cart_item_entity.dart';

abstract class CartRepository {
  Future<Either<Failure, CartEntity>> getCart();
  Future<Either<Failure, CartItemEntity>> addItem({
    required String productId,
    required int quantity,
  });
  Future<Either<Failure, CartItemEntity>> updateItem({
    required String itemId,
    required int quantity,
  });
  Future<Either<Failure, void>> removeItem(String itemId);
}
