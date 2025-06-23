part of 'splash_cubit.dart';

@immutable
abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashNavigateToSignin extends SplashState {}

class SplashNavigateToMain extends SplashState {
  final dynamic userEntity; // userEntity may be null if using firebase auth only
  SplashNavigateToMain(this.userEntity);
}

class SplashNavigateToOnboarding extends SplashState {}
