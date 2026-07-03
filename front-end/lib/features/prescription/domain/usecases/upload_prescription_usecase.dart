import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/prescription_entity.dart';
import '../repositories/prescription_repository.dart';

class UploadPrescriptionParams {
  final String patientName;
  final String address;
  final String filePath;
  final String? notes;

  UploadPrescriptionParams({
    required this.patientName,
    required this.address,
    required this.filePath,
    this.notes,
  });
}

class UploadPrescriptionUseCase implements UseCase<PrescriptionEntity, UploadPrescriptionParams> {
  final PrescriptionRepository repository;

  UploadPrescriptionUseCase(this.repository);

  @override
  Future<Either<Failure, PrescriptionEntity>> call(UploadPrescriptionParams params) async {
    return await repository.uploadPrescription(
      patientName: params.patientName,
      address: params.address,
      filePath: params.filePath,
      notes: params.notes,
    );
  }
}
