part of 'signup_cubit.dart';

@immutable
abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  /// The signed-in / newly-created user object
  final UserEntity userEntity;

  /// Message for snack-bars or logs
  final String message;

  /// If `true` → navigate to OTP page
  /// If `false` → user is ready for MainView
  final bool requiresOtp;

  SignupSuccess({
    required this.userEntity,
    required this.message,
    this.requiresOtp = true,
  });
}

class SignupFailure extends SignupState {
  final String message;
  SignupFailure({required this.message});
}
