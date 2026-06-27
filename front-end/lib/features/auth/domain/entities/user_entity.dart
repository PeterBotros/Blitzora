import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String username;
  final String? fullName;
  final String? phone;
  final String role;
  final bool isActive;

  const UserEntity({
    required this.id,
    required this.email,
    required this.username,
    this.fullName,
    this.phone,
    required this.role,
    required this.isActive,
  });

  @override
  List<Object?> get props =>
      [id, email, username, fullName, phone, role, isActive];
}
