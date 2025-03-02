import 'package:deals/features/main/presentation/views/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/constants.dart';
import 'package:deals/core/helper_functions/custom_top_snack_bar.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/core/widgets/custom_progress_hud.dart';
import 'package:deals/features/auth/presentation/manager/cubits/signin_cubit/signin_cubit.dart';
import 'package:deals/features/auth/presentation/views/otp_verfication_view.dart';
import 'package:deals/features/auth/presentation/views/signin_view.dart';
import 'package:deals/features/auth/presentation/views/widgets/signin_view_body.dart';
import 'package:deals/features/home/presentation/views/home_view.dart';

class SigninViewBlocConsumer extends StatelessWidget {
  const SigninViewBlocConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigninCubit, SigninState>(
      listener: (context, state) {
        if (state is SigninFailure) {
          customErrorTopSnackBar(context: context, message: state.message);
        }
        if (state is SigninOtpRequired) {
          customErrorTopSnackBar(context: context, message: state.message);
          Navigator.pushReplacementNamed(context, OtpVerficationView.routeName,
              arguments: {
                kEmail: state.userEntity.email,
                kImage: AppImages.assetsImagesOTB,
                kNextRoute: SigninView.routeName,
                kId: '',
                kIsRegister: true
              });
        }
        if (state is SigninSuccess) {
          Navigator.pushReplacementNamed(context, MainView.routeName,
              arguments: state.userEntity);
        }
      },
      builder: (context, state) {
        return CustomProgressHud(
          isLoading: state is SigninLoading,
          child: const SigninViewBody(),
        );
      },
    );
  }
}
