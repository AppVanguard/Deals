import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:deals/constants.dart';
import 'package:deals/core/service/firebase_auth_service.dart';
import 'package:deals/core/service/secure_storage_service.dart';
import 'package:deals/core/service/shared_prefrences_singleton.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/features/auth/presentation/views/signin_view.dart';
import 'package:deals/features/home/presentation/views/home_view.dart';
import 'package:deals/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:deals/features/auth/domain/entities/user_entity.dart';

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
        spacing: 10,
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

    // First, try to get user data from secure storage
    if (isOnBoardingViewSeen) {
      final userJson = await SecureStorageService.getUserEntity();
      if (userJson != null && userJson.isNotEmpty) {
        try {
          if (!mounted) return;

          final userEntity = UserEntity.fromJson(userJson);
          Navigator.pushReplacementNamed(
            context,
            HomeView.routeName,
            arguments: userEntity,
          );
          return;
        } catch (e) {
          log("Error parsing user data: $e");
        }
      }
      if (!mounted) return;

      // Fallback to Firebase Auth check for social logins
      bool isLoggedIn = FirebaseAuthService().isSignedIn();
      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, HomeView.routeName);
      } else {
        Navigator.pushReplacementNamed(context, SigninView.routeName);
      }
    } else {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, OnBoardingView.routeName);
    }
  }
}
