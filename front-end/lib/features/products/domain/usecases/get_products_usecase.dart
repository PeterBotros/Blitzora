import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsParams extends Equatable {
  final String? categoryId;
  final String? search;
  final int skip;
  final int limit;
  const GetProductsParams({this.categoryId, this.search, this.skip = 0, this.limit = 20});
  @override
  List<Object?> get props => [categoryId, search, skip, limit];
}

class GetProductsUseCase implements UseCase<List<ProductEntity>, GetProductsParams> {
  final ProductRepository _repo;
  GetProductsUseCase(this._repo);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(GetProductsParams params) =>
      _repo.getProducts(
          categoryId: params.categoryId,
          search: params.search,
          skip: params.skip,
          limit: params.limit);
}
