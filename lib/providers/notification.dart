import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationProvider {
  static final NotificationProvider _instance = NotificationProvider();
  static NotificationProvider get instance => _instance;

  var _id = 0;
  final _flutterLocal = FlutterLocalNotificationsPlugin();
  var _hasPermission = false;

  Future<int> show(String title, String body, {
    int id = 0,
    bool playSound = false,
    int progress = 0,
    int maxProgress = 0,
    bool showProgress = false,
  }) async {
    var androidNotification = AndroidNotificationDetails(
      'trackme',
      'Track me',
      channelDescription: 'Track me channel',
      importance: Importance.defaultImportance,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      playSound: playSound,

      progress: progress,
      maxProgress: maxProgress,
      showProgress: showProgress,
    );
    var notificationDetails = NotificationDetails(android: androidNotification);
    if (id == 0) {
      _id++;
      id = _id;
    }
    await _flutterLocal.show(id, title, body, notificationDetails);
    return id;
  }

  Future<void> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await _flutterLocal
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      await _flutterLocal
          .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      _flutterLocal.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted = await androidImplementation?.requestPermission();
      _hasPermission = granted ?? false;
    }
  }
}
