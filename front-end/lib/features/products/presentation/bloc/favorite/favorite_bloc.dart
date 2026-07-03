import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/favorite_repository.dart';
import '../../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../../profile/presentation/bloc/profile_event.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';
import '../../../domain/entities/product_entity.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository _favoriteRepository;
  final ProfileBloc _profileBloc;

  FavoriteBloc({
    required FavoriteRepository favoriteRepository,
    required ProfileBloc profileBloc,
  })  : _favoriteRepository = favoriteRepository,
        _profileBloc = profileBloc,
        super(const FavoriteInitial()) {
    on<LoadFavoritesEvent>(_onLoad);
    on<ToggleFavoriteEvent>(_onToggle);
  }

  Future<void> _onLoad(LoadFavoritesEvent event, Emitter<FavoriteState> emit) async {
    emit(const FavoriteLoading());
    final result = await _favoriteRepository.getFavorites();
    result.fold(
      (f) => emit(FavoriteError(f.message)),
      (products) => emit(FavoritesLoaded(products)),
    );
  }

  Future<void> _onToggle(ToggleFavoriteEvent event, Emitter<FavoriteState> emit) async {
    final current = state;
    if (current is FavoritesLoaded) {
      final isFav = current.favoriteProducts.any((ProductEntity p) => p.id == event.product.id);
      
      // Optimistic update
      final updatedList = List<ProductEntity>.from(current.favoriteProducts);
      if (isFav) {
        updatedList.removeWhere((ProductEntity p) => p.id == event.product.id);
      } else {
        updatedList.add(event.product);
      }
      emit(FavoritesLoaded(updatedList));

      if (isFav) {
        final result = await _favoriteRepository.removeFavorite(event.product.id);
        result.fold(
          (f) {
            emit(FavoritesLoaded(current.favoriteProducts)); // Revert on error
            emit(FavoriteError(f.message));
          },
          (_) {
            _profileBloc.add(const LoadProfileEvent()); // Sync count on profile
          },
        );
      } else {
        final result = await _favoriteRepository.addFavorite(event.product.id);
        result.fold(
          (f) {
            emit(FavoritesLoaded(current.favoriteProducts)); // Revert on error
            emit(FavoriteError(f.message));
          },
          (_) {
            _profileBloc.add(const LoadProfileEvent()); // Sync count on profile
          },
        );
      }
    } else {
      emit(const FavoriteLoading());
      final result = await _favoriteRepository.getFavorites();
      await result.fold(
        (f) async => emit(FavoriteError(f.message)),
        (products) async {
          emit(FavoritesLoaded(products));
          add(ToggleFavoriteEvent(event.product));
        },
      );
    }
  }
}
