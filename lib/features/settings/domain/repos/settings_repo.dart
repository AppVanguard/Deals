import 'package:dartz/dartz.dart';
import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/core/errors/faliure.dart';

abstract class SettingsRepo {
  // ───────────── Server-side Push Controls ───────────────
  Future<Either<Failure, Unit>> allowPushNotifications({
    required String firebaseUid,
    required String deviceToken,
    required String authToken,
  });

  Future<Either<Failure, Unit>> disablePushNotifications({
    required String firebaseUid,
    required String authToken,
  });

  // ───────────── Client-side Push Controls ───────────────
  Future<Either<Failure, Unit>> disablePushNotificationsLocal();
  Future<Either<Failure, Unit>> enablePushNotificationsLocal();

  // ───────────── Auth & Account ──────────────────────────
  Future<Either<Failure, String>> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
    required String authToken,
  });

  Future<Either<Failure, String>> deleteAccount({
    required String firebaseUid,
    required String authToken,
  });

  // ───────────── Update User In-App (needs token) ────────
  Future<Either<Failure, UserEntity>> updateUserData({
    required String id,
    String? country,
    String? city,
    String? dateOfBirth,
    String? gender,
    required String authToken,
  });
}
