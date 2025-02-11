// otp_verify_cubit.dart

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_pocket/features/auth/domain/entities/user_entity.dart';
import 'package:in_pocket/features/auth/domain/repos/auth_repo.dart';
import 'package:in_pocket/generated/l10n.dart';
import 'package:meta/meta.dart';

part 'otp_verify_state.dart';

class OtpVerifyCubit extends Cubit<OtpVerifyState> {
  final AuthRepo authRepo;
  Timer? _resendTimer;
  int _timeLeft = 60;

  OtpVerifyCubit(this.authRepo) : super(OtpVerifyInitial());

  /// Verify the OTP code.
  Future<void> verifyOtp({required String email, required String otp}) async {
    emit(OtpVerifyLoading());
    final result = await authRepo.sendOtp(email: email, otp: otp);
    result.fold(
      (failure) => emit(OtpVerifyFailure(message: failure.message)),
      (userEntity) => emit(OtpVerifySuccess(
        message: S.current.OtpVerfiedSuccess,
        userEntity: userEntity,
      )),
    );
  }

  /// Immediately start the timer so the user can't spam requests,
  /// then call the repository's resend API call.
  Future<void> resendOtp(String email) async {
    // 1) Immediately start the countdown so the UI switches to disabled state.
    _startResendTimer();

    // 2) Perform the network call in parallel.
    final result = await authRepo.resendOtp(email: email);
    result.fold(
      (failure) {
        // If you want to revert the timer on failure, do it here.
        // Otherwise, leave the countdown as is until it finishes.
        emit(OtpVerifyFailure(message: failure.message));
      },
      (success) {
        // On success, we do nothing special. The timer keeps running.
      },
    );
  }

  /// Helper to start the 60-second countdown and emit states.
  void _startResendTimer() {
    // Cancel any existing timer
    _resendTimer?.cancel();

    _timeLeft = 60;
    emit(OtpTimerRunning(timeLeft: _timeLeft));

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timeLeft--;
      if (_timeLeft <= 0) {
        timer.cancel();
        emit(OtpTimerFinished());
      } else {
        emit(OtpTimerRunning(timeLeft: _timeLeft));
      }
    });
  }

  @override
  Future<void> close() {
    _resendTimer?.cancel();
    return super.close();
  }
}
