import 'package:dartz/dartz.dart';
import 'package:deals/core/errors/failure.dart';

abstract class NotificationsPermissionRepo {
  /// Tells backend to "allow" notifications for a given user + device token.
  Future<Either<Failure, void>> allowNotifications({
    required String firebaseUid,
    required String deviceToken,
    required String authToken,
  });

  /// Tells backend to "prevent" notifications for a given user.
  Future<Either<Failure, void>> preventNotifications({
    required String userId,
    required String authToken,
  });
}
