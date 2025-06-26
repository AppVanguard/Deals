import 'package:dartz/dartz.dart';
import 'package:deals/constants.dart';
import 'package:deals/core/service/get_it_service.dart';
import 'package:deals/core/utils/firebase_utils.dart';

import 'package:deals/core/errors/failure.dart';
import 'package:deals/core/manager/cubit/requires_user_mixin.dart';
import 'package:deals/core/service/secure_storage_service.dart';
import 'package:deals/core/service/shared_prefrences_singleton.dart';
import 'package:deals/features/settings/domain/repos/settings_repo.dart';
import 'package:deals/core/manager/cubit/safe_cubit.dart';

part 'settings_state.dart';

class SettingsCubit extends SafeCubit<SettingsState>
    with RequiresUser<SettingsState> {
  final SettingsRepo _repo;
  SettingsCubit({required SettingsRepo repo})
      : _repo = repo,
        super(SettingsInitial()) {
    _loadInitialPushState();
  }

  /// Reads the saved push setting from prefs.
  Future<void> _loadInitialPushState() async {
    final enabled = Prefs.getBool('pushEnabled');
    emit(SettingsPushSuccess(isEnabled: enabled));
  }

  /// Toggle server‐side allow/prevent notifications.
  Future<void> togglePush(bool enabled) async {
    emit(SettingsLoading());

    // load current user
    final user = await requireUser((msg) => SettingsPushFailure(message: msg));
    if (user == null) return;

    // get FCM token
    final deviceToken = await initFirebaseMessaging();
    if (deviceToken == null) {
      emit(SettingsPushFailure(message: 'FCM token not available'));
      return;
    }

    Either<Failure, Unit> res;
    if (enabled) {
      res = await _repo.allowPushNotifications(
        firebaseUid: user.uId,
        deviceToken: deviceToken,
        authToken: user.token,
      );
    } else {
      res = await _repo.disablePushNotifications(
        firebaseUid: user.uId,
        authToken: user.token,
      );
    }

    res.fold(
      (f) => emit(SettingsPushFailure(message: f.message)),
      (_) {
        Prefs.setBool('pushEnabled', enabled);
        emit(SettingsPushSuccess(isEnabled: enabled));
      },
    );
  }

  /// Change the current user's password.
  Future<void> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
    required String authToken,
  }) async {
    emit(SettingsLoading());

    final Either<Failure, String> res = await _repo.changePassword(
      email: email,
      currentPassword: currentPassword,
      newPassword: newPassword,
      authToken: authToken,
    );

    res.fold(
      (f) => emit(SettingsChangePasswordFailure(message: f.message)),
      (msg) => emit(SettingsChangePasswordSuccess(message: msg)),
    );
  }

  /// Delete the current user's account.
  Future<void> deleteAccount({
    required String firebaseUid,
    required String authToken,
  }) async {
    emit(SettingsLoading());

    final Either<Failure, String> res = await _repo.deleteAccount(
      firebaseUid: firebaseUid,
      authToken: authToken,
    );

    res.fold(
      (f) => emit(SettingsDeleteAccountFailure(message: f.message)),
      (msg) async {
        // 1) Turn off “remember me”
        Prefs.setBool(kRememberMe, false);

        // 3) Remove the local “registered” flag
        await Prefs.remove('notificationsRegistered_$firebaseUid');

        // 5) Unregister the NotificationsCubit singleton
        unregisterNotificationsCubitSingleton();

        // 6) Clear the secure‐stored user entity
        await SecureStorageService.deleteUserEntity();

        // Finally emit success
        emit(SettingsDeleteAccountSuccess(message: msg));
      },
    );
  }
}
