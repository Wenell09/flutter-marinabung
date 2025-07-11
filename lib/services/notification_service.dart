import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Asia/Jakarta"));
    const androidSetting = AndroidInitializationSettings("@mipmap/ic_launcher");
    const darwinSetting = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: androidSetting,
      iOS: darwinSetting,
    );
    debugPrint("notification initialized");
    await notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    String? body,
  }) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 7);

    // Jika sudah lewat jam 7 pagi hari ini, jadwalkan untuk besok
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    debugPrint("notification schedule active");
    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "MariNabung",
          "Daily Reminder",
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelScheduleNotif() async {
    await AndroidAlarmManager.cancel(1);
    await NotificationService().notificationsPlugin.cancel(1);
  }
}

void showNotificationCallback() {
  NotificationService().scheduleNotification(
    id: 1,
    title: "Ayo Menabung",
    body: "Mari menabung sekarang",
  );
}
