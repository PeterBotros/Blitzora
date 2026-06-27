import 'package:flutter/material.dart';
import '../../../../core/constants/colors/app_colors.dart';
import 'pharmacy_map_screen.dart';

class MapScreenPage extends StatefulWidget {
  const MapScreenPage({super.key});

  @override
  State<MapScreenPage> createState() => _MapScreenPageState();
}

class _MapScreenPageState extends State<MapScreenPage> {
  String _activeFilter = 'Open now';
  final List<String> _filters = ['Open now', 'Delivery', '24 hrs', 'Nearby'];

  final _pharmacies = const [
    _PharmacyData('El Ezaby – Maadi', '10 Road 9, Maadi', '0.8 km', 4.7, true),
    _PharmacyData('Seif – Dokki', '3 Tahrir St, Dokki', '1.4 km', 4.5, true),
    _PharmacyData('Ghazal – Zamalek', '27 Shagaret El Dor St', '2.1 km', 4.3, true),
    _PharmacyData('Misr – Heliopolis', '33 Merghany St', '3.5 km', 4.1, false),
  ];

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
        title: Text('Nearby pharmacies', style: TextStyle(color: fg, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location_rounded, color: secondary),
            onPressed: () {},
            tooltip: 'Center on my location',
          ),
        ],
      ),
      body: Column(children: [
        // ── Map preview ──────────────────────────────────────────
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PharmacyMapScreen())),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            height: 200,
            decoration: BoxDecoration(
              color: dark ? const Color(0xFF0d1520) : const Color(0xFFe0f2fe),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: border),
            ),
            child: Stack(children: [
              // grid lines
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CustomPaint(painter: _MapGridPainter(primary), child: const SizedBox.expand()),
              ),
              // pharmacy pins
              Positioned(left: 60, top: 45, child: _MapPin(primary: primary, dark: dark)),
              Positioned(right: 50, top: 70, child: _MapPin(primary: primary, dark: dark)),
              Positioned(left: 100, bottom: 55, child: _MapPin(primary: primary, dark: dark)),
              // user dot
              Center(child: Container(width: 16, height: 16,
                decoration: BoxDecoration(color: secondary, shape: BoxShape.circle,
                  border: Border.all(color: dark ? const Color(0xFF0d1520) : Colors.white, width: 2)))),
              // bottom overlay
              Positioned(left: 12, right: 12, bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: dark ? Colors.black.withOpacity(0.65) : Colors.white.withOpacity(0.88),
                    borderRadius: BorderRadius.circular(12)),
                  child: Row(children: [
                    Icon(Icons.place_outlined, color: primary, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text('${_pharmacies.length} pharmacies found nearby',
                        style: TextStyle(color: fg, fontSize: 13))),
                    Text('Full map ›', style: TextStyle(color: primary, fontSize: 12, fontWeight: FontWeight.w500)),
                  ]),
                )),
            ]),
          ),
        ),

        const SizedBox(height: 14),

        // ── Search & filters ─────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 44,
            decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(12), border: Border.all(color: border)),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search pharmacies…',
                hintStyle: TextStyle(color: muted, fontSize: 13),
                prefixIcon: Icon(Icons.search_rounded, color: muted, size: 20),
                suffixIcon: Icon(Icons.tune_rounded, color: muted, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              style: TextStyle(color: fg, fontSize: 13),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // filter chips
        SizedBox(height: 34,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final active = _filters[i] == _activeFilter;
              return GestureDetector(
                onTap: () => setState(() => _activeFilter = _filters[i]),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: active ? primary.withOpacity(0.15) : card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: active ? primary.withOpacity(0.4) : border)),
                  child: Text(_filters[i],
                    style: TextStyle(color: active ? primary : muted, fontSize: 12, fontWeight: FontWeight.w500))),
              );
            },
          ),
        ),
        const SizedBox(height: 12),

        // ── Pharmacy list ─────────────────────────────────────────
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _pharmacies.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final p = _pharmacies[i];
              return _PharmacyListTile(
                data: p, primary: primary, fg: fg, muted: muted, card: card, border: border);
            },
          ),
        ),
      ]),
    );
  }
}

class _PharmacyData {
  final String name;
  final String address;
  final String distance;
  final double rating;
  final bool isOpen;
  const _PharmacyData(this.name, this.address, this.distance, this.rating, this.isOpen);
}

class _PharmacyListTile extends StatelessWidget {
  final _PharmacyData data;
  final Color primary, fg, muted, card, border;
  const _PharmacyListTile({required this.data, required this.primary,
      required this.fg, required this.muted, required this.card, required this.border});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(14), border: Border.all(color: border)),
      child: Row(children: [
        Container(width: 44, height: 44,
          decoration: BoxDecoration(color: primary.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
          child: Icon(Icons.local_pharmacy_outlined, color: primary)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(data.name, style: TextStyle(color: fg, fontWeight: FontWeight.w600, fontSize: 14))),
            Icon(Icons.star_rounded, color: Colors.amber, size: 14),
            Text(' ${data.rating}', style: TextStyle(color: fg, fontSize: 12)),
          ]),
          const SizedBox(height: 3),
          Text(data.address, style: TextStyle(color: muted, fontSize: 12), overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Row(children: [
            _Pill(data.isOpen ? 'Open' : 'Closed',
                data.isOpen ? Colors.green.withOpacity(0.15) : muted.withOpacity(0.12),
                data.isOpen ? Colors.green.shade400 : muted),
            const SizedBox(width: 6),
            _Pill(data.distance, Colors.cyan.withOpacity(0.12), Colors.cyan.shade300),
          ]),
        ])),
        const SizedBox(width: 8),
        Icon(Icons.arrow_forward_ios_rounded, color: muted, size: 14),
      ]),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label; final Color bg, fg;
  const _Pill(this.label, this.bg, this.fg);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
    child: Text(label, style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.w500)));
}

class _MapPin extends StatelessWidget {
  final Color primary; final bool dark;
  const _MapPin({required this.primary, required this.dark});
  @override
  Widget build(BuildContext context) => Container(
    width: 30, height: 30,
    decoration: BoxDecoration(
      color: primary.withOpacity(0.2),
      shape: BoxShape.circle,
      border: Border.all(color: primary, width: 1.5)),
    child: Icon(Icons.local_pharmacy_outlined, color: primary, size: 16));
}

class _MapGridPainter extends CustomPainter {
  final Color color;
  _MapGridPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withOpacity(0.12)..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 40) canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    for (double y = 0; y < size.height; y += 40) canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    final circlePaint = Paint()..color = color.withOpacity(0.1)..style = PaintingStyle.stroke..strokeWidth = 0.5;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 50, circlePaint);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 90, circlePaint);
  }
  @override
  bool shouldRepaint(_) => false;
}
