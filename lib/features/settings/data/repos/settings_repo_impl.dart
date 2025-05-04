// lib/features/settings/data/repos/settings_repo_impl.dart

import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:deals/core/errors/faliure.dart';
import 'package:deals/core/repos/interface/notifications_permission_repo.dart';
import 'package:deals/core/service/auth_api_service.dart';
import 'package:deals/core/service/user_service.dart';
import 'package:deals/features/settings/domain/repos/settings_repo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

  // ──────────────────────────────────────────────────────────────────────────
  // Server-side toggles
  // ──────────────────────────────────────────────────────────────────────────

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
      log('Error allowing push server-side: $e');
      return Left(ServerFaliure(message: e.toString()));
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
      log('Error disabling push server-side: $e');
      return Left(ServerFaliure(message: e.toString()));
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Client-side FCM/local notifications
  // ──────────────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, Unit>> disablePushNotificationsLocal() async {
    try {
      // 1) Turn off FCM auto-init
      await FirebaseMessaging.instance.setAutoInitEnabled(false);
      // 2) Delete the existing FCM token so the OS no longer delivers
      await FirebaseMessaging.instance.deleteToken();
      // 3) Cancel any scheduled or pending local notifications
      await flutterLocalNotificationsPlugin.cancelAll();
      return const Right(unit);
    } catch (e) {
      log('Error disabling push locally: $e');
      return Left(ServerFaliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> enablePushNotificationsLocal() async {
    try {
      // 1) Re-enable FCM auto-init
      await FirebaseMessaging.instance.setAutoInitEnabled(true);
      // 2) Force generation of a new token
      final token = await FirebaseMessaging.instance.getToken();
      log('New FCM token: $token');
      // 3) Re-initialize local notifications plugin (heads-up, channels, etc)
      await initializeLocalNotifications();
      return const Right(unit);
    } catch (e) {
      log('Error enabling push locally: $e');
      return Left(ServerFaliure(message: e.toString()));
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Change-password & delete-account
  // ──────────────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, String>> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
    required String authToken,
  }) async {
    try {
      final message = await _authApiService.changePassword(
        email: email,
        currentPassword: currentPassword,
        newPassword: newPassword,
        authToken: authToken,
      );
      return Right(message);
    } catch (e) {
      log('Error in changePassword: $e');
      return Left(ServerFaliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> deleteAccount({
    required String firebaseUid,
    required String authToken,
  }) async {
    try {
      final message = await _userService.deleteUserByFirebaseUid(firebaseUid);
      return Right(message);
    } catch (e) {
      log('Error deleting account: $e');
      return Left(ServerFaliure(message: e.toString()));
    }
  }
}
