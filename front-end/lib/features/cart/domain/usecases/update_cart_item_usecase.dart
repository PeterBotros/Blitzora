import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class UpdateCartItemUseCase
    extends UseCase<CartItemEntity, UpdateCartItemParams> {
  final CartRepository repository;
  UpdateCartItemUseCase(this.repository);

  @override
  Future<Either<Failure, CartItemEntity>> call(UpdateCartItemParams params) =>
      repository.updateItem(itemId: params.itemId, quantity: params.quantity);
}

class UpdateCartItemParams extends Equatable {
  final String itemId;
  final int quantity;
  const UpdateCartItemParams(
      {required this.itemId, required this.quantity});
  @override
  List<Object?> get props => [itemId, quantity];
}
