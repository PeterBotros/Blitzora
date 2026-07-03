import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../../../orders/presentation/bloc/order_bloc.dart';
import '../../../orders/presentation/bloc/order_event.dart';
import '../../../orders/presentation/bloc/order_state.dart';
import '../../../orders/domain/entities/order_entity.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  // Global notifiers for active order tracking (used by HomePage)
  static final ValueNotifier<bool> hasActiveOrder = ValueNotifier(false);
  static final ValueNotifier<double> activeOrderProgress = ValueNotifier(0.2);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(const LoadCartEvent());
  }

  void _handleCheckout(BuildContext context, List<CartItemEntity> cartItems, double total) {
    final orderItems = cartItems.map((e) => OrderItemEntity(
      productId: e.productId,
      productName: e.productName ?? 'Medicine',
      quantity: e.quantity,
      price: e.productPrice ?? 0.0,
    )).toList();

    context.read<OrderBloc>().add(CreateOrderEvent(
      items: orderItems,
      total: total,
      address: '123 Nile View St, Maadi, Cairo',
    ));
  }

  void _showOrderConfirmedDialog(BuildContext context, String orderId) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'OrderConfirmed',
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (ctx, anim1, anim2) {
        final dark = Theme.of(ctx).brightness == Brightness.dark;
        final primary = AppColors.primary(dark);
        final bg = AppColors.background(dark);
        final card = AppColors.card(dark);
        final fg = AppColors.fg(dark);
        return Scaffold(
          backgroundColor: bg.withOpacity(0.95),
          body: Center(
            child: ScaleTransition(
              scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                  border: Border.all(color: AppColors.border(dark)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check_circle_rounded, color: primary, size: 48),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Order Placed Successfully!',
                      style: TextStyle(color: fg, fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Order $orderId',
                      style: TextStyle(color: AppColors.muted(dark), fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Your medicine order has been received and is being prepared by the pharmacist.',
                      style: TextStyle(color: AppColors.muted(dark), fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          AppNavigator.pushNamed(
                            context,
                            AppRoutes.trackOrder,
                            arguments: {'orderId': orderId},
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                          ),
                        ),
                        child: const Text(
                          'Track My Order',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final primary = AppColors.primary(dark);
    final secondary = AppColors.secondary(dark);
    final bg = AppColors.background(dark);
    final card = AppColors.card(dark);
    final fg = AppColors.fg(dark);
    final muted = AppColors.muted(dark);
    final border = AppColors.border(dark);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text('My Cart',
            style: TextStyle(color: fg, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () {
              AppNavigator.pushNamed(context, AppRoutes.products);
            },
            icon: Icon(Icons.shopping_bag_outlined, color: primary, size: 18),
            label: Text('Continue Shopping', style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocListener<OrderBloc, OrderState>(
        listener: (context, orderState) {
          if (orderState is OrderLoading) {
            // loading overlay is shown via the button state
          } else if (orderState is OrderCreatedSuccess) {
            final orderId = orderState.order.id;
            CartPage.hasActiveOrder.value = true;
            CartPage.activeOrderProgress.value = 0.25;
            context.read<CartBloc>().add(const ClearCartEvent());
            _showOrderConfirmedDialog(context, orderId);
          } else if (orderState is OrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Checkout failed: ${orderState.message}'),
                backgroundColor: Colors.red.shade700,
              ),
            );
          }
        },
        child: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade700,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final items =
              state is CartLoaded ? state.cart.items : <CartItemEntity>[];
          final subtotal = state is CartLoaded ? state.cart.subtotal : 0.0;
          final deliveryFee =
              state is CartLoaded ? state.cart.deliveryFee : 0.0;
          final tax = state is CartLoaded ? state.cart.tax : 0.0;
          final total = state is CartLoaded ? state.cart.total : 0.0;

          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: card,
                        shape: BoxShape.circle,
                        border: Border.all(color: border),
                      ),
                      child: Icon(Icons.shopping_cart_outlined,
                          color: muted, size: 36),
                    ),
                    const SizedBox(height: 20),
                    Text('Your cart is empty',
                        style: TextStyle(
                            color: fg,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      'Browse pharmacies near you and add medicines to your cart.',
                      style: TextStyle(color: muted, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        AppNavigator.pushNamed(context, AppRoutes.products);
                      },
                      icon: const Icon(Icons.search_rounded, color: Colors.white, size: 18),
                      label: const Text('Continue Shopping', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return SafeArea(
            child: Column(
              children: [
                // Address banner
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: border),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: primary, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Deliver to Home',
                                style: TextStyle(
                                    color: fg,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text('10 Road 9, Maadi, Cairo, Egypt',
                                style: TextStyle(color: muted, fontSize: 11)),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero, minimumSize: Size.zero),
                        child: Text('Edit',
                            style: TextStyle(
                                color: primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),

                // Items list
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Dismissible(
                        key: Key(item.productId),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          context
                              .read<CartBloc>()
                              .add(RemoveCartItemEvent(item.productId));
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red.shade700,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.delete_outline_rounded,
                              color: Colors.white, size: 28),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: card,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: border),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.medication_rounded,
                                    color: primary),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.productName ?? 'Product',
                                      style: TextStyle(
                                          color: fg,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item.productDescription ?? '',
                                      style:
                                          TextStyle(color: muted, fontSize: 11),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'EGP ${(item.productPrice ?? 0).toStringAsFixed(2)}',
                                      style: TextStyle(
                                          color: secondary,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.remove_circle_outline_rounded,
                                      color: primary,
                                      size: 22,
                                    ),
                                    onPressed: () {
                                      if (item.quantity > 1) {
                                        context.read<CartBloc>().add(
                                              UpdateCartItemEvent(
                                                productId: item.productId,
                                                quantity: item.quantity - 1,
                                              ),
                                            );
                                      } else {
                                        context.read<CartBloc>().add(
                                              RemoveCartItemEvent(
                                                  item.productId),
                                            );
                                      }
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      '${item.quantity}',
                                      style: TextStyle(
                                          color: fg,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.add_circle_outline_rounded,
                                      color: primary,
                                      size: 22,
                                    ),
                                    onPressed: () {
                                      context.read<CartBloc>().add(
                                            UpdateCartItemEvent(
                                              productId: item.productId,
                                              quantity: item.quantity + 1,
                                            ),
                                          );
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Pricing summary & checkout
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: card,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    border: Border(top: BorderSide(color: border)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Subtotal',
                              style: TextStyle(color: muted, fontSize: 13)),
                          Text('EGP ${subtotal.toStringAsFixed(2)}',
                              style: TextStyle(color: fg, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Delivery Fee',
                              style: TextStyle(color: muted, fontSize: 13)),
                          Text('EGP ${deliveryFee.toStringAsFixed(2)}',
                              style: TextStyle(color: fg, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tax & Services',
                              style: TextStyle(color: muted, fontSize: 13)),
                          Text('EGP ${tax.toStringAsFixed(2)}',
                              style: TextStyle(color: fg, fontSize: 13)),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Amount',
                              style: TextStyle(
                                  color: fg,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                          Text(
                            'EGP ${total.toStringAsFixed(2)}',
                            style: TextStyle(
                                color: primary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _handleCheckout(context, items, total),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusSm),
                          ),
                        ),
                        child: BlocBuilder<OrderBloc, OrderState>(
                          builder: (context, orderState) {
                            if (orderState is OrderLoading) {
                              return const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              );
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.lock_outline_rounded,
                                    size: 18, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(
                                  'Secure Checkout (EGP ${total.toStringAsFixed(2)})',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        ),
      ),
    );
  }
}
