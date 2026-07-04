import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/reminder_model.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../../../../core/services/notification_service.dart';
import 'reminder_event.dart';
import 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final ReminderRepository _repository;
  final NotificationService _notificationService;

  ReminderBloc(this._repository, this._notificationService)
      : super(ReminderInitial()) {
    on<LoadRemindersEvent>(_onLoad);
    on<AddReminderEvent>(_onAdd);
    on<ToggleReminderTakenEvent>(_onToggleTaken);
    on<DeleteReminderEvent>(_onDelete);
    on<ResetDailyRemindersEvent>(_onResetDaily);
  }

  Future<void> _onLoad(
      LoadRemindersEvent event, Emitter<ReminderState> emit) async {
    emit(ReminderLoading());
    try {
      final reminders = await _repository.getReminders();
      emit(RemindersLoaded(reminders));
      await _scheduleNotifications(reminders);
    } catch (e) {
      emit(ReminderError(e.toString()));
    }
  }

  Future<void> _onAdd(
      AddReminderEvent event, Emitter<ReminderState> emit) async {
    final current = _currentReminders();
    // Optimistic update: show the new item immediately
    final optimistic = <ReminderModel>[...current, event.reminder];
    emit(RemindersLoaded(optimistic));
    try {
      final created = await _repository.createReminder(event.reminder);
      // Replace temporary optimistic entry with the real server response
      final updated = <ReminderModel>[...current, created];
      emit(ReminderOperationSuccess(updated, 'Reminder added!'));
      await _scheduleNotifications(updated);
    } catch (e) {
      emit(RemindersLoaded(current));
      emit(ReminderError('Failed to add reminder: ${e.toString()}'));
    }
  }

  Future<void> _onToggleTaken(
      ToggleReminderTakenEvent event, Emitter<ReminderState> emit) async {
    final current = _currentReminders();
    // Optimistic update for immediate UI feedback
    final optimistic = current
        .map((r) => r.id == event.reminderId
            ? r.copyWith(isTaken: event.isTaken)
            : r)
        .toList();
    emit(RemindersLoaded(optimistic));
    try {
      final updated =
          await _repository.updateReminder(event.reminderId, {'is_taken': event.isTaken});
      final finalList = current
          .map((r) => r.id == event.reminderId ? updated : r)
          .toList();
      final message = event.isTaken ? '✓ Dose logged!' : 'Dose marked as not taken.';
      emit(ReminderOperationSuccess(finalList, message));
      await _scheduleNotifications(finalList);
    } catch (e) {
      // Roll back on failure
      emit(RemindersLoaded(current));
      emit(ReminderError('Failed to update reminder: ${e.toString()}'));
    }
  }

  Future<void> _onDelete(
      DeleteReminderEvent event, Emitter<ReminderState> emit) async {
    final current = _currentReminders();
    // Optimistic remove
    final optimistic =
        current.where((r) => r.id != event.reminderId).toList();
    emit(RemindersLoaded(optimistic));
    try {
      await _repository.deleteReminder(event.reminderId);
      emit(ReminderOperationSuccess(optimistic, 'Reminder deleted.'));
      await _scheduleNotifications(optimistic);
    } catch (e) {
      // Roll back on failure
      emit(RemindersLoaded(current));
      emit(ReminderError('Failed to delete reminder: ${e.toString()}'));
    }
  }

  Future<void> _onResetDaily(
      ResetDailyRemindersEvent event, Emitter<ReminderState> emit) async {
    try {
      await _repository.resetDailyTaken();
      add(const LoadRemindersEvent());
    } catch (_) {}
  }

  /// Schedules local push notifications for all untaken reminders
  Future<void> _scheduleNotifications(List<ReminderModel> reminders) async {
    await _notificationService.cancelAllNotifications();
    for (final dose in reminders) {
      if (!dose.isTaken) {
        await _notificationService.scheduleDailyNotification(
          id: dose.id.hashCode,
          title: 'Time for your medicine!',
          body: 'Take ${dose.dosage} of ${dose.name}',
          timeString: dose.time,
        );
      }
    }
  }

  List<ReminderModel> _currentReminders() {
    final s = state;
    if (s is RemindersLoaded) return List<ReminderModel>.from(s.reminders);
    if (s is ReminderOperationSuccess) return List<ReminderModel>.from(s.reminders);
    return <ReminderModel>[];
  }
}
