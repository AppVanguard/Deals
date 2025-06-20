// lib/features/auth/presentation/views/signup/widgets/signup_bloc_consumer.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/constants.dart';
import 'package:deals/core/helper_functions/custom_top_snack_bar.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/core/widgets/custom_progress_hud.dart';
import 'package:deals/features/auth/presentation/manager/cubits/signup_cubit/signup_cubit.dart';
import 'package:deals/features/auth/presentation/views/otp_verification/otp_verfication_view.dart';
import 'package:deals/features/auth/presentation/views/user_update/user_update_view.dart';
import 'package:deals/features/auth/presentation/views/signup/widgets/signup_view_body.dart';
import 'package:deals/features/main/presentation/views/main_view.dart';
import 'package:go_router/go_router.dart';

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
          if (state.requiresOtp) {
            // New account → OTP verification
            log('Navigate to OTP for ${state.userEntity.email}');
            context.pushNamed(
              OtpVerficationView.routeName,
              extra: {
                kEmail: state.userEntity.email,
                kImage: AppImages.assetsImagesOTB,
                kNextRoute: UserUpdateView.routeName,
                kId: state.userEntity.uId,
                kIsRegister: true,
              },
            );
          } else {
            // Social login → MainView
            context.goNamed(MainView.routeName, extra: state.userEntity);
          }
        }
      },
      builder: (context, state) => CustomProgressHud(
        isLoading: state is SignupLoading,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: SignupViewBody(),
        ),
      ),
    );
  }
}
