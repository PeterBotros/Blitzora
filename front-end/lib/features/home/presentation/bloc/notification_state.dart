import 'package:equatable/equatable.dart';
import '../../domain/entities/notification_entity.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationsLoaded extends NotificationState {
  final List<NotificationEntity> notifications;
  const NotificationsLoaded(this.notifications);
  @override
  List<Object?> get props => [notifications];

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  NotificationsLoaded copyWith(List<NotificationEntity> updated) =>
      NotificationsLoaded(updated);
}

class NotificationError extends NotificationState {
  final String message;
  const NotificationError(this.message);
  @override
  List<Object?> get props => [message];
}
