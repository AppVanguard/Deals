import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_pocket/core/helper_functions/custom_top_snack_bar.dart';
import 'package:in_pocket/core/widgets/custom_progress_hud.dart';
import 'package:in_pocket/features/auth/presentation/cubits/signup_cubit/signup_cubit.dart';
import 'package:in_pocket/features/auth/presentation/views/widgets/signup_view_body.dart';

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
          customSuccessTopSnackBar(context: context, message: state.message);
          Navigator.of(context).pop();
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
