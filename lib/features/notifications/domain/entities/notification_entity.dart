class NotificationEntity {
  final String id;
  final String userId;
  final String title;
  final String body;
  final bool read;
  final DateTime createdAt;
  final String? image;
  final String? coupon; // Unique coupon id returned by backend

  NotificationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.read,
    required this.createdAt,
    this.image,
    this.coupon,
  });

  /// Create a NotificationEntity from FCM message data.
  /// Expects that the backend sends the complete notification details
  /// (including '_id', 'coupon', and 'image') in the data payload.
  factory NotificationEntity.fromRemoteMessage(Map<String, dynamic> data) {
    return NotificationEntity(
      id: data['_id'] ?? data['id'] ?? '',
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      read: false,
      createdAt: DateTime.now(),
      image: data['image'] as String?,
      coupon: data['coupon'] as String?,
    );
  }
}
