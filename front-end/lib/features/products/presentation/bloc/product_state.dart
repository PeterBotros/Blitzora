import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';
abstract class ProductState extends Equatable {
  const ProductState();
  @override List<Object?> get props => [];
}
class ProductInitial extends ProductState { const ProductInitial(); }
class ProductLoading extends ProductState { const ProductLoading(); }
class ProductLoaded extends ProductState {
  final List<ProductEntity> products;
  final String? activeCategory;
  final String? searchQuery;
  const ProductLoaded({required this.products, this.activeCategory, this.searchQuery});
  @override List<Object?> get props => [products, activeCategory, searchQuery];
}
class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);
  @override List<Object?> get props => [message];
}
