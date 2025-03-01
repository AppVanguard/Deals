import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/constants.dart';
import 'package:deals/core/service/secure_storage_service.dart';
import 'package:deals/core/service/shared_prefrences_singleton.dart';
import 'package:deals/features/auth/domain/entities/user_entity.dart';
import 'package:deals/features/auth/domain/repos/auth_repo.dart';
import 'package:deals/generated/l10n.dart';
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
      },
    );
  }
}
