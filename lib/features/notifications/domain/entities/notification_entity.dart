// lib/features/notifications/domain/entities/notification_entity.dart

class NotificationEntity {
  final String id;
  final String userId;
  final String title;
  final String body;
  final bool read;
  final DateTime createdAt;
  final String? image;

  NotificationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.read,
    required this.createdAt,
    this.image,
  });

  // If you parse FCM data or something similar, you might have a constructor like:
  factory NotificationEntity.fromRemoteMessage(Map<String, dynamic> data) {
    return NotificationEntity(
      id: data['_id'] ?? '',
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      read: false,
      createdAt: DateTime.now(),
      image: data['image'] as String?,
    );
  }

  NotificationEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    bool? read,
    DateTime? createdAt,
    String? image,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      read: read ?? this.read,
      createdAt: createdAt ?? this.createdAt,
      image: image ?? this.image,
    );
  }
}
