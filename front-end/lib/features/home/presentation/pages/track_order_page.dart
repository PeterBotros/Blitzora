import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../orders/presentation/bloc/order_bloc.dart';
import '../../../orders/presentation/bloc/order_event.dart';
import '../../../orders/presentation/bloc/order_state.dart';

class TrackOrderPage extends StatefulWidget {
  final String? orderId;
  const TrackOrderPage({super.key, this.orderId});

  @override
  State<TrackOrderPage> createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends State<TrackOrderPage> with SingleTickerProviderStateMixin {
  late AnimationController _mapAnimCtrl;
  late Animation<double> _driverProgress;
  Timer? _pollTimer;

  static final List<LatLng> _routePoints = [
    const LatLng(29.9602, 31.2569), // El Ezaby Pharmacy, Maadi
    const LatLng(29.9592, 31.2575), // Road 9 turn
    const LatLng(29.9575, 31.2584), // Intersection
    const LatLng(29.9560, 31.2598), // Near Maadi Metro
    const LatLng(29.9545, 31.2612), // User's Home Address
  ];

  LatLng _getCurrentDriverPosition(double progress) {
    if (_routePoints.isEmpty) return const LatLng(29.9602, 31.2569);
    if (progress <= 0.0) return _routePoints.first;
    if (progress >= 1.0) return _routePoints.last;

    final double totalSegments = (_routePoints.length - 1).toDouble();
    final double position = progress * totalSegments;
    final int index = position.floor();
    final double segmentProgress = position - index;

    if (index >= _routePoints.length - 1) return _routePoints.last;

    final LatLng start = _routePoints[index];
    final LatLng end = _routePoints[index + 1];

    final double lat = start.latitude + (end.latitude - start.latitude) * segmentProgress;
    final double lng = start.longitude + (end.longitude - start.longitude) * segmentProgress;

    return LatLng(lat, lng);
  }

  int _getCurrentSegmentIndex(double progress) {
    if (progress <= 0.0) return 0;
    if (progress >= 1.0) return _routePoints.length - 1;
    final double totalSegments = (_routePoints.length - 1).toDouble();
    final double position = progress * totalSegments;
    return position.floor();
  }

  @override
  void initState() {
    super.initState();
    _mapAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    );
    _driverProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mapAnimCtrl, curve: Curves.easeInOut),
    );
    _mapAnimCtrl.repeat();

    // Start polling if we have a real order ID
    if (widget.orderId != null) {
      _startPolling();
    }
  }

  void _startPolling() {
    // Initial fetch
    context.read<OrderBloc>().add(GetOrderStatusEvent(widget.orderId!));
    // Poll every 5 seconds
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) {
        context.read<OrderBloc>().add(GetOrderStatusEvent(widget.orderId!));
      }
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _mapAnimCtrl.dispose();
    super.dispose();
  }

  String _getOrderStatus(OrderState orderState) {
    if (orderState is OrderStatusLoaded) return orderState.order.status;
    return 'confirmed';
  }

  String _getEtaText(String status) {
    switch (status) {
      case 'confirmed': return 'ETA: ~20 mins';
      case 'preparing': return 'ETA: ~14 mins';
      case 'on_the_way': return 'ETA: ~6 mins';
      case 'delivered': return 'Delivered!';
      default: return 'ETA: ~20 mins';
    }
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

    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, orderState) {
        final status = _getOrderStatus(orderState);
        final etaText = _getEtaText(status);
        final orderId = (orderState is OrderStatusLoaded)
            ? orderState.order.id
            : (widget.orderId ?? '#---');
        final orderTotal = (orderState is OrderStatusLoaded)
            ? orderState.order.total
            : null;
        final itemCount = (orderState is OrderStatusLoaded)
            ? orderState.order.items.length
            : null;

        return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text('Track Order', style: TextStyle(color: fg, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Live Simulated Map ────────────────────────────────
            Expanded(
              child: Stack(
                children: [
                  AnimatedBuilder(
                    animation: _driverProgress,
                    builder: (context, child) {
                      final riderPos = _getCurrentDriverPosition(_driverProgress.value);
                      return FlutterMap(
                        options: const MapOptions(
                          initialCenter: LatLng(29.9575, 31.2584),
                          initialZoom: 15.0,
                          minZoom: 13.0,
                          maxZoom: 18.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: dark
                                ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                                : 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                            subdomains: const ['a', 'b', 'c', 'd'],
                            userAgentPackageName: 'com.blitzora.app',
                          ),
                          PolylineLayer(
                            polylines: [
                              Polyline(
                                points: _routePoints,
                                color: primary.withOpacity(0.4),
                                strokeWidth: 5.0,
                              ),
                              Polyline(
                                points: _routePoints.sublist(0, _getCurrentSegmentIndex(_driverProgress.value) + 1)
                                  ..add(riderPos),
                                color: secondary,
                                strokeWidth: 5.0,
                              ),
                            ],
                          ),
                          MarkerLayer(
                            markers: [
                              // Pharmacy
                              Marker(
                                point: _routePoints.first,
                                width: 40,
                                height: 40,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(Icons.local_pharmacy_rounded, color: Colors.white, size: 20),
                                ),
                              ),
                              // Home
                              Marker(
                                point: _routePoints.last,
                                width: 40,
                                height: 40,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(Icons.home_filled, color: Colors.white, size: 20),
                                ),
                              ),
                              // Rider
                              Marker(
                                point: riderPos,
                                width: 40,
                                height: 40,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: secondary,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                    boxShadow: const [
                                      BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                                    ],
                                  ),
                                  child: const Icon(Icons.delivery_dining_rounded, color: Colors.white, size: 20),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),

                  // Overlay Pills
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: card.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: status == 'delivered' ? Colors.grey : Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Order $orderId • ${status == "delivered" ? "Delivered" : "Live"}',
                            style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: status == 'delivered' ? Colors.green : primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(etaText, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),

            // ── Rider & Order Details Panel ───────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: card,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, -6))
                ],
                border: Border(top: BorderSide(color: border)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Stepper statuses
                  _buildStepper(primary, secondary, fg, muted, status),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(height: 1),
                  ),

                  // Rider Card
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [primary, secondary]),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text('M', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Captain Mahmoud', style: TextStyle(color: fg, fontSize: 15, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text('Bajaj Pulsar (Red) • أ ر ج ٩٣٨', style: TextStyle(color: muted, fontSize: 12)),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _callDriver,
                        style: IconButton.styleFrom(
                          backgroundColor: primary.withOpacity(0.12),
                          padding: const EdgeInsets.all(12),
                        ),
                        icon: Icon(Icons.phone_rounded, color: primary, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Order items brief
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.shopping_bag_outlined, color: muted, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              itemCount != null ? '$itemCount item${itemCount != 1 ? "s" : ""}' : '— items',
                              style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Text(
                          orderTotal != null ? 'EGP ${orderTotal.toStringAsFixed(2)}' : '—',
                          style: TextStyle(color: primary, fontSize: 12, fontWeight: FontWeight.bold),
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
      },
    );
  }

  void _callDriver() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Calling Captain Mahmoud (+20 100 234 5678)…'), backgroundColor: Colors.blue),
    );
  }

  Widget _buildStepper(Color primary, Color secondary, Color fg, Color muted, String status) {
    final isConfirmed = true; // always
    final isPreparing = status == 'preparing' || status == 'on_the_way' || status == 'delivered';
    final isOnTheWay = status == 'on_the_way' || status == 'delivered';
    final isDelivered = status == 'delivered';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _stepItem('Confirmed', Icons.check_circle_rounded, isConfirmed, primary, fg),
        _stepLine(isPreparing, primary, muted),
        _stepItem('Preparing', Icons.hourglass_top_rounded, isPreparing, primary, fg),
        _stepLine(isOnTheWay, secondary, muted),
        _stepItem('On the way', Icons.delivery_dining_rounded, isOnTheWay, secondary, fg),
        _stepLine(isDelivered, Colors.green, muted),
        _stepItem('Delivered', Icons.home_filled, isDelivered, Colors.green, fg),
      ],
    );
  }

  Widget _stepItem(String label, IconData icon, bool done, Color activeColor, Color textColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: done ? activeColor : Colors.grey.shade600, size: 20),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(color: done ? textColor : Colors.grey.shade600, fontSize: 10, fontWeight: done ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _stepLine(bool done, Color activeColor, Color inactiveColor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          height: 2,
          color: (done ? activeColor : inactiveColor).withOpacity(0.6),
        ),
      ),
    );
  }
}

