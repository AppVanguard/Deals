import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_pocket/core/service/get_it_service.dart';
import 'package:in_pocket/features/auth/domain/repos/auth_repo.dart';
import 'package:in_pocket/features/auth/presentation/cubits/signin_cubit/signin_cubit.dart';
import 'package:in_pocket/features/auth/presentation/views/widgets/signin_view_bloc_consumer.dart';

class SigninView extends StatelessWidget {
  const SigninView({super.key});
  static const String routeName = 'signin';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SigninCubit(getIt.get<AuthRepo>()),
      child: const Scaffold(
        body: SafeArea(
          child: SigninViewBlocConsumer(),
        ),
      ),
    );
  }
}
