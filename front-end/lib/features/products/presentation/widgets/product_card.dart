import 'package:flutter/material.dart';
import '../../domain/entities/product_entity.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Image / placeholder
          Stack(children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(13)),
              child: product.imageUrl != null
                  ? Image.network(product.imageUrl!,
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _PlaceholderImage(primary: primary))
                  : _PlaceholderImage(primary: primary),
            ),
            if (product.hasDiscount)
              Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: Colors.red.shade600,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text('${product.discountPercent}% OFF',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)))),
            if (product.isFeatured)
              Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: primary.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Text('Featured',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)))),
          ]),

          Padding(
            padding: const EdgeInsets.all(10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(product.name,
                  style: TextStyle(
                      color: fg, fontSize: 13, fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              if (product.description != null)
                Text(product.description!,
                    style: TextStyle(color: muted, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              if (product.rating != null)
                Row(children: [
                  Icon(Icons.star_rounded, color: Colors.amber, size: 13),
                  const SizedBox(width: 3),
                  Text('${product.rating!.toStringAsFixed(1)}',
                      style: TextStyle(
                          color: fg,
                          fontSize: 11,
                          fontWeight: FontWeight.w500)),
                  if (product.reviewCount != null)
                    Text(' (${product.reviewCount})',
                        style: TextStyle(color: muted, fontSize: 11)),
                ]),
              const SizedBox(height: 4),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if (product.hasDiscount)
                    Text('EGP ${product.price.toStringAsFixed(0)}',
                        style: TextStyle(
                            color: muted,
                            fontSize: 10,
                            decoration: TextDecoration.lineThrough)),
                  Text('EGP ${product.discountedPrice.toStringAsFixed(0)}',
                      style: TextStyle(
                          color: primary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                ]),
                GestureDetector(
                  onTap: () {
                    context.read<CartBloc>().add(
                        AddCartItemEvent(productId: product.id, quantity: 1));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('${product.name} added to cart'),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 1)));
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
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  final Color primary;
  const _PlaceholderImage({required this.primary});
  @override
  Widget build(BuildContext context) => Container(
      height: 130,
      width: double.infinity,
      color: primary.withOpacity(0.08),
      child: Icon(Icons.medication_outlined,
          color: primary.withOpacity(0.4), size: 48));
}
