import 'package:flutter/material.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/routes/app_routes.dart';

class CartItem {
  final String id;
  final String name;
  final String category;
  final double price;
  int quantity;
  final IconData icon;

  CartItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.quantity,
    required this.icon,
  });
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  // Global state to track active orders in this run
  static final ValueNotifier<bool> hasActiveOrder = ValueNotifier(false);
  static final ValueNotifier<double> activeOrderProgress = ValueNotifier(0.2); // 0.0 to 1.0

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<CartItem> _items = [
    CartItem(
      id: '1',
      name: 'Panadol Extra (500mg)',
      category: 'Analgesic & Antipyretic',
      price: 45.00,
      quantity: 2,
      icon: Icons.medication_rounded,
    ),
    CartItem(
      id: '2',
      name: 'Vitamin C Effervescent (1000mg)',
      category: 'Vitamins & Supplements',
      price: 85.00,
      quantity: 1,
      icon: Icons.favorite_rounded,
    ),
    CartItem(
      id: '3',
      name: 'Cetal Children Oral Suspension',
      category: 'Fever & Pain Relief',
      price: 25.00,
      quantity: 1,
      icon: Icons.baby_changing_station_rounded,
    ),
  ];

  double get subtotal => _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get deliveryFee => _items.isEmpty ? 0 : 15.00;
  double get tax => _items.isEmpty ? 0 : 5.00;
  double get total => subtotal + deliveryFee + tax;

  void _increaseQty(int index) {
    setState(() {
      _items[index].quantity++;
    });
  }

  void _decreaseQty(int index) {
    setState(() {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _handleCheckout() {
    if (_items.isEmpty) return;

    // Show checkout success modal dialog
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Checkout',
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
                          // Close dialog
                          Navigator.pop(ctx);
                          
                          // Set active order flag
                          CartPage.hasActiveOrder.value = true;
                          CartPage.activeOrderProgress.value = 0.25; // Confirmed state

                          // Clear cart
                          setState(() {
                            _items.clear();
                          });

                          // Navigate to tracking
                          AppNavigator.pushNamed(context, AppRoutes.trackOrder);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusSm)),
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
        title: Text('My Cart', style: TextStyle(color: fg, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _items.isEmpty
            ? Center(
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
                        child: Icon(Icons.shopping_cart_outlined, color: muted, size: 36),
                      ),
                      const SizedBox(height: 20),
                      Text('Your cart is empty', style: TextStyle(color: fg, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        'Browse pharmacies near you and add medicines to your cart.',
                        style: TextStyle(color: muted, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                children: [
                  // Address banner
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                              Text('Deliver to Home', style: TextStyle(color: fg, fontSize: 13, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 2),
                              Text('10 Road 9, Maadi, Cairo, Egypt', style: TextStyle(color: muted, fontSize: 11)),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                          child: Text('Edit', style: TextStyle(color: primary, fontSize: 12, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),

                  // Items List
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      itemCount: _items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return Container(
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
                                child: Icon(item.icon, color: primary),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: TextStyle(color: fg, fontSize: 14, fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(item.category, style: TextStyle(color: muted, fontSize: 11)),
                                    const SizedBox(height: 6),
                                    Text(
                                      'EGP ${item.price.toStringAsFixed(2)}',
                                      style: TextStyle(color: secondary, fontSize: 13, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove_circle_outline_rounded, color: primary, size: 22),
                                    onPressed: () => _decreaseQty(index),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      '${item.quantity}',
                                      style: TextStyle(color: fg, fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add_circle_outline_rounded, color: primary, size: 22),
                                    onPressed: () => _increaseQty(index),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Pricing & Checkout Summary
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
                            Text('Subtotal', style: TextStyle(color: muted, fontSize: 13)),
                            Text('EGP ${subtotal.toStringAsFixed(2)}', style: TextStyle(color: fg, fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Delivery Fee', style: TextStyle(color: muted, fontSize: 13)),
                            Text('EGP ${deliveryFee.toStringAsFixed(2)}', style: TextStyle(color: fg, fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tax & Services', style: TextStyle(color: muted, fontSize: 13)),
                            Text('EGP ${tax.toStringAsFixed(2)}', style: TextStyle(color: fg, fontSize: 13)),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(height: 1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Amount', style: TextStyle(color: fg, fontSize: 15, fontWeight: FontWeight.bold)),
                            Text(
                              'EGP ${total.toStringAsFixed(2)}',
                              style: TextStyle(color: primary, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _handleCheckout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.lock_outline_rounded, size: 18, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                'Secure Checkout (EGP ${total.toStringAsFixed(2)})',
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
