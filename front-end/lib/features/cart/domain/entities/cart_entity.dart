import 'package:equatable/equatable.dart';
import 'cart_item_entity.dart';

class CartEntity extends Equatable {
  final String id;
  final String userId;
  final List<CartItemEntity> items;

  const CartEntity({
    required this.id,
    required this.userId,
    required this.items,
  });

  double get subtotal =>
      items.fold(0.0, (s, i) => s + ((i.productPrice ?? 0) * i.quantity));

  double get deliveryFee => items.isEmpty ? 0.0 : 15.0;
  double get tax => items.isEmpty ? 0.0 : 5.0;
  double get total => subtotal + deliveryFee + tax;

  @override
  List<Object?> get props => [id, userId, items];
}
