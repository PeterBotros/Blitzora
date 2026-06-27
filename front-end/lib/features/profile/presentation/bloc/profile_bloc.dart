import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final ProfileRepository _profileRepository;

  ProfileBloc({
    required GetProfileUseCase getProfileUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required ProfileRepository profileRepository,
  })  : _getProfileUseCase = getProfileUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        _profileRepository = profileRepository,
        super(const ProfileInitial()) {
    on<LoadProfileEvent>(_onLoad);
    on<UpdateProfileEvent>(_onUpdate);
    on<LogoutProfileEvent>(_onLogout);
  }

  Future<void> _onLoad(
      LoadProfileEvent event, Emitter<ProfileState> emit) async {
    emit(const ProfileLoading());
    final result = await _getProfileUseCase(const NoParams());
    result.fold(
      (f) => emit(ProfileError(f.message)),
      (p) => emit(ProfileLoaded(p)),
    );
  }

  Future<void> _onUpdate(
      UpdateProfileEvent event, Emitter<ProfileState> emit) async {
    emit(const ProfileLoading());
    final result = await _updateProfileUseCase(
      UpdateProfileParams(
        fullName: event.fullName,
        username: event.username,
        phone: event.phone,
      ),
    );
    result.fold(
      (f) => emit(ProfileError(f.message)),
      (p) => emit(ProfileUpdated(p)),
    );
  }

  Future<void> _onLogout(
      LogoutProfileEvent event, Emitter<ProfileState> emit) async {
    await _profileRepository.logout();
    emit(const ProfileLoggedOut());
  }
}
