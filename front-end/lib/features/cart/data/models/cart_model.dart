import '../../domain/entities/cart_entity.dart';
import 'cart_item_model.dart';

class CartModel extends CartEntity {
  const CartModel({
    required super.id,
    required super.userId,
    required super.items,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    // Backend may return items under 'items' or 'cart_items'
    final rawItems =
        (json['items'] ?? json['cart_items']) as List<dynamic>? ?? [];
    final items = rawItems
        .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return CartModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      items: items,
    );
  }
}
