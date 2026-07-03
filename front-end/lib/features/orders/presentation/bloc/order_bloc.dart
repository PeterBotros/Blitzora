import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_order_usecase.dart';
import '../../domain/usecases/get_order_status_usecase.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final CreateOrderUseCase createOrderUseCase;
  final GetOrderStatusUseCase getOrderStatusUseCase;

  OrderBloc({
    required this.createOrderUseCase,
    required this.getOrderStatusUseCase,
  }) : super(OrderInitial()) {
    on<CreateOrderEvent>(_onCreateOrder);
    on<GetOrderStatusEvent>(_onGetOrderStatus);
  }

  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    final result = await createOrderUseCase(CreateOrderParams(
      items: event.items,
      total: event.total,
      address: event.address,
    ));
    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (order) => emit(OrderCreatedSuccess(order)),
    );
  }

  Future<void> _onGetOrderStatus(
    GetOrderStatusEvent event,
    Emitter<OrderState> emit,
  ) async {
    final result = await getOrderStatusUseCase(event.orderId);
    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (order) => emit(OrderStatusLoaded(order)),
    );
  }
}
