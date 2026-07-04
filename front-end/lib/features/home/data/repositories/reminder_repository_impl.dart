import '../../data/datasources/reminder_remote_datasource.dart';
import '../../data/models/reminder_model.dart';
import '../../domain/repositories/reminder_repository.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  final ReminderRemoteDataSource _remoteDataSource;

  ReminderRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<ReminderModel>> getReminders() =>
      _remoteDataSource.getReminders();

  @override
  Future<ReminderModel> createReminder(ReminderModel reminder) =>
      _remoteDataSource.createReminder(reminder);

  @override
  Future<ReminderModel> updateReminder(
          String reminderId, Map<String, dynamic> data) =>
      _remoteDataSource.updateReminder(reminderId, data);

  @override
  Future<void> deleteReminder(String reminderId) =>
      _remoteDataSource.deleteReminder(reminderId);

  @override
  Future<void> resetDailyTaken() => _remoteDataSource.resetDailyTaken();
}
