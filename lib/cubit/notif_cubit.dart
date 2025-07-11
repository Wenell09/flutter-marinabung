import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_marinabung/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotifCubit extends Cubit<bool> {
  NotifCubit() : super(false);

  Future<void> loadNotifStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('notif_enabled') ?? false;
    debugPrint("status notification:$enabled");
    emit(enabled);
    if (enabled) {
      debugPrint("status notification activated");
      await NotificationService().scheduleNotification(
        id: 1,
        title: "Ayo Menabung",
        body: "Mari menabung sekarang",
      );
    }
  }

  Future<void> toggleNotification(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_enabled', isEnabled);
    emit(isEnabled);
    debugPrint("status notification:$isEnabled");
    if (isEnabled) {
      final now = DateTime.now();
      final target = DateTime(now.year, now.month, now.day, 7);
      final duration = target.isBefore(now)
          ? target.add(Duration(days: 1)).difference(now)
          : target.difference(now);
      debugPrint("status notification activated");
      await AndroidAlarmManager.periodic(
        const Duration(days: 1),
        1,
        showNotificationCallback,
        startAt: DateTime.now().add(duration),
        exact: true,
        wakeup: true,
      );
    } else {
      NotificationService().cancelScheduleNotif();
    }
  }
}
