import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/prescription_entity.dart';
import '../../domain/repositories/prescription_repository.dart';
import '../datasources/prescription_remote_datasource.dart';

class PrescriptionRepositoryImpl implements PrescriptionRepository {
  final PrescriptionRemoteDataSource remoteDataSource;

  PrescriptionRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, PrescriptionEntity>> uploadPrescription({
    required String patientName,
    required String address,
    required String filePath,
    String? notes,
  }) async {
    try {
      final result = await remoteDataSource.uploadPrescription(
        patientName: patientName,
        address: address,
        filePath: filePath,
        notes: notes,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
