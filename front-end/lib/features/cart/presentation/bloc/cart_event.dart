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
  final String itemId;
  final int quantity;
  const UpdateCartItemEvent({required this.itemId, required this.quantity});
  @override
  List<Object?> get props => [itemId, quantity];
}

class RemoveCartItemEvent extends CartEvent {
  final String itemId;
  const RemoveCartItemEvent(this.itemId);
  @override
  List<Object?> get props => [itemId];
}
