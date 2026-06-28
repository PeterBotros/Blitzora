import 'package:flutter/material.dart';
import '../../../../core/constants/colors/app_colors.dart';

class HomeLocationSelector extends StatefulWidget {
  final Color primary;
  final Color fg;
  final Color card;
  final Color muted;
  final Color border;
  const HomeLocationSelector({super.key,
      required this.primary, required this.fg,
      required this.card, required this.muted, required this.border});

  @override
  State<HomeLocationSelector> createState() => _HomeLocationSelectorState();
}

class _HomeLocationSelectorState extends State<HomeLocationSelector> {
  String _location = 'Cairo, Egypt';
  bool _isUsingGps = false;

  void _openLocationSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _LocationSheet(
        currentLocation: _location,
        isUsingGps: _isUsingGps,
        primary: widget.primary,
        fg: widget.fg,
        card: widget.card,
        muted: widget.muted,
        border: widget.border,
        onGpsSelected: () {
          setState(() { _location = 'Current location (GPS)'; _isUsingGps = true; });
        },
        onCustomSelected: (address) {
          setState(() { _location = address; _isUsingGps = false; });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openLocationSheet,
      child: Row(children: [
        Icon(_isUsingGps ? Icons.my_location_rounded : Icons.location_on,
            color: widget.primary, size: 18),
        const SizedBox(width: 6),
        Expanded(
          child: Text(_location,
            style: TextStyle(color: widget.fg, fontSize: 14, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis),
        ),
        Icon(Icons.keyboard_arrow_down_rounded, color: widget.primary, size: 20),
      ]),
    );
  }
}

class _LocationSheet extends StatefulWidget {
  final String currentLocation;
  final bool isUsingGps;
  final Color primary, fg, card, muted, border;
  final VoidCallback onGpsSelected;
  final void Function(String) onCustomSelected;

  const _LocationSheet({
    required this.currentLocation, required this.isUsingGps,
    required this.primary, required this.fg, required this.card,
    required this.muted, required this.border,
    required this.onGpsSelected, required this.onCustomSelected,
  });

  @override
  State<_LocationSheet> createState() => _LocationSheetState();
}

class _LocationSheetState extends State<_LocationSheet> {
  final _ctrl = TextEditingController();
  bool _loadingGps = false;

  final _suggestions = [
    'Cairo, Egypt', 'Giza, Egypt', 'Alexandria, Egypt',
    'Maadi, Cairo', 'Zamalek, Cairo', 'Heliopolis, Cairo',
    'Nasr City, Cairo', 'Dokki, Giza', '6th of October, Giza',
  ];

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _useGps() async {
    setState(() => _loadingGps = true);
    await Future.delayed(const Duration(seconds: 1)); // simulate GPS fetch
    if (!mounted) return;
    setState(() => _loadingGps = false);
    widget.onGpsSelected();
    Navigator.pop(context);
  }

  void _selectSuggestion(String s) {
    widget.onCustomSelected(s);
    Navigator.pop(context);
  }

  void _applyCustom() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    widget.onCustomSelected(text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, scrollCtrl) => Container(
        decoration: BoxDecoration(
          color: widget.card,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(children: [
          const SizedBox(height: 10),
          Container(width: 40, height: 4,
            decoration: BoxDecoration(color: widget.muted.withOpacity(0.3), borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Choose location', style: TextStyle(color: widget.fg, fontSize: 18, fontWeight: FontWeight.bold))),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: [
              // GPS button
              SizedBox(width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _loadingGps ? null : _useGps,
                  icon: _loadingGps
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.my_location_rounded, size: 18),
                  label: Text(_loadingGps ? 'Getting location…' : 'Use current location (GPS)',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.primary, foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                )),
              const SizedBox(height: 16),
              // Custom address
              Row(children: [
                Expanded(child: TextField(
                  controller: _ctrl,
                  style: TextStyle(color: widget.fg),
                  decoration: InputDecoration(
                    hintText: 'Enter address manually',
                    hintStyle: TextStyle(color: widget.muted),
                    prefixIcon: Icon(Icons.edit_location_outlined, color: widget.muted),
                    filled: true, fillColor: widget.card,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: widget.border)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: widget.border)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14)),
                )),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _applyCustom,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.primary, foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Apply', style: TextStyle(fontWeight: FontWeight.w600))),
              ]),
            ]),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(alignment: Alignment.centerLeft,
              child: Text('Quick select', style: TextStyle(color: widget.muted, fontSize: 12, fontWeight: FontWeight.w500)))),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              controller: scrollCtrl,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _suggestions.length,
              itemBuilder: (_, i) => ListTile(
                dense: true,
                leading: Icon(Icons.place_outlined, color: widget.primary, size: 20),
                title: Text(_suggestions[i], style: TextStyle(color: widget.fg, fontSize: 13)),
                trailing: widget.currentLocation == _suggestions[i]
                    ? Icon(Icons.check_rounded, color: widget.primary, size: 18) : null,
                onTap: () => _selectSuggestion(_suggestions[i]),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }
}
