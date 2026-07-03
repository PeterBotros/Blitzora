import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object?> get props => [];
}

class LoadNotificationsEvent extends NotificationEvent {
  const LoadNotificationsEvent();
}

class MarkNotificationReadEvent extends NotificationEvent {
  final String notificationId;
  const MarkNotificationReadEvent(this.notificationId);
  @override
  List<Object?> get props => [notificationId];
}

class DeleteNotificationEvent extends NotificationEvent {
  final String notificationId;
  const DeleteNotificationEvent(this.notificationId);
  @override
  List<Object?> get props => [notificationId];
}
