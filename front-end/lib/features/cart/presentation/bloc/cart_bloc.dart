import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/usecases/add_cart_item_usecase.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/remove_cart_item_usecase.dart';
import '../../domain/usecases/update_cart_item_usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase _getCartUseCase;
  final AddCartItemUseCase _addCartItemUseCase;
  final UpdateCartItemUseCase _updateCartItemUseCase;
  final RemoveCartItemUseCase _removeCartItemUseCase;

  CartBloc({
    required GetCartUseCase getCartUseCase,
    required AddCartItemUseCase addCartItemUseCase,
    required UpdateCartItemUseCase updateCartItemUseCase,
    required RemoveCartItemUseCase removeCartItemUseCase,
  })  : _getCartUseCase = getCartUseCase,
        _addCartItemUseCase = addCartItemUseCase,
        _updateCartItemUseCase = updateCartItemUseCase,
        _removeCartItemUseCase = removeCartItemUseCase,
        super(const CartInitial()) {
    on<LoadCartEvent>(_onLoad);
    on<AddCartItemEvent>(_onAdd);
    on<UpdateCartItemEvent>(_onUpdate);
    on<RemoveCartItemEvent>(_onRemove);
    on<ClearCartEvent>(_onClear);
  }

  Future<void> _onLoad(LoadCartEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    final result = await _getCartUseCase(const NoParams());
    result.fold(
      (f) => emit(CartError(f.message)),
      (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> _onAdd(AddCartItemEvent event, Emitter<CartState> emit) async {
    final result = await _addCartItemUseCase(
      AddCartItemParams(productId: event.productId, quantity: event.quantity),
    );
    result.fold(
      (f) => emit(CartError(f.message)),
      (_) => add(const LoadCartEvent()),
    );
  }

  Future<void> _onUpdate(
      UpdateCartItemEvent event, Emitter<CartState> emit) async {
    final result = await _updateCartItemUseCase(
      UpdateCartItemParams(itemId: event.productId, quantity: event.quantity),
    );
    result.fold(
      (f) => emit(CartError(f.message)),
      (_) => add(const LoadCartEvent()),
    );
  }

  Future<void> _onRemove(
      RemoveCartItemEvent event, Emitter<CartState> emit) async {
    final result = await _removeCartItemUseCase(event.productId);
    result.fold(
      (f) => emit(CartError(f.message)),
      (_) => add(const LoadCartEvent()),
    );
  }

  Future<void> _onClear(
      ClearCartEvent event, Emitter<CartState> emit) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      emit(CartLoaded(CartEntity(
        id: currentState.cart.id,
        userId: currentState.cart.userId,
        items: const [],
      )));
    }
  }
}
