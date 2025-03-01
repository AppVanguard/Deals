import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/core/service/secure_storage_service.dart';
import 'package:deals/features/home/domain/repos/menu_repo.dart';
import 'package:meta/meta.dart';
part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final MenuRepo menuRepo;

  MenuCubit({required this.menuRepo}) : super(MenuInitial());

  /// Logs out the user by calling the repository method.
  Future<void> logout({required String firebaseUid}) async {
    emit(MenuLoading());
    final result = await menuRepo.logOut(firebaseUid: firebaseUid);
    result.fold(
      (failure) {
        log("Logout failed: ${failure.message}");
        emit(MenuLogoutFailure(message: failure.message));
      },
      (message) {
        SecureStorageService.deleteUserEntity();
        log("Logout succeeded: $message");
        emit(MenuLogoutSuccess(message: message));
      },
    );
  }
}
