import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:deals/main.dart'; // for flutterLocalNotificationsPlugin
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';

import 'logger.dart';

/// Initializes Firebase Messaging by requesting the user's permission and
/// ensuring the APNS token is available on iOS before fetching the FCM token.
///
/// Returns the FCM token if available, or `null` if it could not be retrieved.
Future<String?> initFirebaseMessaging({
  int attempts = 3,
  Duration retryDelay = const Duration(seconds: 1),
}) async {
  try {
    if (Platform.isIOS || Platform.isMacOS) {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      final androidImpl = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidImpl?.requestNotificationsPermission();
    } else {
      await FirebaseMessaging.instance.requestPermission();
    }
  } catch (e) {
    appLog('Error requesting notification permissions: $e');
  }

  if (Platform.isIOS || Platform.isMacOS) {
    for (var i = 0; i < attempts; i++) {
      try {
        final apns = await FirebaseMessaging.instance.getAPNSToken();
        if (apns != null) break;
      } on FirebaseException catch (e) {
        if (e.code != 'apns-token-not-set') {
          appLog('Error fetching APNS token: $e');
          break;
        }
      } catch (e) {
        appLog('Unexpected error getting APNS token: $e');
        break;
      }
      await Future.delayed(retryDelay);
    }
  }

  for (var i = 0; i < attempts; i++) {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) return token;
    } on FirebaseException catch (e) {
      if (e.code == 'apns-token-not-set') {
        await Future.delayed(retryDelay);
        continue;
      }
      appLog('Error getting FCM token: $e');
      return null;
    } catch (e) {
      appLog('Unexpected error getting FCM token: $e');
      return null;
    }
  }

  return null;
}
