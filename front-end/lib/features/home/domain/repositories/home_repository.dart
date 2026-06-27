import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category_entity.dart';
import '../entities/offer_entity.dart';
import '../entities/pharmacy_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, List<PharmacyEntity>>> getPharmacies();
  Future<Either<Failure, List<OfferEntity>>> getFeaturedOffers();
}
