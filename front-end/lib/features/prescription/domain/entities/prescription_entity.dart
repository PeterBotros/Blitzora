import 'package:equatable/equatable.dart';

class PrescriptionEntity extends Equatable {
  final String id;
  final String patientName;
  final String address;
  final String? notes;
  final String filePath;
  final String status; // "submitted", "reviewed", "fulfilled", "rejected"
  final DateTime createdAt;

  // AI verification fields
  final DateTime? diagnosisDate;
  final DateTime? prescriptionDate;
  final bool isValid;
  final String? rejectionReason;
  final List<String>? extractedMedicines;

  const PrescriptionEntity({
    required this.id,
    required this.patientName,
    required this.address,
    this.notes,
    required this.filePath,
    required this.status,
    required this.createdAt,
    this.diagnosisDate,
    this.prescriptionDate,
    this.isValid = true,
    this.rejectionReason,
    this.extractedMedicines,
  });

  @override
  List<Object?> get props => [
        id,
        patientName,
        address,
        notes,
        filePath,
        status,
        createdAt,
        diagnosisDate,
        prescriptionDate,
        isValid,
        rejectionReason,
        extractedMedicines,
      ];
}
