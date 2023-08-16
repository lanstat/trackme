import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationProvider {
  static final NotificationProvider _instance = NotificationProvider();
  static NotificationProvider get instance => _instance;

  var _id = 0;
  final _flutterLocal = FlutterLocalNotificationsPlugin();
  var _hasPermission = false;

  Future<void> show(String title, String body) async {
    const androidNotification = AndroidNotificationDetails(
      'trackme',
      'Track me',
      channelDescription: 'Track me channel',
      importance: Importance.defaultImportance,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher'
    );
    const notificationDetails = NotificationDetails(android: androidNotification);
    _id++;
    await _flutterLocal.show(_id, title, body, notificationDetails);
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
