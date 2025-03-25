import 'dart:convert';
import 'dart:developer';
import 'package:deals/features/notifications/data/models/notification.dart';
import 'package:hive/hive.dart';
import 'notification_local.dart';

class NotificationsLocalDataSource {
  static const String boxName = 'notificationsBox';

  Future<Box<NotificationLocal>> _openBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<NotificationLocal>(boxName);
    }
    return Hive.box<NotificationLocal>(boxName);
  }

  /// Save or update a list of remote notifications for a user.
  Future<void> cacheNotifications(
      String userId, List<Notification> notifications) async {
    final box = await _openBox();
    final Map<String, NotificationLocal> batch = {};

    for (var n in notifications) {
      if (n.id == null) continue;
      final rawJson = jsonEncode(n.toJson());
      final local = NotificationLocal(
        notificationId: n.id!,
        userId: userId,
        read: n.read ?? false,
        createdAt: n.createdAt ?? DateTime.now(),
        rawJson: rawJson,
      );
      batch[n.id!] = local;
    }
    if (batch.isNotEmpty) {
      await box.putAll(batch);
    }
  }

  /// Retrieve all notifications for a given user.
  Future<List<Notification>> getCachedNotifications(String userId) async {
    final box = await _openBox();
    final records = box.values.where((n) => n.userId == userId).toList();
    final List<Notification> result = [];
    for (var local in records) {
      try {
        final map = jsonDecode(local.rawJson) as Map<String, dynamic>;
        final notif = Notification.fromJson(map);
        // Overwrite local fields with cached values
        notif.read = local.read;
        notif.createdAt = local.createdAt;
        result.add(notif);
      } catch (e) {
        log('Error decoding notification: $e');
      }
    }
    result.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    return result;
  }

  /// Mark specific notifications as read.
  Future<void> markLocalNotificationsRead({
    required String userId,
    required List<String> notificationIds,
  }) async {
    final box = await _openBox();
    for (var id in notificationIds) {
      final local = box.get(id);
      if (local != null && local.userId == userId) {
        local.read = true;
        await local.save();
      }
    }
  }
}
