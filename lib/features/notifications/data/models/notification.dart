import 'notification_details.dart';

class Notification {
  String? id;
  String? userId;
  String? title;
  String? body;
  NotificationDetails? data;
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
            : NotificationDetails.fromJson(
                json['data'] as Map<String, dynamic>),
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
}
