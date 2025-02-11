part of 'otp_verify_cubit.dart';

@immutable
sealed class OtpVerifyState {}

final class OtpVerifyInitial extends OtpVerifyState {}

final class OtpVerifyLoading extends OtpVerifyState {}

final class OtpVerifySuccess extends OtpVerifyState {
  final String message;
  final UserEntity userEntity;

  OtpVerifySuccess({required this.userEntity, required this.message});
}

final class OtpVerifyFailure extends OtpVerifyState {
  final String message;

  OtpVerifyFailure({required this.message});
}

/// Emitted while the 60-second resend timer is running.
final class OtpTimerRunning extends OtpVerifyState {
  final int timeLeft;
  OtpTimerRunning({required this.timeLeft});
}

/// Emitted when the 60-second timer finishes,
/// meaning the user can resend again.
final class OtpTimerFinished extends OtpVerifyState {}
