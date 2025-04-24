import 'package:deals/features/auth/presentation/views/widgets/signin_view_bloc_consumer.dart';
import 'package:flutter/material.dart';

class SigninView extends StatelessWidget {
  const SigninView({super.key});
  static const String routeName = '/signin';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SigninViewBlocConsumer(),
      ),
    );
  }
}
