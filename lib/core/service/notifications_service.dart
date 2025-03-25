import 'dart:convert';
import 'dart:developer';
import 'package:deals/features/notifications/data/models/notifications_model.dart';
import 'package:http/http.dart' as http;
import 'package:deals/core/utils/backend_endpoints.dart';

class NotificationsService {
  Future<NotificationsModel> getNotifications(String userId) async {
    final url = Uri.parse('${BackendEndpoints.notifications}/$userId');
    try {
      final response =
          await http.get(url, headers: BackendEndpoints.jsonHeaders);
      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        return NotificationsModel.fromJson(jsonMap);
      } else {
        log('Error: ${response.statusCode} ${response.body}');
        throw Exception('Failed to fetch notifications');
      }
    } catch (e) {
      log('getNotifications exception: $e');
      rethrow;
    }
  }

  Future<void> markAsRead({
    required String userId,
    required List<String> notificationIds,
  }) async {
    final url = Uri.parse(BackendEndpoints.notificationsRead);
    try {
      final body = jsonEncode({
        "userId": userId,
        "notificationIds": notificationIds,
      });
      final response = await http.patch(url,
          headers: BackendEndpoints.jsonHeaders, body: body);
      if (response.statusCode == 200) {
        log('Notifications marked as read');
      } else {
        log('Error marking as read: ${response.statusCode} ${response.body}');
        throw Exception('Failed to mark notifications as read');
      }
    } catch (e) {
      log('markAsRead exception: $e');
      rethrow;
    }
  }
}
