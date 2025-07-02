import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'logger.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel notificationChannel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);

Future<void> initializeNotifications() async {
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosInit = DarwinInitializationSettings();
  const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(notificationChannel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<NotificationSettings> requestPushPermission() {
  return FirebaseMessaging.instance.requestPermission();
}

Future<String?> getFcmToken() async {
  try {
    final token = await FirebaseMessaging.instance.getToken();
    appLog('FCM token -> $token');
    return token;
  } catch (e) {
    appLog('Error getting FCM token: $e');
    return null;
  }
}

Future<void> showFlutterNotification(RemoteMessage message) async {
  final notification = message.notification;
  if (notification == null) return;

  final details = NotificationDetails(
    android: AndroidNotificationDetails(
      notificationChannel.id,
      notificationChannel.name,
      channelDescription: notificationChannel.description,
      importance: Importance.high,
    ),
    iOS: const DarwinNotificationDetails(),
  );

  await flutterLocalNotificationsPlugin.show(
    notification.hashCode,
    notification.title,
    notification.body,
    details,
  );
}
