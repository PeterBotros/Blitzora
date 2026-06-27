import 'package:equatable/equatable.dart';

class OfferEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final double price;
  final int discountPercent;
  final String? imageUrl;

  const OfferEntity({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.discountPercent,
    this.imageUrl,
  });

  double get originalPrice =>
      discountPercent > 0 ? price / (1 - discountPercent / 100) : price;

  @override
  List<Object?> get props =>
      [id, name, description, price, discountPercent, imageUrl];
}
