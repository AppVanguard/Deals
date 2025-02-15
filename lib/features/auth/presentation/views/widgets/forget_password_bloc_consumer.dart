import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_pocket/constants.dart';
import 'package:in_pocket/core/utils/app_images.dart';
import 'package:in_pocket/core/widgets/custom_progress_hud.dart';
import 'package:in_pocket/features/auth/presentation/views/otp_verfication_view.dart';
import 'package:in_pocket/features/auth/presentation/views/reset_password_view.dart';
import 'package:in_pocket/features/auth/presentation/manager/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:in_pocket/features/auth/presentation/views/widgets/forget_password_view_body.dart';

class ForgetPasswordBlocConsumer extends StatefulWidget {
  const ForgetPasswordBlocConsumer({super.key});

  @override
  State<ForgetPasswordBlocConsumer> createState() =>
      _ForgetPasswordBlocConsumerState();
}

class _ForgetPasswordBlocConsumerState
    extends State<ForgetPasswordBlocConsumer> {
  String? email;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordEmailSent) {
          if (email != null) {
            Navigator.pushNamed(
              context,
              OtpVerficationView.routeName,
              arguments: {
                kEmail: email!,
                kImage: AppImages.assetsImagesOTB,
                // Next route is the reset password screen.
                kNextRoute: ResetPasswordView.routeName,
                // Passing the API's returned message (or OTP) as kId.
                kId: state.message,
              },
            );
          }
        } else if (state is ResetPasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final bool isLoading = state is ResetPasswordLoading;
        return CustomProgressHud(
          isLoading: isLoading,
          child: ForgetPasswordViewBody(
            onEmailSaved: (savedEmail) {
              email = savedEmail;
            },
          ),
        );
      },
    );
  }
}
