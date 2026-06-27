import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_offers_usecase.dart';
import '../../domain/usecases/get_pharmacies_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetPharmaciesUseCase _getPharmaciesUseCase;
  final GetOffersUseCase _getOffersUseCase;

  HomeBloc({
    required GetCategoriesUseCase getCategoriesUseCase,
    required GetPharmaciesUseCase getPharmaciesUseCase,
    required GetOffersUseCase getOffersUseCase,
  })  : _getCategoriesUseCase = getCategoriesUseCase,
        _getPharmaciesUseCase = getPharmaciesUseCase,
        _getOffersUseCase = getOffersUseCase,
        super(const HomeInitial()) {
    on<LoadHomeEvent>(_onLoad);
  }

  Future<void> _onLoad(LoadHomeEvent event, Emitter<HomeState> emit) async {
    emit(const HomeLoading());

    // Run all three calls; use empty list on individual failures so the page
    // still renders partial data.
    final catResult = await _getCategoriesUseCase(const NoParams());
    final pharResult = await _getPharmaciesUseCase(const NoParams());
    final offResult = await _getOffersUseCase(const NoParams());

    emit(HomeLoaded(
      categories: catResult.getOrElse(() => []),
      pharmacies: pharResult.getOrElse(() => []),
      offers: offResult.getOrElse(() => []),
    ));
  }
}
