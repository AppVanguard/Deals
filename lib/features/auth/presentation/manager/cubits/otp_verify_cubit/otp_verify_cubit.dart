import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_pocket/features/auth/domain/entities/user_entity.dart';
import 'package:in_pocket/features/auth/domain/repos/auth_repo.dart';
import 'package:in_pocket/generated/l10n.dart';
import 'package:meta/meta.dart';

part 'otp_verify_state.dart';

class OtpVerifyCubit extends Cubit<OtpVerifyState> {
  final AuthRepo authRepo;

  OtpVerifyCubit(this.authRepo) : super(OtpVerifyInitial());

  Future<void> verifyOtp({required String email, required String otp}) async {
    emit(OtpVerifyLoading());
    final result = await authRepo.sendOtp(email: email, otp: otp);
    result.fold(
      (failure) => emit(OtpVerifyFailure(message: failure.message)),
      (userEntity) => emit(
        OtpVerifySuccess(
          message: S.current.OtpVerfiedSuccess,
          userEntity: userEntity,
        ),
      ),
    );
  }
}
