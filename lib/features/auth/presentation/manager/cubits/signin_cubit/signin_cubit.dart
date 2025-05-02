import 'dart:developer';

import 'package:deals/constants.dart';
import 'package:deals/core/repos/interface/notifications_permission_repo.dart';
import 'package:deals/core/service/secure_storage_service.dart';
import 'package:deals/core/service/shared_prefrences_singleton.dart';
import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/features/auth/domain/repos/auth_repo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:deals/generated/l10n.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit(this._authRepo, this._notificationsPermissionRepo)
      : super(SigninInitial());

  final AuthRepo _authRepo;
  final NotificationsPermissionRepo _notificationsPermissionRepo;

  void clearError() => emit(SigninResetError());

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    emit(SigninLoading());

    final result = await _authRepo.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        if (failure.message.contains(S.current.Email_not_verified)) {
          emit(SigninOtpRequired(
            userEntity: UserEntity(
              id: '',
              token: '',
              uId: '',
              email: email,
              fullName: '',
              phone: '',
            ),
            message: failure.message,
          ));
        } else {
          emit(SigninFailure(message: failure.message));
        }
      },
      (user) async {
        if (rememberMe) {
          await SecureStorageService.saveUserEntity(
            user.toJson(),
          );
        }
        Prefs.setBool(kRememberMe, rememberMe);

        emit(SigninSuccess(
            userEntity: user, message: S.current.SuccessSigningIn));

        await _registerNotifications(user);
      },
    );
  }

  Future<void> signInWithGoogle({required bool rememberMe}) async {
    emit(SigninLoading());
    final result = await _authRepo.signInWithGoogle();
    result.fold(
      (failure) => emit(SigninFailure(message: failure.message)),
      (user) async {
        if (rememberMe) {
          await SecureStorageService.saveUserEntity(
            user.toJson(),
          );
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
    final result = await _authRepo.signInWithFacebook();
    result.fold(
      (failure) => emit(SigninFailure(message: failure.message)),
      (user) async {
        if (rememberMe) {
          await SecureStorageService.saveUserEntity(
            user.toJson(),
          );
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
    final result = await _authRepo.signInWithApple();
    result.fold(
      (failure) => emit(SigninFailure(message: failure.message)),
      (user) async {
        if (rememberMe) {
          await SecureStorageService.saveUserEntity(
            user.toJson(),
          );
        }
        Prefs.setBool(kRememberMe, rememberMe);
        emit(SigninSuccess(
            userEntity: user, message: S.current.SuccessSigningIn));
        await _registerNotifications(user);
      },
    );
  }

  Future<void> _registerNotifications(UserEntity user) async {
    final key = 'notificationsRegistered_${user.uId}';
    if (Prefs.getBool(key)) return;

    final token = await FirebaseMessaging.instance.getToken();
    if (token == null || token.isEmpty) return;

    final res = await _notificationsPermissionRepo.allowNotifications(
      firebaseUid: user.uId,
      deviceToken: token,
      authToken: user.token ?? '',
    );

    res.fold(
      (f) => log('Notification error: ${f.message}'),
      (_) {
        Prefs.setBool(key, true);
        log('Notifications registered for ${user.uId}');
      },
    );
  }
}
