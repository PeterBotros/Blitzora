import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../../../core/services/notification_service.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _repository;
  final NotificationService _notificationService;
  Timer? _pollingTimer;

  NotificationBloc(this._repository, this._notificationService)
      : super(NotificationInitial()) {
    on<LoadNotificationsEvent>(_onLoad);
    on<MarkNotificationReadEvent>(_onMarkRead);
    on<DeleteNotificationEvent>(_onDelete);

    _startPolling();
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      add(const LoadNotificationsEvent());
    });
  }

  Future<void> _onLoad(
      LoadNotificationsEvent event, Emitter<NotificationState> emit) async {
    final current = state;
    if (current is! NotificationsLoaded) {
      emit(NotificationLoading());
    }
    try {
      final notifications = await _repository.getNotifications();

      // If we already had notifications loaded, find new ones to show a local push notification
      if (current is NotificationsLoaded) {
        final existingIds = current.notifications.map((n) => n.id).toSet();
        for (final n in notifications) {
          if (!n.isRead && !existingIds.contains(n.id)) {
            // New unread notification! Show local push notification
            _notificationService.showNotification(
              id: n.id.hashCode,
              title: n.title,
              body: n.content,
            );
          }
        }
      }

      emit(NotificationsLoaded(notifications));
    } catch (e) {
      if (state is! NotificationsLoaded) {
        emit(NotificationError(e.toString()));
      }
    }
  }

  Future<void> _onMarkRead(
      MarkNotificationReadEvent event, Emitter<NotificationState> emit) async {
    if (state is! NotificationsLoaded) return;
    final current = (state as NotificationsLoaded).notifications;
    try {
      final updated = await _repository.markAsRead(event.notificationId);
      final newList = current
          .map((n) => n.id == updated.id ? updated : n)
          .toList();
      emit(NotificationsLoaded(newList));
    } catch (e) {
      emit(NotificationError(e.toString()));
      // Restore the previous state after error
      emit(NotificationsLoaded(current));
    }
  }

  Future<void> _onDelete(
      DeleteNotificationEvent event, Emitter<NotificationState> emit) async {
    if (state is! NotificationsLoaded) return;
    final current = (state as NotificationsLoaded).notifications;
    // Optimistically remove
    final optimistic =
        current.where((n) => n.id != event.notificationId).toList();
    emit(NotificationsLoaded(optimistic));
    try {
      await _repository.deleteNotification(event.notificationId);
    } catch (e) {
      // Roll back on failure
      emit(NotificationsLoaded(current));
      emit(NotificationError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}
