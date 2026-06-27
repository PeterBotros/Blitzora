import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase extends UseCase<UserEntity, RegisterParams> {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) =>
      repository.register(
        email: params.email,
        username: params.username,
        password: params.password,
        fullName: params.fullName,
        phone: params.phone,
      );
}

class RegisterParams extends Equatable {
  final String email;
  final String username;
  final String password;
  final String fullName;
  final String phone;

  const RegisterParams({
    required this.email,
    required this.username,
    required this.password,
    required this.fullName,
    required this.phone,
  });

  @override
  List<Object?> get props => [email, username, password, fullName, phone];
}
