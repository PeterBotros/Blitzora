import '../../data/models/reminder_model.dart';

abstract class ReminderRepository {
  Future<List<ReminderModel>> getReminders();
  Future<ReminderModel> createReminder(ReminderModel reminder);
  Future<ReminderModel> updateReminder(String reminderId, Map<String, dynamic> data);
  Future<void> deleteReminder(String reminderId);
  Future<void> resetDailyTaken();
}
