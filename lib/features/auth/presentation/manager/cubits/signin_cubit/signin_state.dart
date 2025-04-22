part of 'signin_cubit.dart';

@immutable
abstract class SigninState {}

class SigninInitial extends SigninState {}

class SigninLoading extends SigninState {}

class SigninSuccess extends SigninState {
  final UserEntity userEntity;
  final String message;
  SigninSuccess({required this.userEntity, required this.message});
}

class SigninFailure extends SigninState {
  final String message;
  SigninFailure({required this.message});
}

class SigninOtpRequired extends SigninState {
  final UserEntity userEntity;
  final String message;
  SigninOtpRequired({required this.userEntity, required this.message});
}

/// تُستَخدم لمسح رسالة الخطأ عند الكتابة
class SigninResetError extends SigninState {}
