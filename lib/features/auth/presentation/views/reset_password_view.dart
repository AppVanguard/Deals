import 'dart:developer';
import 'package:deals/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:deals/features/auth/presentation/views/widgets/reset_password_view_body.dart';

class ResetPasswordView extends StatelessWidget {
  final String email;
  final String otp;
  final String finalRoute;

  const ResetPasswordView({
    super.key,
    required this.email,
    required this.otp,
    required this.finalRoute,
  });

  static const routeName = '/reset-password';

  @override
  Widget build(BuildContext context) {
    log("The otp in reset: $otp");
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ResetPasswordViewBody(
            email: email,
            otp: otp,
            finalRoute: finalRoute,
          ),
        ),
      ),
    );
  }
}
