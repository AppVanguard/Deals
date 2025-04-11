import 'package:meta/meta.dart';
import 'package:deals/features/auth/domain/entities/user_entity.dart';

@immutable
sealed class OtpVerifyState {}

final class OtpVerifyInitial extends OtpVerifyState {}

final class OtpVerifyLoading extends OtpVerifyState {}

final class OtpVerifySuccess extends OtpVerifyState {
  final String message;
  final UserEntity? userEntity;
  final String otp; // The OTP that was entered.
  OtpVerifySuccess({
    required this.message,
    this.userEntity,
    required this.otp,
  });
}

final class OtpVerifyFailure extends OtpVerifyState {
  final String message;
  OtpVerifyFailure({required this.message});
}
