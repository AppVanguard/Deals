import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_pocket/core/helper_functions/custom_top_snack_bar.dart';
import 'package:in_pocket/core/utils/app_images.dart';
import 'package:in_pocket/core/widgets/custom_modal_sheet.dart';
import 'package:in_pocket/core/widgets/custom_progress_hud.dart';
import 'package:in_pocket/features/auth/presentation/manager/cubits/signup_cubit/signup_cubit.dart';
import 'package:in_pocket/features/auth/presentation/views/otp_verfication_view.dart';
import 'package:in_pocket/features/auth/presentation/views/personal_data_view.dart';
import 'package:in_pocket/features/auth/presentation/views/widgets/signup_view_body.dart';
import 'package:in_pocket/generated/l10n.dart';

class SignupBlocConsumer extends StatelessWidget {
  const SignupBlocConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupFailure) {
          customErrorTopSnackBar(context: context, message: state.message);
        }
        if (state is SignupSuccess) {
         
          Navigator.pushReplacementNamed(context, OtpVerficationView.routeName,
              arguments: [
                state.userEntity.email,
                AppImages.assetsImagesOTB,
                PersonalDataView.routeName
              ]);
        }
      },
      builder: (context, state) {
        return CustomProgressHud(
            isLoading: state is SignupLoading ? true : false,
            child: const SignupViewBody());
      },
    );
  }
}
