import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/cart_repository.dart';

class RemoveCartItemUseCase {
  final CartRepository repository;
  RemoveCartItemUseCase(this.repository);

  Future<Either<Failure, void>> call(String itemId) =>
      repository.removeItem(itemId);
}
