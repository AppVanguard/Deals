import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/features/auth/presentation/views/widgets/reset_password_view_body.dart';
import 'package:deals/features/auth/presentation/manager/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:deals/core/service/get_it_service.dart';
import 'package:deals/features/auth/domain/repos/auth_repo.dart';

class ResetPasswordView extends StatelessWidget {
  final String email;
  final String otp;

  const ResetPasswordView({
    super.key,
    required this.email,
    required this.otp,
  });

  static const routeName = '/reset-password';

  @override
  Widget build(BuildContext context) {
    log("The otp in reset: $otp");
    return BlocProvider(
      create: (_) => ResetPasswordCubit(getIt.get<AuthRepo>()),
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: SafeArea(
          child: ResetPasswordViewBody(
            email: email,
            otp: otp,
          ),
        ),
      ),
    );
  }
}
