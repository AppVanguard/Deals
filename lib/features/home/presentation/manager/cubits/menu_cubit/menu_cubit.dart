import 'dart:developer';
import 'package:deals/core/repos/interface/notifications_permission_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:deals/core/service/get_it_service.dart';
import 'package:deals/core/service/secure_storage_service.dart';
import 'package:deals/features/home/domain/repos/menu_repo.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final MenuRepo menuRepo;

  final NotificationsPermissionRepo notificationsPermissionRepo;

  MenuCubit({
    required this.menuRepo,
    required this.notificationsPermissionRepo,
  }) : super(MenuInitial());

  Future<void> logout(
      {required String firebaseUid, required String authToken}) async {
    emit(MenuLoading());
    final result = await menuRepo.logOut(firebaseUid: firebaseUid);
    result.fold(
      (failure) {
        emit(MenuLogoutFailure(message: failure.message));
      },
      (message) async {
        log("Logout succeeded: $message");

        // 1) Prevent notifications on server
        final preventResult =
            await notificationsPermissionRepo.preventNotifications(
          userId: firebaseUid,
          authToken: authToken,
        );
        preventResult.fold(
          (failure) =>
              log("Error preventing notifications: ${failure.message}"),
          (_) => log(
              "Notifications prevented successfully for user: $firebaseUid"),
        );

        // 2) Unregister old NotificationsCubit
        unregisterNotificationsCubitSingleton();
        log("Unregistered old NotificationsCubit singleton.");

        // 3) Clear user data
        await SecureStorageService.deleteUserEntity();

        emit(MenuLogoutSuccess(message: message));
      },
    );
  }
}
