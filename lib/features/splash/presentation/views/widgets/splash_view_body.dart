import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:deals/constants.dart';
import 'package:deals/core/service/firebase_auth_service.dart';
import 'package:deals/core/service/secure_storage_service.dart';
import 'package:deals/core/service/shared_prefrences_singleton.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/features/main/presentation/views/main_view.dart';
import 'package:deals/features/auth/presentation/views/signin_view.dart';
import 'package:deals/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:go_router/go_router.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  @override
  void initState() {
    super.initState();
    executeNavigation();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 10, // If you are using flutter 3.7+ for 'spacing'
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            appTittle,
            style: AppTextStyles.bold46.copyWith(color: Colors.white),
          ),
          Text(
            splashSubTittle,
            style: AppTextStyles.light23.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Future<void> executeNavigation() async {
    bool isOnBoardingViewSeen = Prefs.getBool(kIsOnBoardingViewSeen);
    await Future.delayed(const Duration(seconds: 2));

    if (isOnBoardingViewSeen) {
      final userEntity = await SecureStorageService.getCurrentUser();
      if (userEntity != null) {
        try {
          if (!mounted) return;

          // Switch to go_router
          context.goNamed(
            MainView.routeName,
            extra: userEntity,
          );
          return;
        } catch (e) {
          log("Error parsing user data: $e");
        }
      }

      if (!mounted) return;
      bool isLoggedIn = FirebaseAuthService().isSignedIn();
      if (isLoggedIn) {
        context.goNamed(MainView.routeName);
      } else {
        context.goNamed(SigninView.routeName);
      }
    } else {
      if (!mounted) return;
      context.pushNamed(OnBoardingView.routeName);
    }
  }
}
