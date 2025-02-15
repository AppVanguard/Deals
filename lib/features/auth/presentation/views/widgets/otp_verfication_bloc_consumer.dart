import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_pocket/constants.dart';
import 'package:in_pocket/core/widgets/custom_modal_sheet.dart';
import 'package:in_pocket/core/widgets/custom_progress_hud.dart';
import 'package:in_pocket/features/auth/presentation/manager/cubits/otp_verify_cubit/otp_verify_cubit.dart';
import 'package:in_pocket/features/auth/presentation/manager/cubits/otp_verify_cubit/otp_verify_state.dart';
import 'otp_verfication_view_body.dart';
import 'package:in_pocket/generated/l10n.dart';
import 'package:in_pocket/core/utils/app_images.dart';
import 'package:in_pocket/features/auth/presentation/views/reset_password_view.dart';

class OTPVeficationBlocConsumer extends StatelessWidget {
  final String email;
  final String? image;
  final String path;

  /// The legacy id parameter is still accepted but will no longer be used for OTP.
  final String id;
  const OTPVeficationBlocConsumer({
    super.key,
    required this.email,
    this.image,
    required this.path,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<OtpVerifyCubit, OtpVerifyState>(
      listener: (context, state) {
        if (state is OtpVerifySuccess) {
          log('User typed OTP: ${state.otp}');
          CustomModalSheet.show(
            context,
            buttonText: S.of(context).Next,
            enableDrag: false,
            svgPicture: SvgPicture.asset(AppImages.assetsImagesSuccess),
            onTap: () {
              if (path == ResetPasswordView.routeName) {
                Navigator.pushReplacementNamed(context, path, arguments: {
                  kEmail: email,
                  kOtp: state.otp,
                });
              } else {
                Navigator.pushReplacementNamed(context, path,
                    arguments: state.userEntity.uId);
              }
            },
            message: S.of(context).EmailVerified,
          );
        }
      },
      child: BlocBuilder<OtpVerifyCubit, OtpVerifyState>(
        builder: (context, state) {
          String? errorMessage;
          bool isLoading = false;
          if (state is OtpVerifyLoading) {
            isLoading = true;
          } else if (state is OtpVerifyFailure) {
            errorMessage = S.of(context).InvalidCode;
          }
          return CustomProgressHud(
            isLoading: isLoading,
            child: OTPVerificationViewBody(
              id: id,
              image: image,
              email: email,
              routeName: path,
              errorMessage: errorMessage,
            ),
          );
        },
      ),
    );
  }
}
