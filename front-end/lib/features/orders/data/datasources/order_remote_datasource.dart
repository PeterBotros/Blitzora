import '../../../../core/errors/exceptions.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderModel> createOrder({
    required List<OrderItemModel> items,
    required double total,
    required String address,
  });
  Future<OrderModel> getOrderStatus(String orderId);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  // In-memory simulated database for orders on the "server"
  static final Map<String, OrderModel> _simulatedServerOrders = {};

  @override
  Future<OrderModel> createOrder({
    required List<OrderItemModel> items,
    required double total,
    required String address,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));

    final String orderId = 'BLZ-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final newOrder = OrderModel(
      id: orderId,
      items: items,
      total: total,
      status: 'confirmed',
      address: address,
      createdAt: DateTime.now(),
    );

    _simulatedServerOrders[orderId] = newOrder;

    // Start background simulation of order status updates
    _simulateOrderStatusUpdates(orderId);

    return newOrder;
  }

  @override
  Future<OrderModel> getOrderStatus(String orderId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 250));

    if (_simulatedServerOrders.containsKey(orderId)) {
      return _simulatedServerOrders[orderId]!;
    }
    throw ServerException(message: 'Order not found', statusCode: 404);
  }

  void _simulateOrderStatusUpdates(String orderId) {
    // Stage 1: confirmed -> preparing (after 6 seconds)
    Future.delayed(const Duration(seconds: 6), () {
      final currentOrder = _simulatedServerOrders[orderId];
      if (currentOrder != null && currentOrder.status == 'confirmed') {
        _simulatedServerOrders[orderId] = OrderModel(
          id: currentOrder.id,
          items: currentOrder.items,
          total: currentOrder.total,
          status: 'preparing',
          address: currentOrder.address,
          createdAt: currentOrder.createdAt,
        );
      }
    });

    // Stage 2: preparing -> on_the_way (after 14 seconds)
    Future.delayed(const Duration(seconds: 14), () {
      final currentOrder = _simulatedServerOrders[orderId];
      if (currentOrder != null && currentOrder.status == 'preparing') {
        _simulatedServerOrders[orderId] = OrderModel(
          id: currentOrder.id,
          items: currentOrder.items,
          total: currentOrder.total,
          status: 'on_the_way',
          address: currentOrder.address,
          createdAt: currentOrder.createdAt,
        );
      }
    });

    // Stage 3: on_the_way -> delivered (after 28 seconds)
    Future.delayed(const Duration(seconds: 28), () {
      final currentOrder = _simulatedServerOrders[orderId];
      if (currentOrder != null && currentOrder.status == 'on_the_way') {
        _simulatedServerOrders[orderId] = OrderModel(
          id: currentOrder.id,
          items: currentOrder.items,
          total: currentOrder.total,
          status: 'delivered',
          address: currentOrder.address,
          createdAt: currentOrder.createdAt,
        );
      }
    });
  }
}
