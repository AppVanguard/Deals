import 'package:firebase_messaging/firebase_messaging.dart';
import 'logger.dart';

/// Fetches the current FCM token after permissions have been granted.
/// Returns `null` if the token could not be retrieved.
Future<String?> initFirebaseMessaging() async {
  try {
    final token = await FirebaseMessaging.instance.getToken();
    appLog('initFirebaseMessaging: token -> $token');
    return token;
  } catch (e) {
    appLog('initFirebaseMessaging: error getting token $e');
    return null;
  }
}
