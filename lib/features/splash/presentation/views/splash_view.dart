import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/core/utils/app_colors.dart';
import '../manager/cubits/splash_cubit.dart';
import 'widgets/splash_view_body.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit()..checkNavigation(),
      child: const Scaffold(
        backgroundColor: AppColors.primary,
        body: SplashViewBody(),
      ),
    );
  }
}
