import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/reminder_model.dart';
import '../bloc/reminder_bloc.dart';
import '../bloc/reminder_event.dart';
import '../bloc/reminder_state.dart';

class PillReminderPage extends StatefulWidget {
  const PillReminderPage({super.key});

  @override
  State<PillReminderPage> createState() => _PillReminderPageState();
}

class _PillReminderPageState extends State<PillReminderPage> {
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  late int _selectedDayIndex;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // Show a 7-day strip ending today
    _selectedDayIndex = now.weekday - 1; // Mon=0 … Sun=6
    context.read<ReminderBloc>().add(const LoadRemindersEvent());
  }

  // ─── Add Reminder Bottom Sheet ────────────────────────────────────────────
  void _showAddSheet(BuildContext parentCtx) {
    final nameController = TextEditingController();
    final dosageController = TextEditingController();
    String selectedTime = '08:00 AM';
    IconData selectedIcon = Icons.medication_rounded;

    showModalBottomSheet(
      context: parentCtx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
            return Container(
              decoration: BoxDecoration(
                color: card,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.fromLTRB(
                  20, 24, 20, MediaQuery.of(context).viewInsets.bottom + 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Add Medication Reminder',
                          style: TextStyle(
                              color: fg,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(Icons.close, color: muted),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Medicine name
                  _sheetLabel('Medicine Name', fg),
                  const SizedBox(height: 6),
                  _sheetTextField(nameController, 'e.g., Panadol, Lipitor', fg,
                      bg, border),
                  const SizedBox(height: 16),

                  // Dosage + Time row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sheetLabel('Dosage', fg),
                            const SizedBox(height: 6),
                            _sheetTextField(dosageController,
                                'e.g., 1 pill, 5ml', fg, bg, border),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sheetLabel('Dose Time', fg),
                            const SizedBox(height: 6),
                            _timePicker(
                              selectedTime,
                              primary,
                              fg,
                              bg,
                              border,
                              (t) => setSheetState(() => selectedTime = t),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Icon selector
                  _sheetLabel('Icon type', fg),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icons.medication_rounded,
                      Icons.water_drop_rounded,
                      Icons.healing_rounded,
                      Icons.local_pharmacy_rounded,
                    ]
                        .map((ic) => _iconSelectButton(
                              ic,
                              selectedIcon,
                              (chosen) =>
                                  setSheetState(() => selectedIcon = chosen),
                              primary,
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 28),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final name = nameController.text.trim();
                        if (name.isEmpty) return;
                        final newReminder = ReminderModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          userId: '',
                          name: name,
                          dosage: dosageController.text.trim().isEmpty
                              ? '1 dose'
                              : dosageController.text.trim(),
                          time: selectedTime,
                          isTaken: false,
                          iconType: ReminderModel.getIconType(selectedIcon),
                        );
                        parentCtx
                            .read<ReminderBloc>()
                            .add(AddReminderEvent(newReminder));
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusSm)),
                      ),
                      child: const Text('Add Reminder',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold)),
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

  Widget _sheetLabel(String text, Color fg) => Text(text,
      style:
          TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600));

  Widget _sheetTextField(TextEditingController ctrl, String hint, Color fg,
      Color bg, Color border) {
    return TextField(
      controller: ctrl,
      style: TextStyle(color: fg),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: fg.withOpacity(0.4)),
        filled: true,
        fillColor: bg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
      ),
    );
  }

  Widget _timePicker(String selected, Color primary, Color fg, Color bg,
      Color border, Function(String) onChanged) {
    final times = [
      '06:00 AM', '08:00 AM', '10:00 AM', '12:00 PM',
      '02:00 PM', '04:00 PM', '06:00 PM', '08:00 PM', '10:00 PM',
    ];
    return InkWell(
      onTap: () async {
        showModalBottomSheet(
          context: context,
          builder: (_) => ListView.builder(
            itemCount: times.length,
            itemBuilder: (_, i) => ListTile(
              title: Text(times[i]),
              trailing: times[i] == selected
                  ? Icon(Icons.check, color: primary)
                  : null,
              onTap: () {
                onChanged(times[i]);
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(selected,
                style: TextStyle(
                    color: fg, fontSize: 13, fontWeight: FontWeight.w500)),
            Icon(Icons.access_time_rounded, color: primary, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _iconSelectButton(
      IconData icon, IconData activeIcon, Function(IconData) onTap, Color primary) {
    final active = icon == activeIcon;
    return GestureDetector(
      onTap: () => onTap(icon),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: active ? primary.withOpacity(0.15) : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
              color: active ? primary : Colors.grey.withOpacity(0.3),
              width: 1.5),
        ),
        child: Icon(icon, color: active ? primary : Colors.grey, size: 26),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final primary = AppColors.primary(dark);
    final bg = AppColors.background(dark);
    final card = AppColors.card(dark);
    final fg = AppColors.fg(dark);
    final muted = AppColors.muted(dark);
    final border = AppColors.border(dark);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: Text('Pill Organizer',
            style: TextStyle(
                color: fg, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 4,
        onPressed: () => _showAddSheet(context),
        child: const Icon(Icons.add_rounded),
      ),
      body: BlocConsumer<ReminderBloc, ReminderState>(
        listener: (context, state) {
          if (state is ReminderOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green.shade600,
              duration: const Duration(seconds: 2),
            ));
          } else if (state is ReminderError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade600,
              duration: const Duration(seconds: 3),
            ));
          }
        },
        builder: (context, state) {
          if (state is ReminderLoading || state is ReminderInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          final reminders = _extractReminders(state);

          final takenCount = reminders.where((r) => r.isTaken).length;
          final progress =
              reminders.isEmpty ? 1.0 : takenCount / reminders.length;

          return SafeArea(
            child: Column(
              children: [
                // ── Calendar strip ──────────────────────────────────────
                _buildCalendarStrip(primary, card, fg, muted, border),
                const SizedBox(height: 12),

                // ── Progress card ───────────────────────────────────────
                _buildProgressCard(primary, card, fg, muted, border,
                    takenCount, reminders.length, progress),
                const SizedBox(height: 16),

                // ── Section title ───────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text("Today's Medications",
                          style: TextStyle(
                              color: fg,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Text('${reminders.length} total',
                          style: TextStyle(color: muted, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // ── Medication list ─────────────────────────────────────
                Expanded(
                  child: reminders.isEmpty
                      ? _buildEmptyState(primary, fg, muted)
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                          itemCount: reminders.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (ctx2, index) {
                            final dose = reminders[index];
                            return _buildReminderCard(ctx2, dose, primary,
                                card, fg, muted, border);
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<ReminderModel> _extractReminders(ReminderState state) {
    if (state is RemindersLoaded) return state.reminders;
    if (state is ReminderOperationSuccess) return state.reminders;
    if (state is ReminderError) return [];
    return [];
  }

  Widget _buildCalendarStrip(Color primary, Color card, Color fg, Color muted,
      Color border) {
    final now = DateTime.now();
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final active = index == _selectedDayIndex;
          // Calculate the actual calendar day of the week
          final dayDateTime = now.subtract(Duration(days: now.weekday - 1 - index));
          final dayNum = dayDateTime.day;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDayIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 50,
              decoration: BoxDecoration(
                color: active ? primary : card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: active ? primary : border),
                boxShadow: active
                    ? [
                        BoxShadow(
                            color: primary.withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4))
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_days[index],
                      style: TextStyle(
                          color: active ? Colors.white : muted,
                          fontSize: 11,
                          fontWeight:
                              active ? FontWeight.bold : FontWeight.normal)),
                  const SizedBox(height: 4),
                  Text('$dayNum',
                      style: TextStyle(
                          color: active ? Colors.white : fg,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressCard(Color primary, Color card, Color fg, Color muted,
      Color border, int taken, int total, double progress) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
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
                  Text('Daily Progress',
                      style: TextStyle(
                          color: fg,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text('$taken of $total doses taken',
                      style: TextStyle(color: muted, fontSize: 12)),
                ],
              ),
              Text('${(progress * 100).toInt()}%',
                  style: TextStyle(
                      color: primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: border,
              valueColor: AlwaysStoppedAnimation<Color>(primary),
            ),
          ),
          if (total > 0 && progress == 1.0) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.star_rounded, color: Colors.amber.shade400, size: 16),
                const SizedBox(width: 6),
                Text('All doses completed for today!',
                    style: TextStyle(
                        color: fg,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReminderCard(BuildContext ctx, ReminderModel dose, Color primary,
      Color card, Color fg, Color muted, Color border) {
    return Dismissible(
      key: ValueKey(dose.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 26),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: ctx,
          builder: (dCtx) => AlertDialog(
            title: const Text('Delete Reminder'),
            content: Text('Delete "${dose.name}"?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(dCtx, false),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () => Navigator.pop(dCtx, true),
                  style:
                      TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Delete')),
            ],
          ),
        );
      },
      onDismissed: (_) {
        ctx.read<ReminderBloc>().add(DeleteReminderEvent(dose.id));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: dose.isTaken
              ? Colors.green.withOpacity(0.06)
              : card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: dose.isTaken
                  ? Colors.green.withOpacity(0.3)
                  : border),
        ),
        child: Row(
          children: [
            // Icon bubble
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: (dose.isTaken ? Colors.green : primary).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                dose.getIconData(),
                color: dose.isTaken ? Colors.green.shade500 : primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Name + dosage + time
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
                      decoration:
                          dose.isTaken ? TextDecoration.lineThrough : null,
                      decorationColor: muted,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(Icons.medication_liquid_rounded,
                          color: muted, size: 12),
                      const SizedBox(width: 4),
                      Text(dose.dosage,
                          style: TextStyle(
                              color: muted,
                              fontSize: 12,
                              decoration: dose.isTaken
                                  ? TextDecoration.lineThrough
                                  : null)),
                      const SizedBox(width: 10),
                      Icon(Icons.access_time_rounded, color: muted, size: 12),
                      const SizedBox(width: 4),
                      Text(dose.time,
                          style: TextStyle(color: muted, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),

            // Checkbox
            Transform.scale(
              scale: 1.1,
              child: Checkbox(
                value: dose.isTaken,
                activeColor: Colors.green.shade500,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                onChanged: (val) {
                  ctx.read<ReminderBloc>().add(
                      ToggleReminderTakenEvent(dose.id, val ?? false));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color primary, Color fg, Color muted) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.medication_rounded, color: primary, size: 40),
          ),
          const SizedBox(height: 16),
          Text('No reminders yet',
              style: TextStyle(
                  color: fg, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text('Tap + to add your first medication reminder',
              style: TextStyle(color: muted, fontSize: 13),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
