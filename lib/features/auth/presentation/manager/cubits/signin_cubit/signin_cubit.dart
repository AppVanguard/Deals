import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:deals/constants.dart';
import 'package:deals/core/service/secure_storage_service.dart';
import 'package:deals/core/service/shared_prefrences_singleton.dart';
import 'package:deals/features/auth/domain/entities/user_entity.dart';
import 'package:deals/features/auth/domain/repos/auth_repo.dart';
import 'package:deals/core/service/notifications_permission_service.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit(this.authRepo) : super(SigninInitial());

  final AuthRepo authRepo;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    emit(SigninLoading());
    final result = await authRepo.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    result.fold(
      (failure) {
        if (failure.message.contains(S.current.Emain_not_verified)) {
          final userEntity = UserEntity(
            id: '',
            token: '',
            uId: '',
            email: email,
            name: '',
            phone: '',
          );
          emit(SigninOtpRequired(
              userEntity: userEntity, message: failure.message));
        } else {
          emit(SigninFailure(message: failure.message));
        }
      },
      (user) async {
        if (rememberMe) {
          log('Remember me is true');
          // Save user data securely
          await SecureStorageService.saveUserEntity(user.toJson());
        }
        Prefs.setBool(kRememberMe, rememberMe);
        emit(SigninSuccess(
            userEntity: user, message: S.current.SuccessSigningIn));

        // Register notifications for this account on this device if not already registered.
        await _registerNotifications(user);
      },
    );
  }

  Future<void> signInWithGoogle({required bool rememberMe}) async {
    emit(SigninLoading());
    final result = await authRepo.signInWithGoogle();
    result.fold(
      (failure) => emit(SigninFailure(message: failure.message)),
      (user) async {
        if (rememberMe) {
          await SecureStorageService.saveUserEntity(user.toJson());
        }
        Prefs.setBool(kRememberMe, rememberMe);
        emit(SigninSuccess(
            userEntity: user, message: S.current.SuccessSigningIn));
        await _registerNotifications(user);
      },
    );
  }

  Future<void> signInWithFacebook({required bool rememberMe}) async {
    emit(SigninLoading());
    final result = await authRepo.signInWithFacebook();
    result.fold(
      (failure) => emit(SigninFailure(message: failure.message)),
      (user) async {
        if (rememberMe) {
          await SecureStorageService.saveUserEntity(user.toJson());
        }
        Prefs.setBool(kRememberMe, rememberMe);
        emit(SigninSuccess(
            userEntity: user, message: S.current.SuccessSigningIn));
        await _registerNotifications(user);
      },
    );
  }

  Future<void> signInWithApple({required bool rememberMe}) async {
    emit(SigninLoading());
    final result = await authRepo.signInWithApple();
    result.fold(
      (failure) => emit(SigninFailure(message: failure.message)),
      (user) async {
        if (rememberMe) {
          await SecureStorageService.saveUserEntity(user.toJson());
        }
        Prefs.setBool(kRememberMe, rememberMe);
        emit(SigninSuccess(
            userEntity: user, message: S.current.SuccessSigningIn));
        await _registerNotifications(user);
      },
    );
  }

  /// Private helper to register push notifications for the current user.
  /// This will retrieve the FCM token and call the backend allow endpoint.
  /// Registration occurs only once per account on this device.
  Future<void> _registerNotifications(UserEntity user) async {
    final String registrationKey = "notificationsRegistered_${user.uId}";
    final alreadyRegistered = Prefs.getBool(registrationKey) ?? false;
    if (alreadyRegistered) {
      log("Notifications already registered for this user: ${user.uId}");
      return;
    }
    final fcmToken = await FirebaseMessaging.instance.getToken();
    log("FCM token: $fcmToken");
    if (fcmToken != null && fcmToken.isNotEmpty) {
      try {
        final permissionService = NotificationsPermissionService();
        await permissionService.allowNotifications(
          userId: user.uId,
          deviceToken: fcmToken,
          authToken: user.token,
        );
        // Mark as registered so we don't repeat this call for the same account on this device.
        Prefs.setBool(registrationKey, true);
        log("Notifications registered successfully for user: ${user.uId}");
      } catch (e) {
        log("Error registering notifications for user: ${user.uId} -> $e");
      }
    } else {
      log("FCM token is null; unable to register notifications.");
    }
  }
}
