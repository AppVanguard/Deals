import 'package:hive/hive.dart';

part 'notification_local.g.dart';

@HiveType(typeId: 0)
class NotificationLocal extends HiveObject {
  @HiveField(0)
  String notificationId; // backend's _id

  @HiveField(1)
  String userId;

  @HiveField(2)
  bool read;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  String rawJson;
  // Store the entire backend JSON (for future‑proofing)

  NotificationLocal({
    required this.notificationId,
    required this.userId,
    required this.read,
    required this.createdAt,
    required this.rawJson,
  });
}
