import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:deals/constants.dart';
import 'package:deals/core/service/shared_prefrences_singleton.dart';
import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/features/auth/domain/repos/auth_repo.dart';
part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit(this.authRepo) : super(SignupInitial());
  final AuthRepo authRepo;

  // ───────────────────────────────── Email / Password ─────────────────────────
  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    emit(SignupLoading());

    final result = await authRepo.createUserWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
      phone: phone,
    );

    result.fold(
      (failure) => emit(SignupFailure(message: failure.message)),
      (userEntity) => emit(
        SignupSuccess(
          message: 'تم إنشاء الحساب بنجاح',
          userEntity: userEntity,
        ),
      ),
    );
  }

  // ───────────────────────────────── Social logins ────────────────────────────
  Future<void> signInWithGoogle({required bool rememberMe}) async {
    emit(SignupLoading());

    final result = await authRepo.signInWithGoogle();
    result.fold(
      (failure) => emit(SignupFailure(message: failure.message)),
      (user) {
        Prefs.setBool(kRememberMe, rememberMe);
        emit(
          SignupSuccess(
            userEntity: user,
            message: 'تم تسجيل الدخول بنجاح',
            requiresOtp: false, // <— READY for MainView
          ),
        );
      },
    );
  }

  Future<void> signInWithFacebook({required bool rememberMe}) async {
    emit(SignupLoading());

    final result = await authRepo.signInWithFacebook();
    result.fold(
      (failure) => emit(SignupFailure(message: failure.message)),
      (user) {
        Prefs.setBool(kRememberMe, rememberMe);
        emit(
          SignupSuccess(
            userEntity: user,
            message: 'تم تسجيل الدخول بنجاح',
            requiresOtp: false,
          ),
        );
      },
    );
  }

  Future<void> signInWithApple({required bool rememberMe}) async {
    emit(SignupLoading());

    final result = await authRepo.signInWithApple();
    result.fold(
      (failure) => emit(SignupFailure(message: failure.message)),
      (user) {
        Prefs.setBool(kRememberMe, rememberMe);
        emit(
          SignupSuccess(
            userEntity: user,
            message: 'تم تسجيل الدخول بنجاح',
            requiresOtp: false,
          ),
        );
      },
    );
  }
}
