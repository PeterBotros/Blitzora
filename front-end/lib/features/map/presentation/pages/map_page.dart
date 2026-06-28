import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/bloc/home_event.dart';
import '../../../home/presentation/bloc/home_state.dart';
import '../../../home/domain/entities/pharmacy_entity.dart';
import 'pharmacy_detail_page.dart';
import 'pharmacy_map_screen.dart';

class MapScreenPage extends StatefulWidget {
  const MapScreenPage({super.key});
  @override
  State<MapScreenPage> createState() => _MapScreenPageState();
}

class _MapScreenPageState extends State<MapScreenPage> {
  String _activeFilter = 'All';
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();
  final List<String> _filters = ['All', 'Open now', 'Delivery', '24 hrs'];

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const LoadHomeEvent());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<PharmacyEntity> _applyFilters(List<PharmacyEntity> pharmacies) {
    var list = pharmacies;
    if (_searchQuery.isNotEmpty) {
      list = list
          .where((p) =>
              p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              (p.address ?? '')
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }
    if (_activeFilter == 'Open now')
      list = list.where((p) => p.isOpen).toList();
    return list;
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
        title: Text('Pharmacies',
            style: TextStyle(color: fg, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.map_outlined, color: secondary),
            tooltip: 'Open full map',
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const PharmacyMapScreen())),
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final allPharmacies =
              state is HomeLoaded ? state.pharmacies : <PharmacyEntity>[];
          final filtered = _applyFilters(allPharmacies);

          return Column(children: [
            // ── Mini map preview with tappable pins ──────────────────────
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const PharmacyMapScreen())),
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                height: 170,
                decoration: BoxDecoration(
                  color:
                      dark ? const Color(0xFF0d1520) : const Color(0xFFe0f2fe),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: border),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(children: [
                    CustomPaint(
                        painter: _MapGridPainter(primary),
                        child: const SizedBox.expand()),
                    // pharmacy pins using fractional alignment — no LayoutBuilder needed
                    if (allPharmacies.isNotEmpty)
                      ..._buildPins(allPharmacies, primary, dark, context),
                    // user location dot
                    Center(
                        child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                                color: secondary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: dark
                                        ? const Color(0xFF0d1520)
                                        : Colors.white,
                                    width: 2)))),
                    // bottom label
                    Positioned(
                        left: 12,
                        right: 12,
                        bottom: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 9),
                          decoration: BoxDecoration(
                              color: dark
                                  ? Colors.black.withOpacity(0.65)
                                  : Colors.white.withOpacity(0.88),
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(children: [
                            Icon(Icons.local_pharmacy_outlined,
                                color: primary, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(
                                    state is HomeLoading
                                        ? 'Loading pharmacies…'
                                        : '${allPharmacies.length} pharmacies available',
                                    style: TextStyle(color: fg, fontSize: 13))),
                            Text('Full map ›',
                                style: TextStyle(
                                    color: primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500)),
                          ]),
                        )),
                  ]),
                ),
              ),
            ),

            // ── Search ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                    color: card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: border)),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: TextStyle(color: fg, fontSize: 13),
                  decoration: InputDecoration(
                      hintText: 'Search pharmacies…',
                      hintStyle: TextStyle(color: muted, fontSize: 13),
                      prefixIcon:
                          Icon(Icons.search_rounded, color: muted, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.close, color: muted, size: 18),
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() => _searchQuery = '');
                              })
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12)),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ── Filter chips ──────────────────────────────────────────────
            SizedBox(
              height: 34,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                            color: active ? primary.withOpacity(0.15) : card,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: active
                                    ? primary.withOpacity(0.4)
                                    : border)),
                        child: Text(_filters[i],
                            style: TextStyle(
                                color: active ? primary : muted,
                                fontSize: 12,
                                fontWeight: FontWeight.w500))),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // ── Pharmacy list ─────────────────────────────────────────────
            Expanded(
              child: state is HomeLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                      ? Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              Icon(Icons.local_pharmacy_outlined,
                                  color: muted, size: 56),
                              const SizedBox(height: 12),
                              Text('No pharmacies found',
                                  style: TextStyle(
                                      color: fg,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              Text('Try a different search or filter',
                                  style: TextStyle(color: muted, fontSize: 13)),
                            ]))
                      : RefreshIndicator(
                          onRefresh: () async => context
                              .read<HomeBloc>()
                              .add(const LoadHomeEvent()),
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (_, i) => _PharmacyTile(
                              pharmacy: filtered[i],
                              primary: primary,
                              fg: fg,
                              muted: muted,
                              card: card,
                              border: border,
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => PharmacyDetailPage(
                                          pharmacy: filtered[i]))),
                            ),
                          ),
                        ),
            ),
          ]);
        },
      ),
    );
  }

  // Fixed: use Positioned.fill + Align instead of nested Positioned/LayoutBuilder
  List<Widget> _buildPins(List<PharmacyEntity> pharmacies, Color primary,
      bool dark, BuildContext context) {
    final positions = [
      [0.2, 0.25],
      [0.65, 0.2],
      [0.35, 0.6],
      [0.75, 0.55],
      [0.15, 0.5],
      [0.5, 0.35],
      [0.8, 0.3],
      [0.45, 0.7],
    ];
    return pharmacies
        .take(positions.length)
        .toList()
        .asMap()
        .entries
        .map((entry) {
      final pharmacy = entry.value;
      final pos = positions[entry.key];
      // Convert [0,1] range to Flutter Alignment [-1,1] range
      final alignment = Alignment(pos[0] * 2 - 1, pos[1] * 2 - 1);
      return Positioned.fill(
        child: Align(
          alignment: alignment,
          child: GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => PharmacyDetailPage(pharmacy: pharmacy))),
            child: Tooltip(
              message: pharmacy.name,
              child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      color: primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: primary, width: 1.5)),
                  child: Icon(Icons.local_pharmacy_outlined,
                      color: primary, size: 14)),
            ),
          ),
        ),
      );
    }).toList();
  }
}

