import 'package:flutter/material.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/navigation/app_navigator.dart';

class TrackOrderPage extends StatefulWidget {
  const TrackOrderPage({super.key});

  @override
  State<TrackOrderPage> createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends State<TrackOrderPage> with SingleTickerProviderStateMixin {
  late AnimationController _mapAnimCtrl;
  late Animation<double> _driverProgress;

  @override
  void initState() {
    super.initState();
    _mapAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24), // 24 seconds for rider to travel from pharmacy to home
    );
    _driverProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mapAnimCtrl, curve: Curves.easeInOut),
    );
    _mapAnimCtrl.repeat(); // Loop simulation for premium interactive feel
  }

  @override
  void dispose() {
    _mapAnimCtrl.dispose();
    super.dispose();
  }

  void _callDriver() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Calling Captain Mahmoud (+20 100 234 5678)…'), backgroundColor: Colors.blue),
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
                      return CustomPaint(
                        painter: _RouteMapPainter(
                          progress: _driverProgress.value,
                          roadColor: border,
                          primaryColor: primary,
                          secondaryColor: secondary,
                          dark: dark,
                        ),
                        child: const SizedBox.expand(),
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
                            decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 8),
                          Text('Order #3829 • Live', style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w600)),
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
                        color: primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('ETA: 12 mins', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
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
                  _buildStepper(primary, secondary, fg, muted),
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
                            Text('3 Items from El Ezaby Pharmacy', style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        Text('EGP 220.00', style: TextStyle(color: primary, fontSize: 12, fontWeight: FontWeight.bold)),
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

  Widget _buildStepper(Color primary, Color secondary, Color fg, Color muted) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _stepItem('Confirmed', Icons.check_circle_rounded, true, primary, fg),
        _stepLine(true, primary),
        _stepItem('Preparing', Icons.hourglass_top_rounded, true, primary, fg),
        _stepLine(true, primary),
        _stepItem('On the way', Icons.delivery_dining_rounded, true, secondary, fg),
        _stepLine(false, muted),
        _stepItem('Delivered', Icons.home_filled, false, muted, muted),
      ],
    );
  }

  Widget _stepItem(String label, IconData icon, bool done, Color activeColor, Color textColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: done ? activeColor : Colors.grey.shade600, size: 20),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(color: textColor, fontSize: 10, fontWeight: done ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _stepLine(bool done, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          height: 2,
          color: color.withOpacity(0.6),
        ),
      ),
    );
  }
}

class _RouteMapPainter extends CustomPainter {
  final double progress;
  final Color roadColor;
  final Color primaryColor;
  final Color secondaryColor;
  final bool dark;

  _RouteMapPainter({
    required this.progress,
    required this.roadColor,
    required this.primaryColor,
    required this.secondaryColor,
    required this.dark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Draw background grid lines (city blocks)
    final gridPaint = Paint()
      ..color = roadColor.withOpacity(0.08)
      ..strokeWidth = 1.0;
    for (double i = 0; i < w; i += 50) {
      canvas.drawLine(Offset(i, 0), Offset(i, h), gridPaint);
    }
    for (double j = 0; j < h; j += 50) {
      canvas.drawLine(Offset(0, j), Offset(w, j), gridPaint);
    }

    // Define coordinates
    // Pharmacy coordinates (Start)
    final start = Offset(w * 0.15, h * 0.7);
    // Home coordinates (Destination)
    final end = Offset(w * 0.8, h * 0.25);

    // Intermediate road turns (simulating city streets)
    final turn1 = Offset(w * 0.5, h * 0.7);
    final turn2 = Offset(w * 0.5, h * 0.25);

    // Road path
    final roadPath = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(turn1.dx, turn1.dy)
      ..lineTo(turn2.dx, turn2.dy)
      ..lineTo(end.dx, end.dy);

    // Draw grey road
    final roadPaint = Paint()
      ..color = dark ? const Color(0xFF1e293b) : const Color(0xFFe2e8f0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(roadPath, roadPaint);

    // Draw active path (completed route by driver)
    // Interpolate driver position
    Offset driverPos;
    if (progress < 0.5) {
      // First leg (start -> turn1)
      final t = progress / 0.5;
      driverPos = Offset.lerp(start, turn1, t)!;
    } else if (progress < 0.8) {
      // Second leg (turn1 -> turn2)
      final t = (progress - 0.5) / 0.3;
      driverPos = Offset.lerp(turn1, turn2, t)!;
    } else {
      // Third leg (turn2 -> end)
      final t = (progress - 0.8) / 0.2;
      driverPos = Offset.lerp(turn2, end, t)!;
    }

    final activePath = Path()..moveTo(start.dx, start.dy);
    if (progress >= 0.5) {
      activePath.lineTo(turn1.dx, turn1.dy);
    }
    if (progress >= 0.8) {
      activePath.lineTo(turn2.dx, turn2.dy);
    }
    activePath.lineTo(driverPos.dx, driverPos.dy);

    final activePaint = Paint()
      ..color = primaryColor.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(activePath, activePaint);

    // Draw Pharmacy node
    final nodePaint = Paint()..style = PaintingStyle.fill;
    nodePaint.color = primaryColor;
    canvas.drawCircle(start, 12, nodePaint);
    nodePaint.color = Colors.white;
    canvas.drawCircle(start, 5, nodePaint);

    // Draw Home node
    nodePaint.color = secondaryColor;
    canvas.drawCircle(end, 14, nodePaint);
    nodePaint.color = Colors.white;
    canvas.drawCircle(end, 6, nodePaint);

    // Draw Driver location dot
    final driverPaint = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(driverPos, 10, driverPaint);
    driverPaint.color = Colors.white;
    canvas.drawCircle(driverPos, 4, driverPaint);

    // Add pulse ring around driver location
    final pulsePaint = Paint()
      ..color = secondaryColor.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(driverPos, 16, pulsePaint);
  }

  @override
  bool shouldRepaint(_RouteMapPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.dark != dark ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor;
  }
}
