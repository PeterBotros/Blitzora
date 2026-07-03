import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/upload_prescription_usecase.dart';
import 'prescription_event.dart';
import 'prescription_state.dart';

class PrescriptionBloc extends Bloc<PrescriptionEvent, PrescriptionState> {
  final UploadPrescriptionUseCase uploadPrescriptionUseCase;

  PrescriptionBloc({
    required this.uploadPrescriptionUseCase,
  }) : super(PrescriptionInitial()) {
    on<UploadPrescriptionEvent>(_onUploadPrescription);
  }

  Future<void> _onUploadPrescription(
    UploadPrescriptionEvent event,
    Emitter<PrescriptionState> emit,
  ) async {
    emit(PrescriptionLoading());
    final result = await uploadPrescriptionUseCase(UploadPrescriptionParams(
      patientName: event.patientName,
      address: event.address,
      filePath: event.filePath,
      notes: event.notes,
    ));
    result.fold(
      (failure) => emit(PrescriptionError(failure.message)),
      (prescription) => emit(PrescriptionUploadSuccess(prescription)),
    );
  }
}
