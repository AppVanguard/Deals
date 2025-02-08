import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_pocket/constants.dart';
import 'package:in_pocket/core/helper_functions/custom_top_snack_bar.dart';
import 'package:in_pocket/core/utils/app_images.dart';
import 'package:in_pocket/core/widgets/custom_progress_hud.dart';
import 'package:in_pocket/features/auth/presentation/manager/cubits/signup_cubit/signup_cubit.dart';
import 'package:in_pocket/features/auth/presentation/views/otp_verfication_view.dart';
import 'package:in_pocket/features/auth/presentation/views/personal_data_view.dart';
import 'package:in_pocket/features/auth/presentation/views/widgets/signup_view_body.dart';

class SignupBlocConsumer extends StatelessWidget {
  const SignupBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupFailure) {
          customErrorTopSnackBar(context: context, message: state.message);
        }
        if (state is SignupSuccess) {
          log(state.userEntity.uId);
          // Pass a map containing the basic user data returned from registration.
          Navigator.pushReplacementNamed(
            context,
            OtpVerficationView.routeName,
            arguments: {
              'email': state.userEntity.email,
              'image': AppImages.assetsImagesOTB,
              'nextRoute': PersonalDataView.routeName,
              'id': state.userEntity.uId
            },
          );
        }
      },
      builder: (context, state) {
        return CustomProgressHud(
          isLoading: state is SignupLoading,
          child: const SignupViewBody(),
        );
      },
    );
  }
}
