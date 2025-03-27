import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:deals/core/utils/backend_endpoints.dart';

class NotificationsPermissionService {
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
      final response = await http.post(
        url,
        headers: {
          ...BackendEndpoints.jsonHeaders,
          'Authorization': 'Bearer $authToken',
        },
        body: body,
      );
      if (response.statusCode == 200) {
        log('Notifications allowed successfully for user: $firebaseUid');
      } else {
        log('Failed to allow notifications: ${response.statusCode} ${response.body}');
        throw Exception('Failed to allow notifications');
      }
    } catch (e) {
      log('Exception in allowNotifications: $e');
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
      final response = await http.post(
        url,
        headers: {
          ...BackendEndpoints.jsonHeaders,
          'Authorization': 'Bearer $authToken',
        },
        body: body,
      );
      if (response.statusCode == 200) {
        log('Notifications prevented successfully for user: $firebaseUid');
      } else {
        log('Failed to prevent notifications: ${response.statusCode} ${response.body}');
        throw Exception('Failed to prevent notifications');
      }
    } catch (e) {
      log('Exception in preventNotifications: $e');
      rethrow;
    }
  }
}
