import 'dart:developer';

import 'package:deals/core/manager/cubit/safe_cubit.dart';
import 'package:meta/meta.dart';

import 'package:deals/core/service/get_it_service.dart';
import 'package:deals/core/service/secure_storage_service.dart';
import 'package:deals/core/service/shared_prefrences_singleton.dart';
import 'package:deals/features/home/domain/repos/menu_repo.dart';
import 'package:deals/core/repos/interface/notifications_permission_repo.dart';

part 'menu_state.dart';

class MenuCubit extends SafeCubit<MenuState> {
  final MenuRepo menuRepo;
  final NotificationsPermissionRepo notificationsPermissionRepo;

  MenuCubit({
    required this.menuRepo,
    required this.notificationsPermissionRepo,
  }) : super(MenuInitial());

  Future<void> logout({
    required String firebaseUid,
    required String authToken,
  }) async {
    emit(MenuLoading());

    final result = await menuRepo.logOut(firebaseUid: firebaseUid);

    result.fold(
      (failure) => emit(MenuLogoutFailure(message: failure.message)),
      (message) async {
        // 1) Tell backend to stop pushes
        final preventResult =
            await notificationsPermissionRepo.preventNotifications(
          userId: firebaseUid,
          authToken: authToken,
        );
        preventResult.fold(
          (f) => log("Error preventing notifications: ${f.message}"),
          (_) => log("Notifications prevented for user: $firebaseUid"),
        );

        // 2) Remove local “registered” flag so next login can register again
        final flagKey = 'notificationsRegistered_$firebaseUid';
        await Prefs.remove(flagKey);

        // Optional: force refresh of FCM token on next login
        // await FirebaseMessaging.instance.deleteToken();

        // 3) Unregister NotificationsCubit singleton
        unregisterNotificationsCubitSingleton();

        // 4) Clear secure-stored user entity
        await SecureStorageService.deleteUserEntity();

        emit(MenuLogoutSuccess(message: message));
      },
    );
  }
}
