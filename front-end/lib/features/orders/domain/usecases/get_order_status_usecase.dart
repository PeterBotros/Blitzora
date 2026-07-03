import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class GetOrderStatusUseCase implements UseCase<OrderEntity, String> {
  final OrderRepository repository;

  GetOrderStatusUseCase(this.repository);

  @override
  Future<Either<Failure, OrderEntity>> call(String orderId) async {
    return await repository.getOrderStatus(orderId);
  }
}
