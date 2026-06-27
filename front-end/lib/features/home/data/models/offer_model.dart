import '../../domain/entities/offer_entity.dart';

class OfferModel extends OfferEntity {
  const OfferModel({
    required super.id,
    required super.name,
    super.description,
    required super.price,
    required super.discountPercent,
    super.imageUrl,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String?,
        price: (json['price'] as num).toDouble(),
        discountPercent: json['discount_percent'] as int? ?? 0,
        imageUrl: json['image_url'] as String?,
      );
}
