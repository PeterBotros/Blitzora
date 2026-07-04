import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reminder_model.dart';

abstract class ReminderLocalDataSource {
  Future<List<ReminderModel>> getReminders();
  Future<void> saveReminders(List<ReminderModel> reminders);
}

class ReminderLocalDataSourceImpl implements ReminderLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _cachedRemindersKey = 'CACHED_REMINDERS_KEY';

  ReminderLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<ReminderModel>> getReminders() async {
    final jsonString = sharedPreferences.getString(_cachedRemindersKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => ReminderModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return []; // Return empty list if no reminders are cached
  }

  @override
  Future<void> saveReminders(List<ReminderModel> reminders) async {
    final jsonString = jsonEncode(reminders.map((r) => r.toCreateJson()).toList());
    await sharedPreferences.setString(_cachedRemindersKey, jsonString);
  }
}
