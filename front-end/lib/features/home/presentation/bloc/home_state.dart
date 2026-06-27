import 'package:equatable/equatable.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/offer_entity.dart';
import '../../domain/entities/pharmacy_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<CategoryEntity> categories;
  final List<PharmacyEntity> pharmacies;
  final List<OfferEntity> offers;

  const HomeLoaded({
    required this.categories,
    required this.pharmacies,
    required this.offers,
  });

  @override
  List<Object?> get props => [categories, pharmacies, offers];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
  @override
  List<Object?> get props => [message];
}
