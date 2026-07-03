import 'package:equatable/equatable.dart';
import '../../../domain/entities/product_entity.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();
  @override
  List<Object?> get props => [];
}

class LoadFavoritesEvent extends FavoriteEvent {
  const LoadFavoritesEvent();
}

class ToggleFavoriteEvent extends FavoriteEvent {
  final ProductEntity product;
  const ToggleFavoriteEvent(this.product);

  @override
  List<Object?> get props => [product];
}
