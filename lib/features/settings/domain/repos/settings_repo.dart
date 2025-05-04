// lib/features/settings/domain/repos/settings_repo.dart

import 'package:dartz/dartz.dart';
import 'package:deals/core/errors/faliure.dart';

abstract class SettingsRepo {
  /// Server-side: tell your backend to allow pushes for this device/token.
  Future<Either<Failure, Unit>> allowPushNotifications({
    required String firebaseUid,
    required String deviceToken,
    required String authToken,
  });

  /// Server-side: tell your backend to stop sending pushes for this user.
  Future<Either<Failure, Unit>> disablePushNotifications({
    required String firebaseUid,
    required String authToken,
  });

  /// Client-side only: disable FCM auto-init & cancel all local notifications.
  Future<Either<Failure, Unit>> disablePushNotificationsLocal();

  /// Client-side only: re-enable FCM auto-init & re-init local notifications.
  Future<Either<Failure, Unit>> enablePushNotificationsLocal();

  /// Change the user’s password via `/auth/change-password`.
  Future<Either<Failure, String>> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
    required String authToken,
  });

  /// Delete the user’s account (`DELETE /users/:firebaseUid`).
  Future<Either<Failure, String>> deleteAccount({
    required String firebaseUid,
    required String authToken,
  });
}
