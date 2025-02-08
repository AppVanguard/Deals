import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_pocket/core/utils/app_images.dart';
import 'package:in_pocket/core/widgets/custom_modal_sheet.dart';
import 'package:in_pocket/core/widgets/custom_progress_hud.dart';
import 'package:in_pocket/features/auth/presentation/manager/cubits/otp_verify_cubit/otp_verify_cubit.dart';
import 'package:in_pocket/features/auth/presentation/views/widgets/otp_verfication_view_body.dart';
import 'package:in_pocket/generated/l10n.dart';

class OTPVeficationBlocConsumer extends StatelessWidget {
  final String email;
  final String? image;
  final String path;
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
    return BlocConsumer<OtpVerifyCubit, OtpVerifyState>(
      listener: (context, state) {
        log(id);
        if (state is OtpVerifySuccess) {
          CustomModalSheet.show(context,
              buttonText: S.of(context).Next,
              enableDrag: false,
              svgPicture: SvgPicture.asset(AppImages.assetsImagesSuccess),
              onTap: () {
            Navigator.pushReplacementNamed(context, path, arguments: id);
          }, message: S.of(context).EmailVerified);
        }
      },
      builder: (context, state) {
        String? errorMessage;
        if (state is OtpVerifyFailure) {
          errorMessage = S.of(context).InvalidCode;
        }
        return CustomProgressHud(
          isLoading: state is OtpVerifyLoading,
          child: OTPVerificationViewBody(
            id: id,
            image: image,
            email: email,
            routeName: path,
            errorMessage: errorMessage,
          ),
        );
      },
    );
  }
}
