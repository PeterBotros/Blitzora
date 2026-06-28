import 'package:equatable/equatable.dart';
abstract class ProductEvent extends Equatable {
  const ProductEvent();
  @override List<Object?> get props => [];
}
class LoadProductsEvent extends ProductEvent {
  final String? categoryId;
  final String? search;
  final bool refresh;
  const LoadProductsEvent({this.categoryId, this.search, this.refresh = false});
  @override List<Object?> get props => [categoryId, search, refresh];
}
class SearchProductsEvent extends ProductEvent {
  final String query;
  const SearchProductsEvent(this.query);
  @override List<Object?> get props => [query];
}
