import 'package:firebase_messaging/firebase_messaging.dart';

import 'logger.dart';

/// Safely fetches the current FCM token.
///
/// If the APNS token has not been set yet on iOS, this will attempt to
/// retrieve it before retrying to obtain the FCM token.
Future<String?> fetchFcmTokenSafely({
  int attempts = 3,
  Duration retryDelay = const Duration(seconds: 1),
}) async {
  for (var i = 0; i < attempts; i++) {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) return token;
    } on FirebaseException catch (e) {
      // If the APNS token hasn't been set yet on iOS, try fetching it and
      // retry after a short delay.
      if (e.code == 'apns-token-not-set') {
        appLog('APNS token not set, retrying...');
        try {
          await FirebaseMessaging.instance.getAPNSToken();
        } catch (e) {
          appLog('Fetching APNS token failed: $e');
        }
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
