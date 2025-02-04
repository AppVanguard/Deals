import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:in_pocket/features/auth/presentation/views/otp_verfication_view.dart';
import 'package:in_pocket/features/auth/presentation/views/personal_data_view.dart';
import 'package:in_pocket/features/auth/presentation/views/reset_password_view.dart';
import 'package:in_pocket/features/auth/presentation/views/signin_view.dart';
import 'package:in_pocket/features/auth/presentation/views/signup_view.dart';
import 'package:in_pocket/features/auth/presentation/views/forget_password_view.dart';
import 'package:in_pocket/features/home/presentation/views/home_view.dart';
import 'package:in_pocket/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:in_pocket/features/splash/presentation/views/splash_view.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashView.routeName:
      return MaterialPageRoute(
          settings: settings, builder: (context) => const SplashView());
    case OnBoardingView.routeName:
      return MaterialPageRoute(
          settings: settings, builder: (context) => const OnBoardingView());
    case SigninView.routeName:
      return MaterialPageRoute(
          settings: settings, builder: (context) => const SigninView());
    case SignupView.routeName:
      return MaterialPageRoute(
          settings: settings, builder: (context) => const SignupView());
    case HomeView.routeName:
      return MaterialPageRoute(
          settings: settings, builder: (context) => const HomeView());
    case ForgetPasswordView.routeName:
      return MaterialPageRoute(
          settings: settings, builder: (context) => const ForgetPasswordView());
    case OtpVerficationView.routeName:
      final args = settings.arguments as List<String?>;
      final email = args[0];
      final image = args[1];
      final route = args[2];
      if (email == null) {
        return MaterialPageRoute(
            settings: settings, builder: (context) => const Scaffold());
      }
      return MaterialPageRoute(
          settings: settings,
          builder: (context) => OtpVerficationView(
                email: email,
                image: image,
                path: route!,
              ));
    case ResetPasswordView.routeName:
      return MaterialPageRoute(
          settings: settings, builder: (context) => const ResetPasswordView());
    case PersonalDataView.routeName:
      return MaterialPageRoute(
          settings: settings, builder: (context) => const PersonalDataView());
    default:
      return MaterialPageRoute(
          settings: settings, builder: (context) => const Scaffold());
  }
}
