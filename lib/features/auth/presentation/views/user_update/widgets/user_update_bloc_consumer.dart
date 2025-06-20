import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/core/helper_functions/custom_top_snack_bar.dart';
import 'package:deals/core/widgets/custom_progress_hud.dart';
import 'package:deals/features/auth/presentation/manager/cubits/user_update_cubit/user_update_cubit.dart';
import 'package:deals/features/auth/presentation/views/signin/signin_view.dart';
import 'package:deals/features/auth/presentation/views/user_update/widgets/user_update_view_body.dart';
import 'package:go_router/go_router.dart';

class UserUpdateBlocConsumer extends StatelessWidget {
  const UserUpdateBlocConsumer(
      {super.key, required this.id, required this.token});
  final String id;
  final String token;
  @override
  Widget build(BuildContext context) {
    log(id);
    return BlocConsumer<UserUpdateCubit, UserUpdateState>(
      listener: (context, state) {
        if (state is UserUpdateFailure) {
          customErrorTopSnackBar(
            context: context,
            message: state.message,
          );
        }
        if (state is UserUpdateSuccess) {
          // Instead of pushReplacementNamed...
          context.goNamed(SigninView.routeName);
        }
      },
      builder: (context, state) {
        return CustomProgressHud(
          isLoading: state is UserUpdateLoading,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: UserUpdateViewBody(
              token: token,
              id: id,
            ),
          ),
        );
      },
    );
  }
}
