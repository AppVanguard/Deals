import 'notification.dart';
import 'pagination.dart';

class NotificationsData {
  List<Notification>? notifications;
  Pagination? pagination;

  NotificationsData({this.notifications, this.pagination});

  factory NotificationsData.fromJson(Map<String, dynamic> json) =>
      NotificationsData(
        notifications: (json['notifications'] as List<dynamic>?)
            ?.map((e) => Notification.fromJson(e as Map<String, dynamic>))
            .toList(),
        pagination: json['pagination'] == null
            ? null
            : Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'notifications': notifications?.map((e) => e.toJson()).toList(),
        'pagination': pagination?.toJson(),
      };
}
