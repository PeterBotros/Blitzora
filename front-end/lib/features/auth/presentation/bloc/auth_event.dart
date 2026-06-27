import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  const LoginEvent({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String username;
  final String password;
  final String fullName;
  final String phone;
  const RegisterEvent({
    required this.email,
    required this.username,
    required this.password,
    required this.fullName,
    required this.phone,
  });
  @override
  List<Object?> get props => [email, username, password, fullName, phone];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

class GetCurrentUserEvent extends AuthEvent {
  const GetCurrentUserEvent();
}
