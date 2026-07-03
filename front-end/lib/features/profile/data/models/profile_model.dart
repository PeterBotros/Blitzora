import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.email,
    required super.username,
    super.fullName,
    super.phone,
    required super.role,
    required super.isActive,
    super.ordersCount,
    super.favoritesCount,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json['id'] as String,
        email: json['email'] as String,
        username: json['username'] as String,
        fullName: json['full_name'] as String?,
        phone: json['phone'] as String?,
        role: json['role'] as String? ?? 'user',
        isActive: json['is_active'] as bool? ?? true,
        ordersCount: json['orders_count'] as int? ?? 0,
        favoritesCount: json['favorites_count'] as int? ?? 0,
      );
}
