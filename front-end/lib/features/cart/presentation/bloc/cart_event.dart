import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class LoadCartEvent extends CartEvent {
  const LoadCartEvent();
}

class AddCartItemEvent extends CartEvent {
  final String productId;
  final int quantity;
  const AddCartItemEvent({required this.productId, this.quantity = 1});
  @override
  List<Object?> get props => [productId, quantity];
}

class UpdateCartItemEvent extends CartEvent {
  final String productId; // backend PUT /cart/item/{product_id}
  final int quantity;
  const UpdateCartItemEvent({required this.productId, required this.quantity});
  @override
  List<Object?> get props => [productId, quantity];
}

class RemoveCartItemEvent extends CartEvent {
  final String productId; // backend DELETE /cart/item/{product_id}
  const RemoveCartItemEvent(this.productId);
  @override
  List<Object?> get props => [productId];
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}
