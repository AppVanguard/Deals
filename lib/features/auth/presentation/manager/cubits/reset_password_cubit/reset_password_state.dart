part of 'reset_password_cubit.dart';

@immutable
abstract class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordEmailSent extends ResetPasswordState {
  final String message;
  ResetPasswordEmailSent({required this.message});
}

class ResetPasswordSuccess extends ResetPasswordState {
  final String message;
  ResetPasswordSuccess({required this.message});
}

class ResetPasswordFailure extends ResetPasswordState {
  final String message;
  ResetPasswordFailure({required this.message});
}
