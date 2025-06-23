import 'package:deals/features/auth/presentation/views/signin/signin_view.dart';
import 'package:deals/features/main/presentation/views/main_view.dart';
import 'package:deals/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:deals/constants.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import '../../manager/cubits/splash_cubit.dart';


class SplashViewBody extends StatelessWidget {
  const SplashViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashNavigateToOnboarding) {
          context.pushNamed(OnBoardingView.routeName);
        } else if (state is SplashNavigateToSignin) {
          context.goNamed(SigninView.routeName);
        } else if (state is SplashNavigateToMain) {
          context.goNamed(MainView.routeName, extra: state.userEntity);
        }
      },
      child: Center(
        child: Column(
          spacing: 10, // If you are using flutter 3.7+ for 'spacing'
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              appTitle,
              style: AppTextStyles.bold46.copyWith(color: Colors.white),
            ),
            Text(
              splashSubTittle,
              style: AppTextStyles.light23.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
