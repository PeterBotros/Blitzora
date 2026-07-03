import '../models/prescription_model.dart';

abstract class PrescriptionRemoteDataSource {
  Future<PrescriptionModel> uploadPrescription({
    required String patientName,
    required String address,
    required String filePath,
    String? notes,
  });
}

class PrescriptionRemoteDataSourceImpl implements PrescriptionRemoteDataSource {
  @override
  Future<PrescriptionModel> uploadPrescription({
    required String patientName,
    required String address,
    required String filePath,
    String? notes,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));

    final String rxId = 'RX-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    return PrescriptionModel(
      id: rxId,
      patientName: patientName,
      address: address,
      notes: notes,
      filePath: filePath,
      status: 'submitted',
      createdAt: DateTime.now(),
    );
  }
}
