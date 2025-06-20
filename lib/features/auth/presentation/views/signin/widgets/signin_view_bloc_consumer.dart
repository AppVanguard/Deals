import 'package:deals/features/auth/presentation/views/signin/signin_view.dart';
import 'package:deals/features/auth/presentation/views/signin/widgets/signin_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/constants.dart';
import 'package:deals/core/widgets/custom_progress_hud.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/features/auth/presentation/manager/cubits/signin_cubit/signin_cubit.dart';
import 'package:deals/features/auth/presentation/views/otp_verification/otp_verfication_view.dart';
import 'package:deals/features/main/presentation/views/main_view.dart';
import 'package:go_router/go_router.dart';

class SigninViewBlocConsumer extends StatelessWidget {
  const SigninViewBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    String? serverError;

    return BlocConsumer<SigninCubit, SigninState>(
      listener: (context, state) {
        switch (state) {
          case SigninFailure():
            serverError = state.message;
          case SigninResetError():
            serverError = null;
          case SigninOtpRequired():
            serverError = state.message;
            context.pushNamed(OtpVerficationView.routeName, extra: {
              kEmail: state.userEntity.email,
              kImage: AppImages.assetsImagesOTB,
              kNextRoute: SigninView.routeName,
              kId: '',
              kIsRegister: true,
            });
          case SigninSuccess():
            context.goNamed(MainView.routeName, extra: state.userEntity);
          default:
        }
      },
      builder: (context, state) => CustomProgressHud(
        isLoading: state is SigninLoading,
        child: SigninViewBody(
          serverError: serverError,
          onTyping: () => context.read<SigninCubit>().clearError(),
        ),
      ),
    );
  }
}
