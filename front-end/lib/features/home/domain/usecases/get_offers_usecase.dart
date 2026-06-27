import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/offer_entity.dart';
import '../repositories/home_repository.dart';

class GetOffersUseCase extends UseCase<List<OfferEntity>, NoParams> {
  final HomeRepository repository;
  GetOffersUseCase(this.repository);

  @override
  Future<Either<Failure, List<OfferEntity>>> call(NoParams params) =>
      repository.getFeaturedOffers();
}
