// lib/features/auth/presentation/views/signup_view.dart

import 'package:deals/features/auth/presentation/views/widgets/signup_bloc_consumer.dart';
import 'package:flutter/material.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});
  static const String routeName = '/signup';

  @override
  Widget build(BuildContext context) {
    // No BlocProvider. It's provided in app_router.dart
    return const Scaffold(
      body: SafeArea(
        child: SignupBlocConsumer(),
      ),
    );
  }
}
