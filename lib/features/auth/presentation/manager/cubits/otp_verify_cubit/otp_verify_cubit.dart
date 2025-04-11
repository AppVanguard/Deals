import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'otp_verify_state.dart';
import 'package:deals/features/auth/domain/repos/auth_repo.dart';

class OtpVerifyCubit extends Cubit<OtpVerifyState> {
  final AuthRepo authRepo;

  OtpVerifyCubit(this.authRepo) : super(OtpVerifyInitial());

  /// For the registration flow: uses sendOtp.
  Future<void> verifyOtpForRegister(
      {required String email, required String otp}) async {
    log("in reg otp verify $email, $otp");
    emit(OtpVerifyLoading());
    final result = await authRepo.sendOtp(email: email, otp: otp);
    result.fold(
      (failure) => emit(OtpVerifyFailure(message: failure.message)),
      (userEntity) => emit(
        OtpVerifySuccess(
          message: "OTP Verified Successfully",
          userEntity: userEntity,
          otp: otp,
        ),
      ),
    );
  }

  /// For the reset password flow: uses the dedicated verifyOtp endpoint.
  Future<void> verifyOtpForReset(
      {required String email, required String otp}) async {
    emit(OtpVerifyLoading());
    log("here $otp, $email");
    final result = await authRepo.verifyOtp(email: email, otp: otp);
    result.fold(
      (failure) => emit(OtpVerifyFailure(message: failure.message)),
      (message) => emit(
        OtpVerifySuccess(
          message: "OTP Verified Successfully",
          otp: otp,
        ),
      ),
    );
  }

  /// Resends the OTP code.
  Future<void> resendOtp(String email) async {
    final result = await authRepo.resendOtp(email: email);
    result.fold(
      (failure) => emit(OtpVerifyFailure(message: failure.message)),
      (success) {
        // No state change here—the timer is handled separately.
      },
    );
  }
}
