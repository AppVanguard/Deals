import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_pocket/features/auth/domain/entities/user_entity.dart';
import 'package:in_pocket/features/auth/domain/repos/auth_repo.dart';
import 'package:meta/meta.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit(this.authRepo) : super(SigninInitial());

  final AuthRepo authRepo;

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    emit(SigninLoading());
    final result = await authRepo.signInWithEmailAndPassword(
        email: email, password: password);
    result.fold(
      (failure) => emit(SigninFailure(message: failure.message)),
      (user) => emit(
          SigninSuccess(userEntity: user, message: 'تم تسجيل الدخول بنجاح')),
    );
  }

  Future<void> signInWithGoogle() async {
    emit(SigninLoading());
    final result = await authRepo.signInWithGoogle();
    result.fold(
      (failure) => emit(SigninFailure(message: failure.message)),
      (user) => emit(
          SigninSuccess(userEntity: user, message: 'تم تسجيل الدخول بنجاح')),
    );
  }

  Future<void> signInWithFacebook() async {
    emit(SigninLoading());
    final result = await authRepo.signInWithFacebook();
    result.fold(
      (failure) => emit(SigninFailure(message: failure.message)),
      (user) => emit(
          SigninSuccess(userEntity: user, message: 'تم تسجيل الدخول بنجاح')),
    );
  }

  Future<void> signInWithApple() async {
    emit(SigninLoading());
    final result = await authRepo.signInWithApple();
    result.fold(
      (failure) => emit(SigninFailure(message: failure.message)),
      (user) => emit(
          SigninSuccess(userEntity: user, message: 'تم تسجيل الدخول بنجاح')),
    );
  }
}
