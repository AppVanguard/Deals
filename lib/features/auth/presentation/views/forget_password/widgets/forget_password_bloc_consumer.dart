import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/constants.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/core/widgets/custom_progress_hud.dart';
import 'package:deals/features/auth/presentation/views/otp_verification/otp_verfication_view.dart';
import 'package:deals/features/auth/presentation/views/reset_password/reset_password_view.dart';
import 'package:deals/features/auth/presentation/manager/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:deals/features/auth/presentation/views/forget_password/widgets/forget_password_view_body.dart';
import 'package:go_router/go_router.dart';

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
            context.pushReplacementNamed(
              OtpVerficationView.routeName,
              extra: {
                kEmail: email!,
                kImage: AppImages.assetsImagesOTB,
                kNextRoute: ResetPasswordView.routeName,
                kId: '', // unchanged
                kIsRegister: false, // ← still “reset password” flow
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ForgetPasswordViewBody(
              onEmailSaved: (savedEmail) {
                email = savedEmail;
              },
            ),
          ),
        );
      },
    );
  }
}
