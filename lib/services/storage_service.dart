import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String glassesTodayKey = 'glasses_today';
  static const String dailyGoalKey = 'daily_goal';
  static const String reminderIntervalKey = 'reminder_interval';

  Future<int> loadGlassesToday() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(glassesTodayKey) ?? 0;
  }

  Future<void> saveGlassesToday(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(glassesTodayKey, count);
  }

  Future<int> loadDailyGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(dailyGoalKey) ?? 8;
  }

  Future<void> saveDailyGoal(int goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(dailyGoalKey, goal);
  }

  Future<int> loadReminderInterval() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(reminderIntervalKey) ?? 2;
  }

  Future<void> saveReminderInterval(int hours) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(reminderIntervalKey, hours);
  }
}
