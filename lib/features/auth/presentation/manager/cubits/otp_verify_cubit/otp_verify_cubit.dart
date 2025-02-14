import 'package:flutter_bloc/flutter_bloc.dart';
import 'otp_verify_state.dart';
import 'package:in_pocket/features/auth/domain/repos/auth_repo.dart';
import 'package:in_pocket/features/auth/domain/entities/user_entity.dart';

class OtpVerifyCubit extends Cubit<OtpVerifyState> {
  final AuthRepo authRepo;

  OtpVerifyCubit(this.authRepo) : super(OtpVerifyInitial());

  /// Verifies the OTP code.
  Future<void> verifyOtp({required String email, required String otp}) async {
    emit(OtpVerifyLoading());
    final result = await authRepo.sendOtp(email: email, otp: otp);
    result.fold(
      (failure) => emit(OtpVerifyFailure(message: failure.message)),
      (userEntity) => emit(
        OtpVerifySuccess(
          message: "OTP Verified Successfully",
          userEntity: userEntity,
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
        // No additional state change here—the timer is handled separately.
      },
    );
  }
}
