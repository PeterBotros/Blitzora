import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class CreateOrderEvent extends OrderEvent {
  final List<OrderItemEntity> items;
  final double total;
  final String address;

  const CreateOrderEvent({
    required this.items,
    required this.total,
    required this.address,
  });

  @override
  List<Object?> get props => [items, total, address];
}

class GetOrderStatusEvent extends OrderEvent {
  final String orderId;

  const GetOrderStatusEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}
