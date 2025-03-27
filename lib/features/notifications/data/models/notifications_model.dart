import 'notifications_data.dart';

class NotificationsModel {
  bool? success;
  NotificationsData? data;

  NotificationsModel({this.success, this.data});

  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      NotificationsModel(
        success: json['success'] as bool?,
        data: json['data'] == null
            ? null
            : NotificationsData.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.toJson(),
      };
}
