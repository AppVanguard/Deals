import 'package:dartz/dartz.dart';
import 'package:deals/core/errors/faliure.dart';
import 'package:deals/features/notifications/data/models/notification.dart';

abstract class NotificationsRepo {
  /// Retrieve notifications for the given [userId] with [token].
  Future<Either<Failure, List<Notification>>> getNotificationsByUserId({
    required String userId,
    required String token,
  });

  /// Mark notifications as read, passing [token] in the headers.
  Future<Either<Failure, void>> markNotificationsAsRead({
    required String userId,
    required List<String> notificationIds,
    required String token,
  });
}
