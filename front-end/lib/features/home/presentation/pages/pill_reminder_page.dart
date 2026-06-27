import 'package:flutter/material.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class MedicationDose {
  final String id;
  final String name;
  final String dosage;
  final String time;
  bool isTaken;
  final IconData icon;

  MedicationDose({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.isTaken,
    required this.icon,
  });
}

class PillReminderPage extends StatefulWidget {
  const PillReminderPage({super.key});

  @override
  State<PillReminderPage> createState() => _PillReminderPageState();
}

class _PillReminderPageState extends State<PillReminderPage> {
  final List<MedicationDose> _doses = [
    MedicationDose(id: '1', name: 'Panadol Extra', dosage: '1 tablet', time: '08:00 AM', isTaken: true, icon: Icons.medication_rounded),
    MedicationDose(id: '2', name: 'Vitamin C Effervescent', dosage: '1 tablet ( dissolved )', time: '01:00 PM', isTaken: true, icon: Icons.water_drop_rounded),
    MedicationDose(id: '3', name: 'Lipitor (Cholesterol)', dosage: '10 mg tablet', time: '09:00 PM', isTaken: false, icon: Icons.healing_rounded),
  ];

  int get takenCount => _doses.where((d) => d.isTaken).length;
  double get progressPercentage => _doses.isEmpty ? 1.0 : takenCount / _doses.length;

  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final int _selectedDayIndex = 5; // Simulating Saturday, Jun 27, 2026

  void _addNewReminder() {
    final nameController = TextEditingController();
    final dosageController = TextEditingController();
    String selectedTime = '08:00 AM';
    IconData selectedIcon = Icons.medication_rounded;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final dark = Theme.of(ctx).brightness == Brightness.dark;
        final primary = AppColors.primary(dark);
        final bg = AppColors.background(dark);
        final card = AppColors.card(dark);
        final fg = AppColors.fg(dark);
        final muted = AppColors.muted(dark);
        final border = AppColors.border(dark);

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, MediaQuery.of(context).viewInsets.bottom + 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Add Medication Reminder', style: TextStyle(color: fg, fontSize: 16, fontWeight: FontWeight.bold)),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Medicine Name', style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: nameController,
                    style: TextStyle(color: fg),
                    decoration: const InputDecoration(hintText: 'e.g., Panadol, Lipitor'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Dosage', style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: dosageController,
                              style: TextStyle(color: fg),
                              decoration: const InputDecoration(hintText: 'e.g., 1 pill, 5ml'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Dose Time', style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: () {
                                // Simulate time picker selection
                                final times = ['08:00 AM', '12:00 PM', '04:00 PM', '08:00 PM', '10:00 PM'];
                                int currentIdx = times.indexOf(selectedTime);
                                int nextIdx = (currentIdx + 1) % times.length;
                                setSheetState(() {
                                  selectedTime = times[nextIdx];
                                });
                              },
                              child: Container(
                                height: 48,
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  color: AppColors.background(dark),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: border),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(selectedTime, style: TextStyle(color: fg, fontSize: 13, fontWeight: FontWeight.w500)),
                                    Icon(Icons.access_time_rounded, color: primary, size: 18),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('Icon type', style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _iconSelectButton(Icons.medication_rounded, selectedIcon, (ic) => setSheetState(() => selectedIcon = ic), primary),
                      _iconSelectButton(Icons.water_drop_rounded, selectedIcon, (ic) => setSheetState(() => selectedIcon = ic), primary),
                      _iconSelectButton(Icons.healing_rounded, selectedIcon, (ic) => setSheetState(() => selectedIcon = ic), primary),
                      _iconSelectButton(Icons.local_pharmacy_rounded, selectedIcon, (ic) => setSheetState(() => selectedIcon = ic), primary),
                    ],
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameController.text.trim().isEmpty) return;
                        setState(() {
                          _doses.add(MedicationDose(
                            id: DateTime.now().toString(),
                            name: nameController.text,
                            dosage: dosageController.text.isEmpty ? '1 dose' : dosageController.text,
                            time: selectedTime,
                            isTaken: false,
                            icon: selectedIcon,
                          ));
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Medication reminder added!'), backgroundColor: Colors.green),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusSm)),
                      ),
                      child: const Text('Add Reminder', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _iconSelectButton(IconData icon, IconData activeIcon, Function(IconData) onTap, Color primary) {
    final active = icon == activeIcon;
    return GestureDetector(
      onTap: () => onTap(icon),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: active ? primary.withOpacity(0.15) : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: active ? primary : Colors.transparent, width: 1.5),
        ),
        child: Icon(icon, color: active ? primary : Colors.grey, size: 24),
      ),
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
        title: Text('Pill Organizer', style: TextStyle(color: fg, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        onPressed: _addNewReminder,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Calendar strip
            Container(
              height: 90,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _days.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final active = index == _selectedDayIndex;
                  final dayNum = 22 + index; // Simulating dates Jun 22 to Jun 28
                  return Container(
                    width: 50,
                    decoration: BoxDecoration(
                      color: active ? primary : card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: active ? primary : border),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _days[index],
                          style: TextStyle(
                            color: active ? Colors.white : muted,
                            fontSize: 11,
                            fontWeight: active ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$dayNum',
                          style: TextStyle(
                            color: active ? Colors.white : fg,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            // Progress Header Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Daily Progress', style: TextStyle(color: fg, fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text('$takenCount of ${_doses.length} doses taken today', style: TextStyle(color: muted, fontSize: 12)),
                        ],
                      ),
                      Text(
                        '${(progressPercentage * 100).toInt()}%',
                        style: TextStyle(color: primary, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progressPercentage,
                      minHeight: 8,
                      backgroundColor: border,
                      valueColor: AlwaysStoppedAnimation<Color>(primary),
                    ),
                  ),
                  if (progressPercentage == 1.0) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber.shade400, size: 16),
                        const SizedBox(width: 6),
                        Text('Awesome! All doses completed for today.', style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Medication list
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                itemCount: _doses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final dose = _doses[index];
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: (dose.isTaken ? Colors.green : primary).withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            dose.icon,
                            color: dose.isTaken ? Colors.green.shade400 : primary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dose.name,
                                style: TextStyle(
                                  color: fg,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  decoration: dose.isTaken ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${dose.dosage} • ${dose.time}',
                                style: TextStyle(
                                  color: muted,
                                  fontSize: 12,
                                  decoration: dose.isTaken ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Checkbox(
                          value: dose.isTaken,
                          activeColor: Colors.green.shade400,
                          onChanged: (val) {
                            setState(() {
                              _doses[index].isTaken = val ?? false;
                            });
                            if (val == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Dose of ${dose.name} logged!'),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
