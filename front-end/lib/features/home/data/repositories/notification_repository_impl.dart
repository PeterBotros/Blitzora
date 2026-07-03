import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;
  NotificationRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    return await _remoteDataSource.getNotifications();
  }

  @override
  Future<NotificationEntity> markAsRead(String notificationId) async {
    return await _remoteDataSource.markAsRead(notificationId);
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    return await _remoteDataSource.deleteNotification(notificationId);
  }
}
