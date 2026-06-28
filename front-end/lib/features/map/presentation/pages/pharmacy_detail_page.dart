import 'package:flutter/material.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../../../home/domain/entities/pharmacy_entity.dart';
import 'pharmacy_map_screen.dart';

class PharmacyDetailPage extends StatelessWidget {
  final PharmacyEntity pharmacy;
  const PharmacyDetailPage({super.key, required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final primary = AppColors.primary(dark);
    final accent = AppColors.accent(dark);
    final secondary = AppColors.secondary(dark);
    final bg = AppColors.background(dark);
    final card = AppColors.card(dark);
    final fg = AppColors.fg(dark);
    final muted = AppColors.muted(dark);
    final border = AppColors.border(dark);

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          // ── App bar with map preview ──────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: bg,
            foregroundColor: fg,
            actions: [
              IconButton(
                icon: Icon(Icons.favorite_border_rounded, color: accent),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const PharmacyMapScreen())),
                child: Container(
                  color: dark ? const Color(0xFF0d1520) : const Color(0xFFe0f2fe),
                  child: Stack(children: [
                    CustomPaint(painter: _GridPainter(primary), child: const SizedBox.expand()),
                    Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(width: 56, height: 56,
                        decoration: BoxDecoration(color: primary.withOpacity(0.2),
                          shape: BoxShape.circle, border: Border.all(color: primary, width: 2)),
                        child: Icon(Icons.local_pharmacy_outlined, color: primary, size: 28)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: dark ? Colors.black.withOpacity(0.6) : Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(20)),
                        child: Text('Tap to open full map',
                          style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w500))),
                    ])),
                  ]),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // ── Name & status ─────────────────────────────────────────
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(pharmacy.name,
                      style: TextStyle(color: fg, fontSize: 22, fontWeight: FontWeight.bold)),
                    if (pharmacy.address != null) ...[
                      const SizedBox(height: 4),
                      Text(pharmacy.address!, style: TextStyle(color: muted, fontSize: 14)),
                    ],
                  ])),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: pharmacy.isOpen ? Colors.green.withOpacity(0.12) : muted.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20)),
                    child: Text(pharmacy.isOpen ? 'Open now' : 'Closed',
                      style: TextStyle(
                        color: pharmacy.isOpen ? Colors.green.shade400 : muted,
                        fontSize: 13, fontWeight: FontWeight.w600))),
                ]),
                const SizedBox(height: 20),

                // ── Info cards ────────────────────────────────────────────
                Container(
                  decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(16), border: Border.all(color: border)),
                  child: Column(children: [
                    _InfoRow(icon: Icons.access_time_rounded, iconColor: primary,
                      label: 'Working hours',
                      value: pharmacy.opensAt != null
                          ? '${pharmacy.opensAt} – ${pharmacy.closesAt}'
                          : 'Not specified'),
                    Divider(height: 1, color: border),
                    _InfoRow(icon: Icons.phone_outlined, iconColor: secondary,
                      label: 'Phone',
                      value: pharmacy.phone ?? 'Not available'),
                    if (pharmacy.latitude != null) ...[
                      Divider(height: 1, color: border),
                      _InfoRow(icon: Icons.location_on_outlined, iconColor: accent,
                        label: 'Coordinates',
                        value: '${pharmacy.latitude!.toStringAsFixed(4)}, ${pharmacy.longitude!.toStringAsFixed(4)}'),
                    ],
                    Divider(height: 1, color: border),
                    _InfoRow(icon: Icons.local_shipping_outlined, iconColor: Colors.green,
                      label: 'Delivery',
                      value: 'Available in your area'),
                  ]),
                ),
                const SizedBox(height: 24),

                // ── Action buttons ────────────────────────────────────────
                Row(children: [
                  Expanded(child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                    label: const Text('Order now', style: TextStyle(fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary, foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: OutlinedButton.icon(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const PharmacyMapScreen())),
                    icon: Icon(Icons.directions_outlined, size: 18, color: primary),
                    label: Text('Directions', style: TextStyle(color: primary, fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: primary.withOpacity(0.5)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  )),
                ]),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.iconColor, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final fg = AppColors.fg(dark);
    final muted = AppColors.muted(dark);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(children: [
        Container(width: 38, height: 38,
          decoration: BoxDecoration(color: iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: iconColor, size: 18)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(color: muted, fontSize: 11)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(color: fg, fontSize: 13, fontWeight: FontWeight.w500)),
        ])),
      ]),
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;
  _GridPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color.withOpacity(0.1)..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 40) canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    for (double y = 0; y < size.height; y += 40) canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
  }
  @override bool shouldRepaint(_) => false;
}
