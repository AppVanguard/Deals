import 'package:flutter/material.dart';
import 'package:in_pocket/constants.dart';
import 'package:in_pocket/core/service/shared_prefrences_singleton.dart';
import 'package:in_pocket/core/utils/app_text_styles.dart';
import 'package:in_pocket/features/on_boarding/presentation/views/on_boarding_view.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  @override
  void initState() {
    executeNavigation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            appTittle,
            style: AppTextStyles.bold46.copyWith(
              color: Colors.white,
            ),
          ),
          Text(
            splashSubTittle,
            style: AppTextStyles.light23.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void executeNavigation() {
    // bool isOnBoardingViewSeen = Prefs.getBool(kIsOnBoardingViewSeen);

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return; // Ensure the widget is still in the widget tree
      // if (isOnBoardingViewSeen) {
      //   // var isLoggedIn = FirebaseAuthService().isSignedIn();
      //   if (isLoggedIn) {
      //     Navigator.pushReplacementNamed(context, HomeView.routeName);
      //   } else {
      //     Navigator.pushReplacementNamed(context, SigninView.routeName);
      //   }
      // } else {
      //   Navigator.pushReplacementNamed(context, OnBoardingView.routeName);
      // }
      Navigator.pushReplacementNamed(context, OnBoardingView.routeName);
    });
  }
}
