import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jiffy/jiffy.dart';


class LocalNotification {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  LocalNotification() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin()
      ..resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

/*  sendNow(String title, String body, String payload) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'ticker',
      playSound: true,
      sound: RawResourceAndroidNotificationSound('slow_spring_board.mp3'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: payload);
  }*/

  Future setScheduledNotification(int hour, int minute, DateTime taskDate,
      int id, String title, String body) async {
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var scheduledNotificationDateTime = taskDate;
    var updateTime = Jiffy(scheduledNotificationDateTime)
        .add(hours: hour, minutes: minute); //
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max,
        playSound: true,vibrationPattern:vibrationPattern ,
        sound: RawResourceAndroidNotificationSound('slow_spring_board'),
        ticker: 'ticker',
        enableVibration: true,
        showWhen: true,

        priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(
        id, title, body, updateTime, platformChannelSpecifics,
        payload: "Default_Sound");

  }

  void deleteNotificationPlan(int id) {
    id = id - 1;
    flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<List<PendingNotificationRequest>> showNotificationPlans() async {
    var pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotificationRequests;
  }
}
