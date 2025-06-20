// lib/features/auth/presentation/views/forget_password_view.dart
import 'package:flutter/material.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/features/auth/presentation/views/forget_password/widgets/forget_password_bloc_consumer.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({
    super.key,
  });

  static const routeName = '/forget-password';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background),
      body: const SafeArea(
        child: ForgetPasswordBlocConsumer(),
      ),
    );
  }
}
