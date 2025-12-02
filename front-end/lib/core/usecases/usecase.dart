import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../errors/failures.dart';

/// Base use case interface
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// No parameters use case
abstract class UseCaseNoParams<Type> {
  Future<Either<Failure, Type>> call();
}

/// Base class for use case parameters
abstract class Params extends Equatable {
  const Params();
}

/// No parameters class
class NoParams extends Params {
  const NoParams();

  @override
  List<Object> get props => [];
}
