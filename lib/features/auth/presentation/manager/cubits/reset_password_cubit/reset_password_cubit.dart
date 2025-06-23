import 'dart:developer';
import 'package:deals/core/manager/cubit/safe_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/features/auth/domain/repos/auth_repo.dart';
import 'package:meta/meta.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends SafeCubit<ResetPasswordState> {
  final AuthRepo authRepo;

  ResetPasswordCubit(this.authRepo) : super(ResetPasswordInitial());

  /// Sends a forgot password request which triggers an email with OTP.
  Future<void> sendForgotPasswordEmail(String email) async {
    emit(ResetPasswordLoading());
    final result = await authRepo.forgotPassword(email: email);
    result.fold(
      (failure) => emit(ResetPasswordFailure(message: failure.message)),
      (message) => emit(ResetPasswordEmailSent(message: message)),
    );
  }

  /// Resets the password using the provided email, OTP, and new password.
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    log("In Cubit: email: $email, otp: $otp, newPassword: $newPassword");
    emit(ResetPasswordLoading());
    final result = await authRepo.resetPassword(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );
    result.fold(
      (failure) => emit(ResetPasswordFailure(message: failure.message)),
      (message) => emit(ResetPasswordSuccess(message: message)),
    );
  }
}
