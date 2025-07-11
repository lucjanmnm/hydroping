import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(settings);

    tz.initializeTimeZones();
  }

  static Future<void> scheduleSingleNotification({required int intervalHours}) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'hydroping_reminder',
      'HydroPing Reminders',
      channelDescription: 'Reminds you to drink water',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.cancelAll();

    final scheduledDate = tz.TZDateTime.now(tz.local).add(Duration(hours: intervalHours));

    await _notificationsPlugin.zonedSchedule(
      0,
      'HydroPing',
      'Time to drink a glass of water! 💧',
      scheduledDate,
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  static Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}
