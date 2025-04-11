import 'package:flutter/material.dart';
import 'package:deals/features/auth/presentation/views/widgets/forget_password_bloc_consumer.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});
  static const routeName = '/forget-password';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: const SafeArea(
        child: ForgetPasswordBlocConsumer(),
      ),
    );
  }
}
