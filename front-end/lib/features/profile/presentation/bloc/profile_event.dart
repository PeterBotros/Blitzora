import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {
  const LoadProfileEvent();
}

class UpdateProfileEvent extends ProfileEvent {
  final String? fullName;
  final String? username;
  final String? phone;
  const UpdateProfileEvent({this.fullName, this.username, this.phone});
  @override
  List<Object?> get props => [fullName, username, phone];
}

class LogoutProfileEvent extends ProfileEvent {
  const LogoutProfileEvent();
}
