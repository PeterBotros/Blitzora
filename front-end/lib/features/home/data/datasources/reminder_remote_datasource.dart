import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/reminder_model.dart';

abstract class ReminderRemoteDataSource {
  Future<List<ReminderModel>> getReminders();
  Future<ReminderModel> createReminder(ReminderModel reminder);
  Future<ReminderModel> updateReminder(String reminderId, Map<String, dynamic> data);
  Future<void> deleteReminder(String reminderId);
  Future<void> resetDailyTaken();
}

class ReminderRemoteDataSourceImpl implements ReminderRemoteDataSource {
  final ApiClient _apiClient;
  ReminderRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<ReminderModel>> getReminders() async {
    try {
      final response = await _apiClient.get(ApiConstants.reminders);
      final list = response.data as List<dynamic>;
      return list
          .map((e) => ReminderModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ReminderModel> createReminder(ReminderModel reminder) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.reminders,
        data: reminder.toCreateJson(),
      );
      return ReminderModel.fromJson(response.data as Map<String, dynamic>);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ReminderModel> updateReminder(
      String reminderId, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.put(
        '${ApiConstants.reminders}$reminderId',
        data: data,
      );
      return ReminderModel.fromJson(response.data as Map<String, dynamic>);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteReminder(String reminderId) async {
    try {
      await _apiClient.delete('${ApiConstants.reminders}$reminderId');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> resetDailyTaken() async {
    try {
      await _apiClient.post('${ApiConstants.reminders}reset-daily', data: {});
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
