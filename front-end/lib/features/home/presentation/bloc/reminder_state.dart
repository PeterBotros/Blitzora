import 'package:equatable/equatable.dart';
import '../../data/models/reminder_model.dart';

abstract class ReminderState extends Equatable {
  const ReminderState();
  @override
  List<Object?> get props => [];
}

class ReminderInitial extends ReminderState {}

class ReminderLoading extends ReminderState {}

class RemindersLoaded extends ReminderState {
  final List<ReminderModel> reminders;
  const RemindersLoaded(this.reminders);
  @override
  List<Object?> get props => [reminders];

  int get takenCount => reminders.where((r) => r.isTaken).length;
  double get progressPercentage =>
      reminders.isEmpty ? 1.0 : takenCount / reminders.length;
}

class ReminderError extends ReminderState {
  final String message;
  const ReminderError(this.message);
  @override
  List<Object?> get props => [message];
}

class ReminderOperationSuccess extends ReminderState {
  final List<ReminderModel> reminders;
  final String message;
  const ReminderOperationSuccess(this.reminders, this.message);
  @override
  List<Object?> get props => [reminders, message];
}
