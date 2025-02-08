import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:in_pocket/features/auth/presentation/views/personal_data_view.dart';
import 'package:in_pocket/features/auth/presentation/views/otp_verfication_view.dart';
import 'package:in_pocket/features/auth/presentation/views/forget_password_view.dart';
import 'package:in_pocket/features/auth/presentation/views/reset_password_view.dart';
import 'package:in_pocket/features/auth/presentation/views/signin_view.dart';
import 'package:in_pocket/features/auth/presentation/views/signup_view.dart';
import 'package:in_pocket/features/home/presentation/views/home_view.dart';
import 'package:in_pocket/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:in_pocket/features/splash/presentation/views/splash_view.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashView.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const SplashView(),
      );
    case OnBoardingView.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const OnBoardingView(),
      );
    case SigninView.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const SigninView(),
      );
    case SignupView.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const SignupView(),
      );
    case HomeView.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const HomeView(),
      );
    case ForgetPasswordView.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const ForgetPasswordView(),
      );
    case OtpVerficationView.routeName:
      final args = settings.arguments as Map<String, dynamic>?;
      if (args == null) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const Scaffold(
            body: Center(child: Text('Missing route arguments')),
          ),
        );
      }
      // Convert the basicData map to Map<String, String>
      final dynamic rawBasicData = args['basicData'];
      Map<String, String> basicData = {};
      if (rawBasicData is Map) {
        basicData = rawBasicData.map((key, value) => MapEntry(
              key.toString(),
              value.toString(),
            ));
      }
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => OtpVerficationView(
          email: args['email'] as String,
          image: args['image'] as String?,
          nextRoute: args['nextRoute'] as String,
          id: args['id'] as String,
        ),
      );
    case ResetPasswordView.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const ResetPasswordView(),
      );
    case PersonalDataView.routeName:
      log("args are :  ${settings.arguments}");
      // Now we expect only the id to be passed in the arguments.
      final id = settings.arguments as String;
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => PersonalDataView(
          id: id,
        ),
      );
    default:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const Scaffold(),
      );
  }
}
