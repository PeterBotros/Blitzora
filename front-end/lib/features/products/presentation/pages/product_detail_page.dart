import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../../../../core/wrapper/main_wrapper.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/favorite/favorite_bloc.dart';
import '../bloc/favorite/favorite_event.dart';
import '../bloc/favorite/favorite_state.dart';
import '../../../../core/routes/app_routes.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductEntity product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final primary = AppColors.primary(dark);
    final accent = AppColors.accent(dark);
    final bg = AppColors.background(dark);
    final card = AppColors.card(dark);
    final fg = AppColors.fg(dark);
    final muted = AppColors.muted(dark);
    final border = AppColors.border(dark);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(product.name,
            style: TextStyle(color: fg, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis),
        actions: [
          BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, favState) {
              final isFav = favState is FavoritesLoaded &&
                  favState.favoriteProducts.any((ProductEntity p) => p.id == product.id);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: isFav ? Colors.red.shade500 : accent,
                ),
                onPressed: () {
                  context.read<FavoriteBloc>().add(ToggleFavoriteEvent(product));
                },
              );
            },
          ),
          IconButton(
              icon: Icon(Icons.share_outlined, color: muted), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Hero image
          Container(
            height: 260,
            width: double.infinity,
            color: primary.withOpacity(0.08),
            child: product.imageUrl != null
                ? Image.network(product.imageUrl!,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                        Icons.medication_outlined,
                        color: primary.withOpacity(0.4),
                        size: 80))
                : Icon(Icons.medication_outlined,
                    color: primary.withOpacity(0.4), size: 80),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Name + badges
              Row(children: [
                Expanded(
                    child: Text(product.name,
                        style: TextStyle(
                            color: fg,
                            fontSize: 22,
                            fontWeight: FontWeight.bold))),
                if (product.hasDiscount)
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.red.shade600.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text('${product.discountPercent}% OFF',
                          style: TextStyle(
                              color: Colors.red.shade400,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
              ]),
              const SizedBox(height: 8),

              // Rating
              if (product.rating != null)
                Row(children: [
                  ...List.generate(
                      5,
                      (i) => Icon(
                          i < product.rating!.round()
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: Colors.amber,
                          size: 18)),
                  const SizedBox(width: 6),
                  Text('${product.rating!.toStringAsFixed(1)}',
                      style: TextStyle(color: fg, fontWeight: FontWeight.w600)),
                  if (product.reviewCount != null)
                    Text(' · ${product.reviewCount} reviews',
                        style: TextStyle(color: muted, fontSize: 13)),
                ]),
              const SizedBox(height: 16),

              // Price
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: border)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product.hasDiscount)
                              Text('EGP ${product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      color: muted,
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 14)),
                            Text(
                                'EGP ${product.discountedPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                    color: primary,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold)),
                          ]),
                      if (product.isFeatured)
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                                color: primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20)),
                            child: Text('Featured',
                                style: TextStyle(
                                    color: primary,
                                    fontWeight: FontWeight.w600))),
                    ]),
              ),
              const SizedBox(height: 20),

              // Description
              if (product.description != null) ...[
                Text('Description',
                    style: TextStyle(
                        color: fg, fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(product.description!,
                    style: TextStyle(color: muted, fontSize: 14, height: 1.6)),
                const SizedBox(height: 20),
              ],

              // Availability
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: border)),
                child: Row(children: [
                  Icon(
                      product.isActive
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      color: product.isActive ? Colors.green : Colors.red,
                      size: 22),
                  const SizedBox(width: 10),
                  Text(product.isActive ? 'In stock' : 'Out of stock',
                      style: TextStyle(
                          color: product.isActive
                              ? Colors.green.shade400
                              : Colors.red.shade400,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                ]),
              ),
              const SizedBox(height: 30),

              // Add to cart
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: product.isActive
                      ? () {
                          context.read<CartBloc>().add(AddCartItemEvent(
                              productId: product.id, quantity: 1));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                              backgroundColor: Colors.green,
                              action: SnackBarAction(
                                label: 'View Cart',
                                textColor: Colors.white,
                                onPressed: () {
                                  Navigator.pushNamed(context, AppRoutes.cart);
                                },
                              ),
                            ),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.shopping_cart_outlined, size: 20),
                  label: const Text('Add to cart',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14))),
                ),
              ),
              const SizedBox(height: 30),
            ]),
          ),
        ]),
      ),
    );
  }
}
