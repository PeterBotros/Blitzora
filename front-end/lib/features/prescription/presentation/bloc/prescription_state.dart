import 'package:equatable/equatable.dart';
import '../../domain/entities/prescription_entity.dart';

abstract class PrescriptionState extends Equatable {
  const PrescriptionState();

  @override
  List<Object?> get props => [];
}

class PrescriptionInitial extends PrescriptionState {}

class PrescriptionLoading extends PrescriptionState {}

class PrescriptionUploadSuccess extends PrescriptionState {
  final PrescriptionEntity prescription;

  const PrescriptionUploadSuccess(this.prescription);

  @override
  List<Object?> get props => [prescription];
}

class PrescriptionError extends PrescriptionState {
  final String message;

  const PrescriptionError(this.message);

  @override
  List<Object?> get props => [message];
}
