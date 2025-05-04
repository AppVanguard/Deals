
import 'package:deals/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:deals/core/errors/faliure.dart';
import 'package:deals/core/service/secure_storage_service.dart';
import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/core/service/shared_prefrences_singleton.dart';
import 'package:deals/features/settings/domain/repos/settings_repo.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepo _repo;

  SettingsCubit({required SettingsRepo repo})
      : _repo = repo,
        super(SettingsInitial());

  /// Toggle notifications on/off
  Future<void> togglePush(bool enabled) async {
    emit(SettingsLoading());

    // 1) load current user
    final json = await SecureStorageService.getUserEntity();
    if (json == null) {
      emit(SettingsPushFailure(message: 'User not found'));
      return;
    }
    final user = UserEntity.fromJson(json);

    // 2) get FCM device token for allow() call
    final deviceToken = await FirebaseMessaging.instance.getToken() ?? '';

    // 3) call server
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

    // 4) handle result
    res.fold(
      (f) => emit(SettingsPushFailure(message: f.message)),
      (_) {
        // persist choice
        Prefs.setBool(kPushEnabled, enabled);
        emit(SettingsPushSuccess(isEnabled: enabled));
      },
    );
  }
}
