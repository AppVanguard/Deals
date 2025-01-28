import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_pocket/core/service/get_it_service.dart';
import 'package:in_pocket/features/auth/domain/repos/auth_repo.dart';
import 'package:in_pocket/features/auth/presentation/cubits/signup_cubit/signup_cubit.dart';
import 'package:in_pocket/features/auth/presentation/views/widgets/signup_bloc_consumer.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});
  static const String routeName = 'signup';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(getIt.get<AuthRepo>()),
      child: const Scaffold(
        body: SafeArea(
          child: SignupBlocConsumer(),
        ),
      ),
    );
  }
}


