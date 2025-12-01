import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/example_entity.dart';
import '../repositories/example_repository.dart';

class GetExample implements UseCase<ExampleEntity, NoParams> {
  final ExampleRepository repository;

  GetExample(this.repository);

  @override
  Future<Either<Failure, ExampleEntity>> call(NoParams params) async {
    return await repository.getExample();
  }
}


