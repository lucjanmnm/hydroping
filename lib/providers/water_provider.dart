import 'package:flutter/material.dart';
import 'package:hydroping/services/notification_service.dart';
import '../services/storage_service.dart';

class WaterProvider extends ChangeNotifier {
  int glassesToday = 0;
  int dailyGoal = 8;
  int reminderInterval = 2;
  final StorageService _storage = StorageService();

  WaterProvider() {
    loadData();
  }

  Future<void> loadData() async {
    glassesToday = await _storage.loadGlassesToday();
    dailyGoal = await _storage.loadDailyGoal();
    reminderInterval = await _storage.loadReminderInterval();
    notifyListeners();
  }

  void addGlass() {
    if (glassesToday < dailyGoal) {
      glassesToday++;
      _storage.saveGlassesToday(glassesToday);
      NotificationService.scheduleSingleNotification(intervalHours: reminderInterval);
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

  void reset() {
    glassesToday = 0;
    _storage.saveGlassesToday(0);
    notifyListeners();
  }
}
