import 'package:equatable/equatable.dart';
import '../../data/models/reminder_model.dart';

abstract class ReminderEvent extends Equatable {
  const ReminderEvent();
  @override
  List<Object?> get props => [];
}

class LoadRemindersEvent extends ReminderEvent {
  const LoadRemindersEvent();
}

class AddReminderEvent extends ReminderEvent {
  final ReminderModel reminder;
  const AddReminderEvent(this.reminder);
  @override
  List<Object?> get props => [reminder];
}

class ToggleReminderTakenEvent extends ReminderEvent {
  final String reminderId;
  final bool isTaken;
  const ToggleReminderTakenEvent(this.reminderId, this.isTaken);
  @override
  List<Object?> get props => [reminderId, isTaken];
}

class DeleteReminderEvent extends ReminderEvent {
  final String reminderId;
  const DeleteReminderEvent(this.reminderId);
  @override
  List<Object?> get props => [reminderId];
}

class ResetDailyRemindersEvent extends ReminderEvent {
  const ResetDailyRemindersEvent();
}