class _PharmacyTile extends StatelessWidget {
  final PharmacyEntity pharmacy;
  final Color primary, fg, muted, card, border;
  final VoidCallback onTap;
  const _PharmacyTile(
      {required this.pharmacy,
      required this.primary,
      required this.fg,
      required this.muted,
      required this.card,
      required this.border,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border)),
        child: Row(children: [
          Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                  color: primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.local_pharmacy_outlined,
                  color: primary, size: 22)),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(pharmacy.name,
                    style: TextStyle(
                        color: fg, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                if (pharmacy.address != null)
                  Text(pharmacy.address!,
                      style: TextStyle(color: muted, fontSize: 12),
                      overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Row(children: [
                  _Pill(
                      pharmacy.isOpen ? 'Open' : 'Closed',
                      pharmacy.isOpen
                          ? Colors.green.withOpacity(0.15)
                          : muted.withOpacity(0.12),
                      pharmacy.isOpen ? Colors.green.shade400 : muted),
                  const SizedBox(width: 6),
                  if (pharmacy.opensAt != null)
                    _Pill('${pharmacy.opensAt} – ${pharmacy.closesAt}',
                        primary.withOpacity(0.1), primary),
                ]),
              ])),
          Icon(Icons.arrow_forward_ios_rounded, color: muted, size: 14),
        ]),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color bg, fg;
  const _Pill(this.label, this.bg, this.fg);
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style:
              TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.w500)));
}

class _MapGridPainter extends CustomPainter {
  final Color color;
  _MapGridPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color.withOpacity(0.12)
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 40)
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    for (double y = 0; y < size.height; y += 40)
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    final cp = Paint()
      ..color = color.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 50, cp);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 90, cp);
  }

  @override
  bool shouldRepaint(_) => false;
}
