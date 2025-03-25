import 'notification_data.dart';

class NotificationsModel {
  bool? success;
  NotificationData? data;

  NotificationsModel({this.success, this.data});

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    return NotificationsModel(
      success: json['success'] as bool?,
      data: json['data'] == null
          ? null
          : NotificationData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.toJson(),
      };
}
