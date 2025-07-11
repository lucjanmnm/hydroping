import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@drawable/ic_stat_logo');
    const InitializationSettings settings = InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(settings);
    tz.initializeTimeZones();

    await requestNotificationPermission();
  }

  static Future<void> requestNotificationPermission() async {
    await Permission.notification.request();
  }

  static Future<void> scheduleSingleNotification({
    required int intervalHours,
    required bool enabled,
  }) async {
    await _notificationsPlugin.cancelAll();
    if (!enabled) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'hydroping_reminder',
      'HydroPing Reminders',
      channelDescription: 'Reminds you to drink water',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@drawable/ic_stat_logo', 
    );
    const NotificationDetails details = NotificationDetails(android: androidDetails);

    final scheduledDate = tz.TZDateTime.now(tz.local).add(Duration(hours: intervalHours));

    await _notificationsPlugin.zonedSchedule(
      0,
      'HydroPing',
      'Time to drink a glass of water! 💧',
      scheduledDate,
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  static Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}
