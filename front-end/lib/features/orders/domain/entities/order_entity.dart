import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String id;
  final List<OrderItemEntity> items;
  final double total;
  final String status; // "confirmed", "preparing", "on_the_way", "delivered"
  final String address;
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.items,
    required this.total,
    required this.status,
    required this.address,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, items, total, status, address, createdAt];
}

class OrderItemEntity extends Equatable {
  final String productId;
  final String productName;
  final int quantity;
  final double price;

  const OrderItemEntity({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  @override
  List<Object?> get props => [productId, productName, quantity, price];
}
