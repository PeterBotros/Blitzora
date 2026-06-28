import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../domain/entities/product_entity.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductEntity product;
  const ProductDetailPage({super.key, required this.product});
  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;

  void _addToCart(BuildContext context, Color primary) {
    context.read<CartBloc>().add(
        AddCartItemEvent(productId: widget.product.id, quantity: _quantity));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} added to cart'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

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
        title: Text(widget.product.name,
            style: TextStyle(color: fg, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
              icon: Icon(Icons.favorite_border_rounded, color: accent),
              onPressed: () {}),
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
            child: widget.product.imageUrl != null
                ? Image.network(widget.product.imageUrl!,
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
                    child: Text(widget.product.name,
                        style: TextStyle(
                            color: fg,
                            fontSize: 22,
                            fontWeight: FontWeight.bold))),
                if (widget.product.hasDiscount)
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.red.shade600.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text('${widget.product.discountPercent}% OFF',
                          style: TextStyle(
                              color: Colors.red.shade400,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
              ]),
              const SizedBox(height: 8),

              // Rating
              if (widget.product.rating != null)
                Row(children: [
                  ...List.generate(
                      5,
                      (i) => Icon(
                          i < widget.product.rating!.round()
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: Colors.amber,
                          size: 18)),
                  const SizedBox(width: 6),
                  Text('${widget.product.rating!.toStringAsFixed(1)}',
                      style: TextStyle(color: fg, fontWeight: FontWeight.w600)),
                  if (widget.product.reviewCount != null)
                    Text(' · ${widget.product.reviewCount} reviews',
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
                            if (widget.product.hasDiscount)
                              Text(
                                  'EGP ${widget.product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      color: muted,
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 14)),
                            Text(
                                'EGP ${widget.product.discountedPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                    color: primary,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold)),
                          ]),
                      if (widget.product.isFeatured)
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
              if (widget.product.description != null) ...[
                Text('Description',
                    style: TextStyle(
                        color: fg, fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(widget.product.description!,
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
                      widget.product.isActive
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      color:
                          widget.product.isActive ? Colors.green : Colors.red,
                      size: 22),
                  const SizedBox(width: 10),
                  Text(widget.product.isActive ? 'In stock' : 'Out of stock',
                      style: TextStyle(
                          color: widget.product.isActive
                              ? Colors.green.shade400
                              : Colors.red.shade400,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                ]),
              ),
              const SizedBox(height: 20),

              // Quantity selector
              if (widget.product.isActive) ...[
                Text('Quantity',
                    style: TextStyle(
                        color: fg, fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(children: [
                  Container(
                    decoration: BoxDecoration(
                        color: card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: border)),
                    child: Row(children: [
                      IconButton(
                          icon: Icon(Icons.remove_rounded, color: primary),
                          onPressed: _quantity > 1
                              ? () => setState(() => _quantity--)
                              : null),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('$_quantity',
                              style: TextStyle(
                                  color: fg,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold))),
                      IconButton(
                          icon: Icon(Icons.add_rounded, color: primary),
                          onPressed: () => setState(() => _quantity++)),
                    ]),
                  ),
                  const SizedBox(width: 12),
                  Text(
                      'Total: EGP ${(widget.product.discountedPrice * _quantity).toStringAsFixed(2)}',
                      style: TextStyle(color: muted, fontSize: 13)),
                ]),
                const SizedBox(height: 24),
              ],

              // Add to cart button with BlocConsumer feedback
              BlocConsumer<CartBloc, CartState>(
                listener: (context, state) {
                  if (state is CartError) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Failed to add: ${state.message}'),
                        backgroundColor: Colors.red.shade700));
                  }
                },
                builder: (context, state) {
                  final isLoading = state is CartLoading;
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: widget.product.isActive && !isLoading
                          ? () => _addToCart(context, primary)
                          : null,
                      icon: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.shopping_cart_outlined, size: 20),
                      label: Text(isLoading ? 'Adding…' : 'Add to cart',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14))),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
            ]),
          ),
        ]),
      ),
    );
  }
}
