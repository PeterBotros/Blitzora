import '../../domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotifications();
  Future<NotificationEntity> markAsRead(String notificationId);
  Future<void> deleteNotification(String notificationId);
}
