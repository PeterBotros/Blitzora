import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<NotificationModel> markAsRead(String notificationId);
  Future<void> deleteNotification(String notificationId);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient _apiClient;
  NotificationRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _apiClient.get(ApiConstants.notifications);
      final list = response.data as List<dynamic>;
      return list
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<NotificationModel> markAsRead(String notificationId) async {
    try {
      final response = await _apiClient.put(
        '${ApiConstants.notifications}$notificationId/read',
        data: {},
      );
      return NotificationModel.fromJson(response.data as Map<String, dynamic>);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _apiClient.delete('${ApiConstants.notifications}$notificationId');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
