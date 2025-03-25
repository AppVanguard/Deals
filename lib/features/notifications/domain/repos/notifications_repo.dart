import 'package:dartz/dartz.dart';
import 'package:deals/core/errors/faliure.dart';
import 'package:deals/features/notifications/data/models/notification.dart';

abstract class NotificationsRepo {
  Future<Either<Failure, List<Notification>>> getNotificationsByUserId(String userId);
  Future<Either<Failure, void>> markNotificationsAsRead({
    required String userId,
    required List<String> notificationIds,
  });
}
