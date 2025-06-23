import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/constants.dart';
import 'package:deals/core/service/firebase_auth_service.dart';
import 'package:deals/core/service/secure_storage_service.dart';
import 'package:deals/core/service/shared_prefrences_singleton.dart';
import 'package:meta/meta.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> checkNavigation() async {
    final isOnBoardingViewSeen = Prefs.getBool(kIsOnBoardingViewSeen);
    await Future.delayed(const Duration(seconds: 2));

    if (isOnBoardingViewSeen) {
      final userEntity = await SecureStorageService.getCurrentUser();
      if (userEntity != null) {
        emit(SplashNavigateToMain(userEntity));
        return;
      }
      final isLoggedIn = FirebaseAuthService().isSignedIn();
      if (isLoggedIn) {
        emit(SplashNavigateToMain(null));
      } else {
        emit(SplashNavigateToSignin());
      }
    } else {
      emit(SplashNavigateToOnboarding());
    }
  }
}
