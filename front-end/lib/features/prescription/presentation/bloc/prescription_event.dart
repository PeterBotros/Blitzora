import 'package:equatable/equatable.dart';

abstract class PrescriptionEvent extends Equatable {
  const PrescriptionEvent();

  @override
  List<Object?> get props => [];
}

class UploadPrescriptionEvent extends PrescriptionEvent {
  final String patientName;
  final String address;
  final String filePath;
  final String? notes;

  const UploadPrescriptionEvent({
    required this.patientName,
    required this.address,
    required this.filePath,
    this.notes,
  });

  @override
  List<Object?> get props => [patientName, address, filePath, notes];
}
