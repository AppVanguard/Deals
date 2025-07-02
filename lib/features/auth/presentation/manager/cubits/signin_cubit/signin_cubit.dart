import 'package:deals/core/utils/logger.dart';

import 'package:deals/constants.dart';
import 'package:deals/core/service/secure_storage_service.dart';
import 'package:deals/core/service/shared_prefrences_singleton.dart';
import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/features/auth/domain/repos/auth_repo.dart';
import 'package:deals/features/auth/presentation/manager/helpers/social_signin_helper.dart';
import 'package:deals/core/manager/cubit/safe_cubit.dart';
import 'package:meta/meta.dart';
import 'package:deals/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:deals/core/errors/failure.dart';

part 'signin_state.dart';

class SigninCubit extends SafeCubit<SigninState> with SocialSigninHelper {
  SigninCubit(this._authRepo) : super(SigninInitial());

  final AuthRepo _authRepo;

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
      );
  }

  Future<void> signInWithGoogle({required bool rememberMe}) async {
    await _socialSignIn(() => _authRepo.signInWithGoogle(), rememberMe);
  }

  Future<void> signInWithFacebook({required bool rememberMe}) async {
    await _socialSignIn(() => _authRepo.signInWithFacebook(), rememberMe);
  }

  }
}
