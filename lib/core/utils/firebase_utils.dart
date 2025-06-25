import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

import 'logger.dart';

/// Safely fetches the current FCM token.
///
/// If the APNS token has not been set yet on iOS, this will attempt to
/// retrieve it before retrying to obtain the FCM token.
Future<String?> fetchFcmTokenSafely({
  int attempts = 3,
  Duration retryDelay = const Duration(seconds: 1),
}) async {
  // Delegate to the more robust initialization helper. This keeps existing
  // callers working while ensuring APNS handling and permission requests
  // are properly executed on all platforms.
  return initFirebaseMessaging(
    attempts: attempts,
    retryDelay: retryDelay,
  );
}

/// Initializes Firebase Messaging by requesting the user's permission and
/// ensuring the APNS token is available on iOS before fetching the FCM token.
///
/// Returns the FCM token if available, or `null` if it could not be retrieved.
Future<String?> initFirebaseMessaging({
  int attempts = 3,
  Duration retryDelay = const Duration(seconds: 1),
}) async {
  await FirebaseMessaging.instance.requestPermission();

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
