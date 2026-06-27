import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String email;
  final String username;
  final String? fullName;
  final String? phone;
  final String role;
  final bool isActive;

  const ProfileEntity({
    required this.id,
    required this.email,
    required this.username,
    this.fullName,
    this.phone,
    required this.role,
    required this.isActive,
  });

  String get displayName => fullName?.isNotEmpty == true ? fullName! : username;
  String get avatarLetter => displayName[0].toUpperCase();

  @override
  List<Object?> get props =>
      [id, email, username, fullName, phone, role, isActive];
}
