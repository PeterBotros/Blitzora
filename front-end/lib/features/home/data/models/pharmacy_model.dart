import '../../domain/entities/pharmacy_entity.dart';

class PharmacyModel extends PharmacyEntity {
  const PharmacyModel({
    required super.id,
    required super.name,
    super.address,
    super.latitude,
    super.longitude,
    super.phone,
    super.opensAt,
    super.closesAt,
  });

  factory PharmacyModel.fromJson(Map<String, dynamic> json) => PharmacyModel(
        id: json['id'] as String,
        name: json['name'] as String,
        address: json['address'] as String?,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        phone: json['phone'] as String?,
        opensAt: json['opens_at'] as String?,
        closesAt: json['closes_at'] as String?,
      );
}
