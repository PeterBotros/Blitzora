import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/example_entity.dart';

/// Repository interface - part of domain layer
abstract class ExampleRepository {
  Future<Either<Failure, ExampleEntity>> getExample();
}


