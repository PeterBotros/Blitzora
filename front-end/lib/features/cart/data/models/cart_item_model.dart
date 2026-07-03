import '../../domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.cartId,
    required super.productId,
    required super.quantity,
    super.productName,
    super.productPrice,
    super.productImageUrl,
    super.productDescription,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'] as Map<String, dynamic>?;
    return CartItemModel(
      id: json['id'] as String,
      cartId: json['cart_id'] as String,
      productId: json['product_id'] as String,
      quantity: int.tryParse(json['quantity'].toString()) ?? 1,
      productName: product?['name'] as String?,
      productPrice: product != null
          ? num.tryParse(product['price'].toString())?.toDouble()
          : null,
      productImageUrl: product?['image_url'] as String?,
      productDescription: product?['description'] as String?,
    );
  }
}
