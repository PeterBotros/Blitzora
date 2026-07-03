import 'package:equatable/equatable.dart';

class PrescriptionEntity extends Equatable {
  final String id;
  final String patientName;
  final String address;
  final String? notes;
  final String filePath;
  final String status; // "submitted", "reviewed", "fulfilled"
  final DateTime createdAt;

  const PrescriptionEntity({
    required this.id,
    required this.patientName,
    required this.address,
    this.notes,
    required this.filePath,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, patientName, address, notes, filePath, status, createdAt];
}
