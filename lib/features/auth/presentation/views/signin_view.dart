import 'package:flutter/material.dart';
import 'package:in_pocket/features/auth/presentation/views/widgets/signin_view_body.dart';

class SigninView extends StatelessWidget {
  const SigninView({super.key});
  static const String routeName = 'signin';
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SigninViewBody(),
      ),
    );
  }
}
