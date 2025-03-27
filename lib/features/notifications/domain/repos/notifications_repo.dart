import 'package:dartz/dartz.dart';
import 'package:deals/core/errors/faliure.dart';
import 'package:deals/features/notifications/domain/entities/notification_entity.dart';

abstract class NotificationsRepo {
  Future<Either<Failure, List<NotificationEntity>>> getNotificationsByUserId({
    required String userId,
    required String token,
  });

  Future<Either<Failure, void>> markNotificationsAsRead({
    required String userId,
    required List<String> notificationIds,
    required String token,
  });

  /// New: Delete a notification.
  Future<Either<Failure, void>> deleteNotification({
    required String userId,
    required String notificationId,
  });
}
