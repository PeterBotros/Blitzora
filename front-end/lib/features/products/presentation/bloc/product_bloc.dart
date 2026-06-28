import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase _getProductsUseCase;
  ProductBloc({required GetProductsUseCase getProductsUseCase})
      : _getProductsUseCase = getProductsUseCase,
        super(const ProductInitial()) {
    on<LoadProductsEvent>(_onLoad);
    on<SearchProductsEvent>(_onSearch);
  }

  Future<void> _onLoad(LoadProductsEvent event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());
    final result = await _getProductsUseCase(
        GetProductsParams(categoryId: event.categoryId, search: event.search));
    result.fold(
      (f) => emit(ProductError(f.message)),
      (products) => emit(ProductLoaded(
          products: products,
          activeCategory: event.categoryId,
          searchQuery: event.search)),
    );
  }

  Future<void> _onSearch(SearchProductsEvent event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());
    final result = await _getProductsUseCase(GetProductsParams(search: event.query));
    result.fold(
      (f) => emit(ProductError(f.message)),
      (products) => emit(ProductLoaded(products: products, searchQuery: event.query)),
    );
  }
}
