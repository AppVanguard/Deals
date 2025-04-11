import 'package:deals/features/auth/presentation/views/widgets/signin_view_bloc_consumer.dart';
import 'package:flutter/material.dart';

class SigninView extends StatelessWidget {
  const SigninView({super.key});
  static const String routeName = '/signin';

  @override
  Widget build(BuildContext context) {
    // No BlocProvider here, it's in the route builder (app_router.dart)
    return const Scaffold(
      body: SafeArea(
        child: SigninViewBlocConsumer(),
      ),
    );
  }
}
