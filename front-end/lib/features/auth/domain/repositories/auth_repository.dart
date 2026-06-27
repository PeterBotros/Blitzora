import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String username,
    required String password,
    required String fullName,
    required String phone,
  });

  Future<Either<Failure, UserEntity>> getMe();

  Future<Either<Failure, void>> logout();
}
