import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    super.description,
    required super.price,
    super.imageUrl,
    super.rating,
    super.reviewCount,
    required super.isActive,
    required super.isFeatured,
    super.discountPercent,
    super.categoryId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String?,
        price: num.tryParse(json['price'].toString())?.toDouble() ?? 0.0,
        imageUrl: json['image_url'] as String?,
        rating: json['rating'] != null
            ? num.tryParse(json['rating'].toString())?.toDouble()
            : null,
        reviewCount: json['review_count'] != null
            ? int.tryParse(json['review_count'].toString())
            : null,
        isActive: json['is_active'] as bool? ?? true,
        isFeatured: json['is_featured'] as bool? ?? false,
        discountPercent: json['discount_percent'] != null
            ? num.tryParse(json['discount_percent'].toString())?.toInt()
            : null,
        categoryId: json['category_id'] as String?,
      );
}
