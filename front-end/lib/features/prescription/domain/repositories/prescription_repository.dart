import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/prescription_entity.dart';

abstract class PrescriptionRepository {
  Future<Either<Failure, PrescriptionEntity>> uploadPrescription({
    required String patientName,
    required String address,
    required String filePath,
    String? notes,
  });
}
