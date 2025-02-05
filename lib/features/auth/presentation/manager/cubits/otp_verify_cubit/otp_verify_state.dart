part of 'otp_verify_cubit.dart';

@immutable
sealed class OtpVerifyState {}

final class OtpVerifyInitial extends OtpVerifyState {}

final class OtpVerifySuccess extends OtpVerifyState {
  final String message;
  final UserEntity userEntity;

  OtpVerifySuccess({required this.userEntity, required this.message});
}

final class OtpVerifyFailure extends OtpVerifyState {
  final String message;

  OtpVerifyFailure({required this.message});
}

final class OtpVerifyLoading extends OtpVerifyState {}
