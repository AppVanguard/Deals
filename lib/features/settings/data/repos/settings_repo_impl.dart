import 'package:deals/core/utils/logger.dart';

import 'package:dartz/dartz.dart';
import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/core/errors/failure.dart';
import 'package:deals/core/mappers/user_mapper.dart';
import 'package:deals/core/repos/interface/notifications_permission_repo.dart';
import 'package:deals/core/service/auth_api_service.dart';
import 'package:deals/core/service/user_service.dart';
import 'package:deals/features/settings/domain/repos/settings_repo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:deals/core/utils/firebase_utils.dart';
import 'package:deals/main.dart'; // for flutterLocalNotificationsPlugin & initializeLocalNotifications()

class SettingsRepoImpl implements SettingsRepo {
  final NotificationsPermissionRepo _notifPermRepo;
  final AuthApiService _authApiService;
  final UserService _userService;

  SettingsRepoImpl({
    required NotificationsPermissionRepo notificationsPermissionRepo,
    required AuthApiService authApiService,
    required UserService userService,
  })  : _notifPermRepo = notificationsPermissionRepo,
        _authApiService = authApiService,
        _userService = userService;

  // ───────────────────────────────────────────────────────
  // Server-side Push Controls
  // ───────────────────────────────────────────────────────
  @override
  Future<Either<Failure, Unit>> allowPushNotifications({
    required String firebaseUid,
    required String deviceToken,
    required String authToken,
  }) async {
    try {
      final res = await _notifPermRepo.allowNotifications(
        firebaseUid: firebaseUid,
        deviceToken: deviceToken,
        authToken: authToken,
      );
      return res.map((_) => unit);
    } catch (e) {
      appLog('Error allowing push server-side: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> disablePushNotifications({
    required String firebaseUid,
    required String authToken,
  }) async {
    try {
      final res = await _notifPermRepo.preventNotifications(
        userId: firebaseUid,
        authToken: authToken,
      );
      return res.map((_) => unit);
    } catch (e) {
      appLog('Error disabling push server-side: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ───────────────────────────────────────────────────────
  // Client-side Push Controls
  // ───────────────────────────────────────────────────────
  @override
  Future<Either<Failure, Unit>> disablePushNotificationsLocal() async {
    try {
      appLog(
          'SettingsRepoImpl.disablePushNotificationsLocal: disabling locally');
      await FirebaseMessaging.instance.setAutoInitEnabled(false);
      await FirebaseMessaging.instance.deleteToken();
      await flutterLocalNotificationsPlugin.cancelAll();
      return const Right(unit);
    } catch (e) {
      appLog('Error disabling push locally: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> enablePushNotificationsLocal() async {
    try {
      appLog('SettingsRepoImpl.enablePushNotificationsLocal: enabling locally');
      await FirebaseMessaging.instance.setAutoInitEnabled(true);
      final token = await initFirebaseMessaging();
      appLog('New FCM token: $token');
      await initializeLocalNotifications();
      return const Right(unit);
    } catch (e) {
      appLog('Error enabling push locally: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ───────────────────────────────────────────────────────
  // Auth & Account
  // ───────────────────────────────────────────────────────
  @override
  Future<Either<Failure, String>> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
    required String authToken,
  }) async {
    try {
      final msg = await _authApiService.changePassword(
        email: email,
        currentPassword: currentPassword,
        newPassword: newPassword,
        authToken: authToken,
      );
      return Right(msg);
    } catch (e) {
      appLog('Error in changePassword: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> deleteAccount({
    required String firebaseUid,
    required String authToken,
  }) async {
    try {
      final msg =
          await _userService.deleteUserByFirebaseUid(firebaseUid, authToken);
      return Right(msg);
    } catch (e) {
      appLog('Error deleting account: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ───────────────────────────────────────────────────────
  // Update User In-App (needs token)
  // ───────────────────────────────────────────────────────
  @override
  Future<Either<Failure, UserEntity>> updateUserData({
    required String id,
    String? country,
    String? city,
    String? dateOfBirth,
    String? gender,
    required String authToken,
  }) async {
    try {
      final model = await _userService.updateUserData(
        id: id,
        country: country,
        city: city,
        dateOfBirth: dateOfBirth,
        gender: gender,
        token: authToken,
      );
      return Right(UserMapper.mapToEntity(model));
    } catch (e) {
      appLog('Error updating user (settings): $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
