import 'dart:developer';

import 'package:deals/constants.dart';
import 'package:deals/core/repos/interface/notifications_permission_repo.dart';
import 'package:deals/core/service/secure_storage_service.dart';
import 'package:deals/core/service/shared_prefrences_singleton.dart';
import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/features/auth/domain/repos/auth_repo.dart';
import 'package:deals/features/auth/presentation/manager/helpers/social_signin_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:deals/core/manager/cubit/safe_cubit.dart';
import 'package:meta/meta.dart';
import 'package:deals/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:deals/core/errors/failure.dart';

part 'signin_state.dart';

class SigninCubit extends SafeCubit<SigninState> with SocialSigninHelper {
  SigninCubit(this._authRepo, this._notificationsPermissionRepo)
      : super(SigninInitial());

  final AuthRepo _authRepo;
  final NotificationsPermissionRepo _notificationsPermissionRepo;

  void clearError() => emit(SigninResetError());

  // ────────────────────────────────────────────────────────────────────────────
  // Email + Password
  // ────────────────────────────────────────────────────────────────────────────
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
        // 🔑  Always persist the fresh user (even if rememberMe == false)
        await SecureStorageService.saveUserEntity(user);
        Prefs.setBool(kRememberMe, rememberMe);

        emit(
          SigninSuccess(userEntity: user, message: S.current.SuccessSigningIn),
        );

        await _registerNotifications(user);
      },
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Social logins (Google / Facebook / Apple)
  // Each does the same: persist user unconditionally.
  // ────────────────────────────────────────────────────────────────────────────
  Future<void> _socialSignIn(
    Future<Either<Failure, UserEntity>> Function() signInCall,
    bool rememberMe,
  ) {
    return handleSocialSignIn(
      signInCall: signInCall,
      rememberMe: rememberMe,
      emitLoading: () => emit(SigninLoading()),
      emitFailure: (msg) => emit(SigninFailure(message: msg)),
      emitSuccess: (user) => emit(
        SigninSuccess(userEntity: user, message: S.current.SuccessSigningIn),
      ),
      persistUser: true,
      afterSuccess: _registerNotifications,
    );
  }

  Future<void> signInWithGoogle({required bool rememberMe}) async {
    await _socialSignIn(() => _authRepo.signInWithGoogle(), rememberMe);
  }

  Future<void> signInWithFacebook({required bool rememberMe}) async {
    await _socialSignIn(() => _authRepo.signInWithFacebook(), rememberMe);
  }

  Future<void> signInWithApple({required bool rememberMe}) async {
    await _socialSignIn(() => _authRepo.signInWithApple(), rememberMe);
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Push-notification registration
  // ────────────────────────────────────────────────────────────────────────────
  Future<void> _registerNotifications(UserEntity user) async {
    final key = 'notificationsRegistered_${user.uId}';
    if (Prefs.getBool(key)) return;

    final token = await FirebaseMessaging.instance.getToken();
    if (token == null || token.isEmpty) return;

    final res = await _notificationsPermissionRepo.allowNotifications(
      firebaseUid: user.uId,
      deviceToken: token,
      authToken: user.token,
    );

    res.fold(
      (f) {
        log('Notification error: ${f.message}');
        // if you like, you could also mark pushEnabled=false here:
        Prefs.setBool(kPushEnabled, false);
      },
      (_) {
        Prefs.setBool(key, true); // your existing guard
        Prefs.setBool(kPushEnabled, true); // <— mark push ON
        log('Notifications registered for ${user.uId}');
      },
    );
  }
}
