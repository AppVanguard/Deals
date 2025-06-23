import 'package:deals/core/manager/cubit/safe_cubit.dart';
import 'package:deals/features/auth/presentation/manager/helpers/social_signin_helper.dart';
import 'package:meta/meta.dart';
import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/features/auth/domain/repos/auth_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:deals/core/errors/failure.dart';
part 'signup_state.dart';

class SignupCubit extends SafeCubit<SignupState> with SocialSigninHelper {
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
  Future<void> _socialSignIn(
    Future<Either<Failure, UserEntity>> Function() signInCall,
    bool rememberMe,
  ) {
    return handleSocialSignIn(
      signInCall: signInCall,
      rememberMe: rememberMe,
      emitLoading: () => emit(SignupLoading()),
      emitFailure: (msg) => emit(SignupFailure(message: msg)),
      emitSuccess: (user) => emit(
        SignupSuccess(
          userEntity: user,
          message: 'تم تسجيل الدخول بنجاح',
          requiresOtp: false,
        ),
      ),
    );
  }

  Future<void> signInWithGoogle({required bool rememberMe}) async {
    await _socialSignIn(() => authRepo.signInWithGoogle(), rememberMe);
  }

  Future<void> signInWithFacebook({required bool rememberMe}) async {
    await _socialSignIn(() => authRepo.signInWithFacebook(), rememberMe);
  }

  Future<void> signInWithApple({required bool rememberMe}) async {
    await _socialSignIn(() => authRepo.signInWithApple(), rememberMe);
  }
}
