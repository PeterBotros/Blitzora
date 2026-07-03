import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, OrderEntity>> createOrder({
    required List<OrderItemEntity> items,
    required double total,
    required String address,
  }) async {
    try {
      final orderItems = items.map((e) => OrderItemModel(
        productId: e.productId,
        productName: e.productName,
        quantity: e.quantity,
        price: e.price,
      )).toList();

      final result = await remoteDataSource.createOrder(
        items: orderItems,
        total: total,
        address: address,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderStatus(String orderId) async {
    try {
      final result = await remoteDataSource.getOrderStatus(orderId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
