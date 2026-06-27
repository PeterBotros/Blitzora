import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String id;
  final String cartId;
  final String productId;
  final int quantity;
  final String? productName;
  final double? productPrice;
  final String? productImageUrl;
  final String? productDescription;

  const CartItemEntity({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.quantity,
    this.productName,
    this.productPrice,
    this.productImageUrl,
    this.productDescription,
  });

  @override
  List<Object?> get props => [id, cartId, productId, quantity];
}
