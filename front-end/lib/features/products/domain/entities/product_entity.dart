import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;
  final double? rating;
  final int? reviewCount;
  final bool isActive;
  final bool isFeatured;
  final int? discountPercent;
  final String? categoryId;

  const ProductEntity({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    this.rating,
    this.reviewCount,
    required this.isActive,
    required this.isFeatured,
    this.discountPercent,
    this.categoryId,
  });

  double get discountedPrice {
    if (discountPercent == null || discountPercent == 0) return price;
    return price * (1 - discountPercent! / 100);
  }

  bool get hasDiscount => (discountPercent ?? 0) > 0;

  @override
  List<Object?> get props => [id, name, price, isActive, isFeatured];
}
