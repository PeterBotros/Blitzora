import '../../domain/entities/prescription_entity.dart';

class PrescriptionModel extends PrescriptionEntity {
  const PrescriptionModel({
    required super.id,
    required super.patientName,
    required super.address,
    super.notes,
    required super.filePath,
    required super.status,
    required super.createdAt,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: json['id']?.toString() ?? '',
      patientName: json['patient_name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      notes: json['notes']?.toString(),
      filePath: json['file_path']?.toString() ?? '',
      status: json['status']?.toString() ?? 'submitted',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_name': patientName,
      'address': address,
      'notes': notes,
      'file_path': filePath,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
