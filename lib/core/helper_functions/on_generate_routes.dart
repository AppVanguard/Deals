import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:deals/constants.dart';
import 'package:deals/features/auth/domain/entities/user_entity.dart';
import 'package:deals/features/auth/presentation/views/personal_data_view.dart';
import 'package:deals/features/auth/presentation/views/otp_verfication_view.dart';
import 'package:deals/features/auth/presentation/views/forget_password_view.dart';
import 'package:deals/features/auth/presentation/views/reset_password_view.dart';
import 'package:deals/features/auth/presentation/views/signin_view.dart';
import 'package:deals/features/auth/presentation/views/signup_view.dart';
import 'package:deals/features/home/presentation/views/home_view.dart';
import 'package:deals/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:deals/features/search/presentation/views/search_view.dart';
import 'package:deals/features/splash/presentation/views/splash_view.dart';

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
      log("args are Entity: ${settings.arguments}");
      final args = settings.arguments as UserEntity?;
      log("User ID: ${args!.uId}");
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => HomeView(userData: args),
      );
    case ForgetPasswordView.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const ForgetPasswordView(),
      );
    case OtpVerficationView.routeName:
      log("args are: ${settings.arguments}");
      final args = settings.arguments as Map<String, dynamic>?;
      if (args == null) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const Scaffold(
              body: Center(child: Text('Missing route arguments'))),
        );
      }
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => OtpVerficationView(
          email: args[kEmail] as String,
          image: args[kImage] as String?,
          nextRoute: args[kNextRoute] as String,
          id: args[kId] as String,
          isRegister: args[kIsRegister] as bool,
        ),
      );
    case ResetPasswordView.routeName:
      final args = settings.arguments as Map<String, dynamic>?;
      if (args == null) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const Scaffold(
              body: Center(child: Text('Missing route arguments'))),
        );
      }
      final email = args[kEmail] as String;
      final otp = args[kOtp] as String;
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => ResetPasswordView(
          email: email,
          otp: otp,
        ),
      );
    case PersonalDataView.routeName:
      final id = settings.arguments as String;
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => PersonalDataView(id: id),
      );
    case SearchView.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const SearchView(),
      );
    default:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const Scaffold(),
      );
  }
}
