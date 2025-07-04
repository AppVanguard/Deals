import 'package:deals/core/utils/logger.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:deals/features/auth/presentation/views/reset_password/widgets/reset_password_view_body.dart';

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
    appLog("The otp in reset: $otp");
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ResetPasswordViewBody(
            email: email,
            otp: otp,
          ),
        ),
      ),
    );
  }
}
