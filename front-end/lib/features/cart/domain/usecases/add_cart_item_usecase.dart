import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class AddCartItemUseCase extends UseCase<CartItemEntity, AddCartItemParams> {
  final CartRepository repository;
  AddCartItemUseCase(this.repository);

  @override
  Future<Either<Failure, CartItemEntity>> call(AddCartItemParams params) =>
      repository.addItem(
          productId: params.productId, quantity: params.quantity);
}

class AddCartItemParams extends Equatable {
  final String productId;
  final int quantity;
  const AddCartItemParams({required this.productId, this.quantity = 1});
  @override
  List<Object?> get props => [productId, quantity];
}
