import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<Either<Failure, OrderEntity>> createOrder({
    required List<OrderItemEntity> items,
    required double total,
    required String address,
  });
  Future<Either<Failure, OrderEntity>> getOrderStatus(String orderId);
}
