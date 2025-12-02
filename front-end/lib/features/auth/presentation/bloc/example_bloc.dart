import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/example_entity.dart';

part 'example_event.dart';
part 'example_state.dart';

class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
  ExampleBloc() : super(ExampleInitial()) {
    on<GetExampleEvent>(_onGetExample);
  }

  Future<void> _onGetExample(
    GetExampleEvent event,
    Emitter<ExampleState> emit,
  ) async {
    emit(ExampleLoading());
    // TODO: Implement use case call when available
    // For now, emit an initial state
    emit(const ExampleError('Not implemented yet'));
  }
}
