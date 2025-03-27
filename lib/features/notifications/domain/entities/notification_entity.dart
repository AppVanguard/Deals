// lib/core/entities/notification_entity.dart
class NotificationEntity {
  final String id;
  final String userId;
  final String title;
  final String body;
  final bool read;
  final DateTime createdAt;
  final String? image; // URL of the notification image

  NotificationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.read,
    required this.createdAt,
    this.image,
  });

  /// Create a NotificationEntity from an FCM payload.
  /// Here, we expect that the data contains an 'image' key.
  factory NotificationEntity.fromRemoteMessage(Map<String, dynamic> data) {
    return NotificationEntity(
      id: data['id'] ?? '',
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      read: false,
      createdAt: DateTime.now(),
      image: data['image'] as String?, // may be null
    );
  }
}
