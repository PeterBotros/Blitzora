import 'package:equatable/equatable.dart';
import '../../../domain/entities/product_entity.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();
  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {
  const FavoriteInitial();
}

class FavoriteLoading extends FavoriteState {
  const FavoriteLoading();
}

class FavoritesLoaded extends FavoriteState {
  final List<ProductEntity> favoriteProducts;
  const FavoritesLoaded(this.favoriteProducts);

  @override
  List<Object?> get props => [favoriteProducts];
}

class FavoriteError extends FavoriteState {
  final String message;
  const FavoriteError(this.message);

  @override
  List<Object?> get props => [message];
}
