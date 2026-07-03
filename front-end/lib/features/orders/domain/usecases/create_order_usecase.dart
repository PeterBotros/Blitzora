import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class CreateOrderParams {
  final List<OrderItemEntity> items;
  final double total;
  final String address;

  CreateOrderParams({
    required this.items,
    required this.total,
    required this.address,
  });
}

class CreateOrderUseCase implements UseCase<OrderEntity, CreateOrderParams> {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  @override
  Future<Either<Failure, OrderEntity>> call(CreateOrderParams params) async {
    return await repository.createOrder(
      items: params.items,
      total: params.total,
      address: params.address,
    );
  }
}
