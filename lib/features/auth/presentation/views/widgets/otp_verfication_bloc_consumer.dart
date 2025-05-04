// lib/features/auth/presentation/views/widgets/otp_verfication_bloc_consumer.dart
import 'dart:developer';
import 'package:deals/features/auth/presentation/views/signin_view.dart';
import 'package:deals/features/auth/presentation/views/widgets/otp_verfication_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:deals/constants.dart';
import 'package:deals/core/widgets/custom_modal_sheet.dart';
import 'package:deals/features/auth/presentation/manager/cubits/otp_verify_cubit/otp_verify_cubit.dart';
import 'package:deals/features/auth/presentation/manager/cubits/otp_verify_cubit/otp_verify_state.dart';
import 'package:deals/generated/l10n.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/features/auth/presentation/views/reset_password_view.dart';
import 'package:go_router/go_router.dart';

class OTPVeficationBlocConsumer extends StatelessWidget {
  final String email;
  final String? image;
  final String path; // nextRoute (legacy)
  final String? finalRoute; // NEW
  final bool isRegister;
  final String id; // legacy

  const OTPVeficationBlocConsumer({
    super.key,
    required this.email,
    this.image,
    required this.path,
    required this.id,
    required this.isRegister,
    required this.finalRoute,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<OtpVerifyCubit, OtpVerifyState>(
      listener: (context, state) {
        if (state is OtpVerifySuccess) {
          if (!context.mounted) return; // guard
          CustomModalSheet.show(
            context,
            buttonText: S.of(context).Next,
            enableDrag: false,
            svgPicture: SvgPicture.asset(AppImages.assetsImagesSuccess),
            onTap: () {
              if (!context.mounted) return; // guard
              if (path == ResetPasswordView.routeName) {
                context.goNamed(
                  ResetPasswordView.routeName,
                  extra: {
                    kEmail: email,
                    kOtp: state.otp,
                    kFinalRoute: finalRoute ?? SigninView.routeName, // fallback
                  },
                );
              } else {
                context.pushNamed(path, extra: state.userEntity?.uId);
              }
            },
            message: S.of(context).EmailVerified,
          );
        }
      },
      child: BlocBuilder<OtpVerifyCubit, OtpVerifyState>(
        builder: (context, state) {
          // existing code unchanged
          // …
          return OTPVerificationViewBody(
            isRegister: isRegister,
            id: id,
            image: image,
            email: email,
            routeName: path,
            errorMessage:
                state is OtpVerifyFailure ? S.of(context).InvalidCode : null,
          );
        },
      ),
    );
  }
}
