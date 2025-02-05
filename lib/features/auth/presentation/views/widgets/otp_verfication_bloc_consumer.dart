import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_pocket/core/widgets/custom_progress_hud.dart';
import 'package:in_pocket/features/auth/presentation/manager/cubits/otp_verify_cubit/otp_verify_cubit.dart';
import 'package:in_pocket/features/auth/presentation/views/personal_data_view.dart';
import 'package:in_pocket/features/auth/presentation/views/widgets/otp_verfication_view_body.dart';
import 'package:in_pocket/generated/l10n.dart';

class OTPVeficationBlocConsumer extends StatelessWidget {
  const OTPVeficationBlocConsumer({
    super.key,
    required this.image,
    required this.email,
    required this.path,
  });

  final String? image;
  final String email;
  final String path;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpVerifyCubit, OtpVerifyState>(
      listener: (context, state) {
        log("$state");

        if (state is OtpVerifySuccess) {
          Navigator.pushReplacementNamed(context, PersonalDataView.routeName);
        }
        // Optionally, you can also perform side effects for other states.
      },
      builder: (context, state) {
        // Pass the errorMessage from cubit if it exists.
        String? errorMessage;
        if (state is OtpVerifyFailure) {
          errorMessage = S.of(context).InvalidCode;
        }
        return CustomProgressHud(
          isLoading: state is OtpVerifyLoading,
          child: OTPVerificationViewBody(
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
