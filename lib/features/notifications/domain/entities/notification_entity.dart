// lib/core/entities/notification_entity.dart
class NotificationEntity {
  final String id;
  final String userId;
  final String title;
  final String body;
  final bool read;
  final DateTime createdAt;

  NotificationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.read,
    required this.createdAt,
  });

  /// Create a NotificationEntity from an FCM RemoteMessage.
  /// (Note: userId must be set from your business logic after login.)
  factory NotificationEntity.fromRemoteMessage(
      Map<String, dynamic> messageData) {
    // Here we assume messageData contains the title, body, etc.
    // You might need to adapt this based on your FCM payload.
    return NotificationEntity(
      id: messageData['id'] ??
          '', // fallback: you can use messageData['messageId'] if available
      userId: '', // to be set later
      title: messageData['title'] ?? '',
      body: messageData['body'] ?? '',
      read: false,
      createdAt: DateTime.now(),
    );
  }
}
