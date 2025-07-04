import 'dart:convert';
import 'package:deals/core/utils/logger.dart';
import 'package:deals/core/utils/backend_endpoints.dart';
import 'http_client_service.dart';

class NotificationsPermissionService {
  final HttpClientService _http;

  NotificationsPermissionService({HttpClientService? http})
      : _http = http ?? HttpClientService();

  /// Sends a request to allow notifications for the user.
  /// The backend expects:
  /// {
  ///   "userId": "...",
  ///   "token": "device_fcm_token"
  /// }
  Future<void> allowNotifications({
    required String firebaseUid,
    required String deviceToken,
    required String authToken,
  }) async {
    final url = Uri.parse(BackendEndpoints.notificationsAllow);
    final body = jsonEncode({
      BackendEndpoints.kFirebaseUid: firebaseUid,
      BackendEndpoints.kToken: deviceToken,
    });
    try {
      appLog('Allowing notifications for user: $firebaseUid with token: $deviceToken');
      final response = await _http.post(
        url,
        headers: {
          ...BackendEndpoints.authJsonHeaders(authToken),
        },
        body: body,
      );
      if (response.statusCode == 200) {
        appLog('Notifications allowed successfully for user: $firebaseUid');
      } else {
        appLog('Failed to allow notifications: ${response.statusCode} ${response.body}');
        throw Exception('Failed to allow notifications');
      }
    } catch (e) {
      appLog('Exception in allowNotifications: $e');
      rethrow;
    }
  }

  /// Sends a request to prevent notifications for the user.
  /// The backend expects:
  /// {
  ///   "userId": "..."
  /// }
  Future<void> preventNotifications({
    required String firebaseUid,
    required String authToken,
  }) async {
    final url = Uri.parse(BackendEndpoints.notificationsPrevent);
    final body = jsonEncode({
      BackendEndpoints.kFirebaseUid: firebaseUid,
    });
    try {
      final response = await _http.post(
        url,
        headers: {
          ...BackendEndpoints.authJsonHeaders(authToken),
        },
        body: body,
      );
      if (response.statusCode == 200) {
        appLog('Notifications prevented successfully for user: $firebaseUid');
      } else {
        appLog('Failed to prevent notifications: ${response.statusCode} ${response.body}');
        throw Exception('Failed to prevent notifications');
      }
    } catch (e) {
      appLog('Exception in preventNotifications: $e');
      rethrow;
    }
  }
}
