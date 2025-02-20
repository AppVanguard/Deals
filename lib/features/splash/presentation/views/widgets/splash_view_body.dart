import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:in_pocket/constants.dart';
import 'package:in_pocket/core/service/firebase_auth_service.dart';
import 'package:in_pocket/core/service/secure_storage_service.dart';
import 'package:in_pocket/core/service/shared_prefrences_singleton.dart';
import 'package:in_pocket/core/utils/app_text_styles.dart';
import 'package:in_pocket/features/auth/presentation/views/signin_view.dart';
import 'package:in_pocket/features/home/presentation/views/home_view.dart';
import 'package:in_pocket/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:in_pocket/features/auth/domain/entities/user_entity.dart';

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

    // Wait for 2 seconds for splash effect or async initializations
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    if (isOnBoardingViewSeen) {
      bool isLoggedIn = FirebaseAuthService().isSignedIn();
      if (!mounted) return;
      if (isLoggedIn) {
        // Retrieve user entity from secure storage
        final userJson = await SecureStorageService.getUserEntity();
        if (userJson != null && userJson.isNotEmpty) {
          try {
            final userEntity = UserEntity.fromJson(userJson);
            Navigator.pushReplacementNamed(
              context,
              HomeView.routeName,
              arguments: userEntity,
            );
          } catch (e) {
            log("Error parsing user data: $e");
            Navigator.pushReplacementNamed(context, SigninView.routeName);
          }
        } else {
          Navigator.pushReplacementNamed(context, SigninView.routeName);
        }
      } else {
        Navigator.pushReplacementNamed(context, SigninView.routeName);
      }
    } else {
      Navigator.pushReplacementNamed(context, OnBoardingView.routeName);
    }
  }
}
