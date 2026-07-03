import 'package:flutter/material.dart';
import '../../domain/entities/product_entity.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../bloc/favorite/favorite_bloc.dart';
import '../bloc/favorite/favorite_event.dart';
import '../bloc/favorite/favorite_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/app_routes.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final Color primary, card, fg, muted, border;
  final VoidCallback onTap;

  const ProductCard(
      {super.key,
      required this.product,
      required this.primary,
      required this.card,
      required this.fg,
      required this.muted,
      required this.border,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Fixed height is enforced by the GridView's childAspectRatio.
        // Inside we use a Column with fixed sub-sections so nothing overflows.
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image section (fixed height) ───────────────────────────────
            SizedBox(
              height: 120,
              child: Stack(children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(13)),
                  child: product.imageUrl != null
                      ? Image.network(
                          product.imageUrl!,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _PlaceholderImage(primary: primary, height: 120))
                      : _PlaceholderImage(primary: primary, height: 120),
                ),
                // Discount badge
                if (product.hasDiscount)
                  Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                              color: Colors.red.shade600,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text('${product.discountPercent}% OFF',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)))),
                // Favorite heart
                Positioned(
                  top: 6,
                  right: 6,
                  child: BlocBuilder<FavoriteBloc, FavoriteState>(
                    builder: (context, favState) {
                      final isFav = favState is FavoritesLoaded &&
                          favState.favoriteProducts
                              .any((ProductEntity p) => p.id == product.id);
                      return GestureDetector(
                        onTap: () => context
                            .read<FavoriteBloc>()
                            .add(ToggleFavoriteEvent(product)),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 4)
                            ],
                          ),
                          child: Icon(
                            isFav
                                ? Icons.favorite_rounded
                                : Icons.favorite_outline_rounded,
                            color: isFav
                                ? Colors.red.shade500
                                : Colors.grey.shade500,
                            size: 16,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ]),
            ),

            // ── Text + price section (fills remaining fixed space) ─────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name — always exactly 2 lines tall
                    SizedBox(
                      height: 36,
                      child: Text(
                        product.name,
                        style: TextStyle(
                            color: fg,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1.4),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 3),
                    // Description — always exactly 1 line tall
                    SizedBox(
                      height: 16,
                      child: product.description != null
                          ? Text(
                              product.description!,
                              style: TextStyle(color: muted, fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : const SizedBox.shrink(),
                    ),
                    // Rating row — fixed height whether present or not
                    SizedBox(
                      height: 18,
                      child: product.rating != null
                          ? Row(children: [
                              Icon(Icons.star_rounded,
                                  color: Colors.amber, size: 13),
                              const SizedBox(width: 3),
                              Text(
                                product.rating!.toStringAsFixed(1),
                                style: TextStyle(
                                    color: fg,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500),
                              ),
                              if (product.reviewCount != null)
                                Text(' (${product.reviewCount})',
                                    style:
                                        TextStyle(color: muted, fontSize: 11)),
                            ])
                          : const SizedBox.shrink(),
                    ),
                    // Push price + button to bottom
                    const Spacer(),
                    // Price row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (product.hasDiscount)
                                Text(
                                  'EGP ${product.price.toStringAsFixed(0)}',
                                  style: TextStyle(
                                      color: muted,
                                      fontSize: 10,
                                      decoration: TextDecoration.lineThrough),
                                ),
                              Text(
                                'EGP ${product.discountedPrice.toStringAsFixed(0)}',
                                style: TextStyle(
                                    color: primary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            context.read<CartBloc>().add(AddCartItemEvent(
                                productId: product.id, quantity: 1));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.name} added to cart'),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 2),
                                action: SnackBarAction(
                                  label: 'View Cart',
                                  textColor: Colors.white,
                                  onPressed: () => Navigator.pushNamed(
                                      context, AppRoutes.cart),
                                ),
                              ),
                            );
                          },
                          child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: primary,
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.add_rounded,
                                  color: Colors.white, size: 18)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  final Color primary;
  final double height;
  const _PlaceholderImage({required this.primary, this.height = 120});
  @override
  Widget build(BuildContext context) => Container(
      height: height,
      width: double.infinity,
      color: primary.withOpacity(0.08),
      child: Icon(Icons.medication_outlined,
          color: primary.withOpacity(0.4), size: 44));
}
