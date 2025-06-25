import 'package:firebase_messaging/firebase_messaging.dart';

import 'logger.dart';

/// Safely fetches the current FCM token.
///
/// If the APNS token has not been set yet on iOS, this will attempt to
/// retrieve it before retrying to obtain the FCM token.
Future<String?> fetchFcmTokenSafely() async {
  try {
    return await FirebaseMessaging.instance.getToken();
  } on FirebaseException catch (e) {
    appLog('Error getting FCM token: $e');
    try {
      await FirebaseMessaging.instance.getAPNSToken();
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      appLog('Retrying FCM token failed: $e');
      return null;
    }
  } catch (e) {
    appLog('Unexpected error getting FCM token: $e');
    return null;
  }
}
