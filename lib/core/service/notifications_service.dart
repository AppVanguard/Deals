import 'dart:convert';
import 'dart:developer';
import 'package:deals/features/notifications/data/models/notifications_model.dart';
import 'package:deals/core/utils/backend_endpoints.dart';
import 'http_client_service.dart';

class NotificationsService {
  final HttpClientService _http;

  NotificationsService({HttpClientService? http}) : _http = http ?? HttpClientService();

  /// GET /notifications/:userId?limit=20&offset=0
  /// Requires Bearer token in the header.
  Future<NotificationsModel> getNotifications({
    required String firebaseUid,
    required String token,
    required int limit,
    required int offset,
  }) async {
    final baseUrl = '${BackendEndpoints.notifications}/$firebaseUid';
    final queryParams = {
      'limit': limit.toString(),
      'offset': offset.toString(),
    };
    final url = Uri.parse(baseUrl).replace(queryParameters: queryParams);

    try {
      final response = await _http.get(
        url,
        headers: BackendEndpoints.authJsonHeaders(token),
      );

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        return NotificationsModel.fromJson(jsonMap);
      } else {
        log('Error fetching notifications: ${response.statusCode} ${response.body}');
        throw Exception('Failed to fetch notifications');
      }
    } catch (e) {
      log('getNotifications exception: $e');
      rethrow;
    }
  }

  /// PATCH /notifications/read
  /// Also requires Bearer token in the header.
  Future<void> markAsRead({
    required String firebaseUid,
    required List<String> notificationIds,
    required String token,
  }) async {
    log("userId in markAsRead: $firebaseUid");
    log("notificationIds in markAsRead: $notificationIds");
    final url = Uri.parse(BackendEndpoints.notificationsRead);
    try {
      final body = jsonEncode({
        BackendEndpoints.kFirebaseUid: firebaseUid,
        "notificationIds": notificationIds,
      });

      final response = await _http.patch(
        url,
        headers: BackendEndpoints.authJsonHeaders(token),
        body: body,
      );

      if (response.statusCode == 200) {
        log('Notifications marked as read successfully');
      } else {
        log('Error marking notifications as read: ${response.statusCode} ${response.body}');
        throw Exception('Failed to mark notifications as read');
      }
    } catch (e) {
      log('markAsRead exception: $e');
      rethrow;
    }
  }
}
