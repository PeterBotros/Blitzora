import 'package:equatable/equatable.dart';

class PharmacyEntity extends Equatable {
  final String id;
  final String name;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? phone;
  final String? opensAt;
  final String? closesAt;

  const PharmacyEntity({
    required this.id,
    required this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.phone,
    this.opensAt,
    this.closesAt,
  });

  bool get isOpen {
    if (opensAt == null || closesAt == null) return true;
    try {
      final now = DateTime.now();
      final op = opensAt!.split(':');
      final cl = closesAt!.split(':');
      final open = DateTime(
          now.year, now.month, now.day, int.parse(op[0]), int.parse(op[1]));
      final close = DateTime(
          now.year, now.month, now.day, int.parse(cl[0]), int.parse(cl[1]));
      return now.isAfter(open) && now.isBefore(close);
    } catch (_) {
      return true;
    }
  }

  @override
  List<Object?> get props =>
      [id, name, address, latitude, longitude, phone, opensAt, closesAt];
}
