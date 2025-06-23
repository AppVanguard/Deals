import 'package:deals/constants.dart';
import 'package:deals/core/service/get_it_service.dart';
import 'package:deals/core/service/secure_storage_service.dart';
import 'package:deals/core/service/shared_prefrences_singleton.dart';
import 'package:deals/features/auth/presentation/views/signin/signin_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit() : super(SessionInitial());

  Future<void> signOutAndRedirect(BuildContext context) async {
    emit(SessionLoading());
    try {
      final user = await SecureStorageService.getCurrentUser();
      await Prefs.setBool(kRememberMe, false);
      if (user != null) {
        await Prefs.remove('notificationsRegistered_${user.uId}');
      }
      unregisterNotificationsCubitSingleton();
      await SecureStorageService.deleteUserEntity();
      emit(SessionLoggedOut());
      if (!context.mounted) return;
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      context.goNamed(SigninView.routeName);
    } catch (e) {
      emit(SessionFailure(message: e.toString()));
    }
  }
}
