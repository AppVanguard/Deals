import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/features/auth/presentation/manager/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:deals/features/auth/presentation/views/widgets/forget_password_bloc_consumer.dart';
import 'package:deals/core/service/get_it_service.dart';
import 'package:deals/features/auth/domain/repos/auth_repo.dart';

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
