import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todoapp/models/task.dart';

import '../ui/pages/notification_screen.dart';

class NotificationServices {
  static FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static BehaviorSubject<String> selectedNotification =
      BehaviorSubject<String>();
  static onTap(NotificationResponse details) {
    selectedNotification.add('${details.payload}');
    _onSelectedNotification();
  }

  static Future init() async {
    _onSelectedNotification();
    InitializationSettings settings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    notificationsPlugin.initialize(
      settings,
      onDidReceiveBackgroundNotificationResponse: onTap,
      onDidReceiveNotificationResponse: onTap,
    );
  }

  //basic notifications
  static void basicNotification({required Task task}) async {
    NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails('id 1', 'basic notification',
          importance: Importance.max,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound(
              'milestone_ios_17.mp3'.split('.').first)),
      iOS: const DarwinNotificationDetails(),
    );
    await notificationsPlugin
        .show(
      task.id!,
      task.title,
      task.note,
      details,
      payload: '${task.title}|${task.note}|${task.startTime}|',
    )
        .then((value) {
      print('Basic Notification Sent');
    });
  }

  //scheduled notifications
  static void showScheduledNotification({
    required DateTime currentDate,
    required TimeOfDay scheduledTime,
    required Task task,
  }) async {
    AndroidNotificationDetails android = AndroidNotificationDetails(
      'scheduled channel id',
      'scheduled channel name',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound(
          'milestone_ios_17.mp3'.split('.').first),
    );
    NotificationDetails details = NotificationDetails(
      android: android,
    );
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    tz.TZDateTime scheduledDateTime = tz.TZDateTime(
      tz.local,
      currentDate.year,
      currentDate.month,
      currentDate.day,
      scheduledTime.hour,
      scheduledTime.minute,
    );
    scheduledDateTime = afterRemind(task.remind, scheduledDateTime);
    await notificationsPlugin.zonedSchedule(
        2, task.title, task.note, scheduledDateTime, details,
        payload: '${task.title}|${task.note}|${task.startTime}|',
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  static tz.TZDateTime afterRemind(int remind, tz.TZDateTime scheduledDate) {
    switch (remind) {
      case 5:
        scheduledDate = scheduledDate.subtract(const Duration(minutes: 5));
        break;
      case 10:
        scheduledDate = scheduledDate.subtract(const Duration(minutes: 10));
        break;
      case 15:
        scheduledDate = scheduledDate.subtract(const Duration(minutes: 15));
        break;
      case 20:
        scheduledDate = scheduledDate.subtract(const Duration(minutes: 20));
        break;
      default:
        scheduledDate = scheduledDate.subtract(const Duration(minutes: 5));
        break;
    }
    print('scheduledDate $scheduledDate');
    return scheduledDate;
  }

// cancel notification by id
  static void cancelNotification({required int id}) async {
    await notificationsPlugin.cancel(id).then((value) {
      print('Notification Cancelled');
    });
  }

  // cancel all notifications
  static void cancelAllNotifications() async {
    await notificationsPlugin.cancelAll().then((value) {
      print('All Notifications Cancelled');
    });
  }

  static void _onSelectedNotification() {
    selectedNotification.stream.listen((String payload) async {
      Get.to(() => NotificationScreen(payload: payload));
    });
  }
}
