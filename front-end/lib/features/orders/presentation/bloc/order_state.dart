import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderCreatedSuccess extends OrderState {
  final OrderEntity order;

  const OrderCreatedSuccess(this.order);

  @override
  List<Object?> get props => [order];
}

class OrderStatusLoaded extends OrderState {
  final OrderEntity order;

  const OrderStatusLoaded(this.order);

  @override
  List<Object?> get props => [order];
}

class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object?> get props => [message];
}
