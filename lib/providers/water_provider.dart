import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class WaterProvider extends ChangeNotifier {
  int glassesToday = 0;
  int dailyGoal = 8;
  int reminderInterval = 2; 
  bool notificationsEnabled = true;
  List<int> history = List.filled(7, 0);
  final StorageService _storage = StorageService();

  WaterProvider() {
    loadData();
  }

  Future<void> loadData() async {
    glassesToday = await _storage.loadGlassesToday();
    dailyGoal = await _storage.loadDailyGoal();
    reminderInterval = await _storage.loadReminderInterval();
    notificationsEnabled = await _storage.loadNotificationsEnabled();
    history = await _storage.loadHistory();
    notifyListeners();
  }

  void addGlass() {
    if (glassesToday < dailyGoal) {
      glassesToday++;
      _storage.saveGlassesToday(glassesToday);
      NotificationService.scheduleSingleNotification(
        intervalHours: reminderInterval,
        enabled: notificationsEnabled,
      );
      notifyListeners();
    }
  }

  void setDailyGoal(int goal) {
    dailyGoal = goal;
    _storage.saveDailyGoal(goal);
    notifyListeners();
  }

  void setReminderInterval(int hours) {
    reminderInterval = hours;
    _storage.saveReminderInterval(hours);
    notifyListeners();
  }

  void setNotificationsEnabled(bool enabled) {
    notificationsEnabled = enabled;
    _storage.saveNotificationsEnabled(enabled);
    if (!enabled) {
      NotificationService.cancelAll();
    } else {
      NotificationService.scheduleSingleNotification(
        intervalHours: reminderInterval,
        enabled: notificationsEnabled,
      );
    }
    notifyListeners();
  }

  Future<void> resetDayIfNeeded() async {
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month}-${now.day}";
    final prefs = await _storage.loadHistory();

    history.insert(0, glassesToday);
    if (history.length > 7) history = history.sublist(0, 7);
    await _storage.saveHistory(history);
    glassesToday = 0;
    await _storage.saveGlassesToday(0);
    notifyListeners();
  }
}
