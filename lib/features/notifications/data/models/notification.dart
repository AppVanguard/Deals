import 'notification_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Notification {
  String? id;
  String? userId;
  String? title;
  String? body;
  NotificationData? data;
  bool? read;
  DateTime? createdAt;
  int? v;

  Notification({
    this.id,
    this.userId,
    this.title,
    this.body,
    this.data,
    this.read,
    this.createdAt,
    this.v,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        id: json['_id'] as String?,
        userId: json['userId'] as String?,
        title: json['title'] as String?,
        body: json['body'] as String?,
        data: json['data'] == null
            ? null
            : NotificationData.fromJson(json['data'] as Map<String, dynamic>),
        read: json['read'] as bool?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        v: json['__v'] as int?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'userId': userId,
        'title': title,
        'body': body,
        'data': data?.toJson(),
        'read': read,
        'createdAt': createdAt?.toIso8601String(),
        '__v': v,
      };

  /// Factory to create a Notification from a RemoteMessage.
  factory Notification.fromRemoteMessage(RemoteMessage message) {
    final Map<String, dynamic> dataMap =
        message.data.isNotEmpty ? Map<String, dynamic>.from(message.data) : {};
    return Notification(
      id: message.messageId,
      // userId is not included in the FCM message; it will be set by your backend or ignored.
      title: message.notification?.title,
      body: message.notification?.body,
      read: false,
      createdAt: DateTime.now(),
      data: dataMap.isNotEmpty ? NotificationData.fromJson(dataMap) : null,
    );
  }
}
