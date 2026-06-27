import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase extends UseCase<ProfileEntity, UpdateProfileParams> {
  final ProfileRepository repository;
  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, ProfileEntity>> call(UpdateProfileParams params) =>
      repository.updateProfile(
        fullName: params.fullName,
        username: params.username,
        phone: params.phone,
      );
}

class UpdateProfileParams extends Equatable {
  final String? fullName;
  final String? username;
  final String? phone;
  const UpdateProfileParams({this.fullName, this.username, this.phone});
  @override
  List<Object?> get props => [fullName, username, phone];
}
