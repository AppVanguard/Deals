import 'package:meta/meta.dart';
import 'package:in_pocket/features/auth/domain/entities/user_entity.dart';

@immutable
sealed class OtpVerifyState {}

final class OtpVerifyInitial extends OtpVerifyState {}

final class OtpVerifyLoading extends OtpVerifyState {}

final class OtpVerifySuccess extends OtpVerifyState {
  final String message;
  final UserEntity userEntity;
  final String otp; // New field to store the typed OTP.
  OtpVerifySuccess({
    required this.message,
    required this.userEntity,
    required this.otp,
  });
}

final class OtpVerifyFailure extends OtpVerifyState {
  final String message;
  OtpVerifyFailure({required this.message});
}
