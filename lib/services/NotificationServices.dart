// ignore_for_file: file_names
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:perpustakaan_mobile/utils/log_utils.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationServices {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('launch_background');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notifications.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            ((NotificationResponse notificationResponse) {
      log("details", v: notificationResponse);
    }));

    log("initt notif.....");
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(id, title, body, await _notificationDetails(),
          payload: payload);

  static Future scheduleNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.zonedSchedule(id, title, body,
          _scheduleDaily(const Time(8)), await _notificationDetails(),
          payload: payload,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time);

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channel id', 'channel name',
          importance: Importance.max),
    );
  }

  static tz.TZDateTime _scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute, time.second);

    return scheduleDate.isBefore(now)
        ? scheduleDate.add(const Duration(days: 1))
        : scheduleDate;
  }

  static removeNotification(int id) {
    _notifications.cancel(id);
  }
}
