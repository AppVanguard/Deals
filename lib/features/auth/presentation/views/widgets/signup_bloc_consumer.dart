import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/constants.dart';
import 'package:deals/core/helper_functions/custom_top_snack_bar.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/core/widgets/custom_progress_hud.dart';
import 'package:deals/features/auth/presentation/manager/cubits/signup_cubit/signup_cubit.dart';
import 'package:deals/features/auth/presentation/views/otp_verfication_view.dart';
import 'package:deals/features/auth/presentation/views/personal_data_view.dart';
import 'package:deals/features/auth/presentation/views/widgets/signup_view_body.dart';
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
          log(state.userEntity.uId);
          // Pass a map containing the user data
          context.goNamed(
            OtpVerficationView.routeName,
            extra: {
              kEmail: state.userEntity.email,
              kImage: AppImages.assetsImagesOTB,
              kNextRoute: PersonalDataView.routeName,
              kId: state.userEntity.uId,
              kIsRegister: true,
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
