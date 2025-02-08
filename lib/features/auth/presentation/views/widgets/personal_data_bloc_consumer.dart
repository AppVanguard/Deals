import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_pocket/core/helper_functions/custom_top_snack_bar.dart';
import 'package:in_pocket/core/widgets/custom_progress_hud.dart';
import 'package:in_pocket/features/auth/presentation/manager/cubits/user_update_cubit/user_update_cubit.dart';
import 'package:in_pocket/features/auth/presentation/views/signin_view.dart';
import 'package:in_pocket/features/auth/presentation/views/widgets/personal_data_view_body.dart';

class PersonalDataBlocConsumer extends StatelessWidget {
  const PersonalDataBlocConsumer({super.key, required this.id});
  final String id;
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
          Navigator.pushReplacementNamed(
            context,
            SigninView.routeName,
          );
        }
      },
      builder: (context, state) {
        return CustomProgressHud(
          isLoading: state is UserUpdateLoading,
          child: PersonalDataViewBody(
            id: id,
          ),
        );
      },
    );
  }
}
