import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/pharmacy_entity.dart';
import '../repositories/home_repository.dart';

class GetPharmaciesUseCase extends UseCase<List<PharmacyEntity>, NoParams> {
  final HomeRepository repository;
  GetPharmaciesUseCase(this.repository);

  @override
  Future<Either<Failure, List<PharmacyEntity>>> call(NoParams params) =>
      repository.getPharmacies();
}
