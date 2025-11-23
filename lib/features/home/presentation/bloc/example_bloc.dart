import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/example_entity.dart';
import '../../domain/usecases/get_example.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

part 'example_event.dart';
part 'example_state.dart';

class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
  final GetExample getExample;

  ExampleBloc({required this.getExample}) : super(ExampleInitial()) {
    on<GetExampleEvent>(_onGetExample);
  }

  Future<void> _onGetExample(
    GetExampleEvent event,
    Emitter<ExampleState> emit,
  ) async {
    emit(ExampleLoading());
    final result = await getExample(NoParams());
    result.fold(
      (failure) => emit(ExampleError(_mapFailureToMessage(failure))),
      (example) => emit(ExampleLoaded(example)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error: ${failure.message}';
      case CacheFailure:
        return 'Cache error: ${failure.message}';
      case NetworkFailure:
        return 'Network error: ${failure.message}';
      default:
        return 'Unexpected error: ${failure.message}';
    }
  }
}
