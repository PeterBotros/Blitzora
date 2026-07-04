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
    super.diagnosisDate,
    super.prescriptionDate,
    super.isValid,
    super.rejectionReason,
    super.extractedMedicines,
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
      diagnosisDate: json['diagnosis_date'] != null
          ? DateTime.tryParse(json['diagnosis_date'].toString())
          : null,
      prescriptionDate: json['prescription_date'] != null
          ? DateTime.tryParse(json['prescription_date'].toString())
          : null,
      isValid: json['is_valid'] as bool? ?? true,
      rejectionReason: json['rejection_reason']?.toString(),
      extractedMedicines: json['extracted_medicines'] != null
          ? List<String>.from(json['extracted_medicines'] as List)
          : null,
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
      'diagnosis_date': diagnosisDate?.toIso8601String().split('T').first,
      'prescription_date': prescriptionDate?.toIso8601String().split('T').first,
      'is_valid': isValid,
      'rejection_reason': rejectionReason,
      'extracted_medicines': extractedMedicines,
    };
  }
}
