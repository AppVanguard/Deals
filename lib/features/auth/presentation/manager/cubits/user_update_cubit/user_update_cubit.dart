import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_pocket/core/service/user_service.dart';
import 'package:meta/meta.dart';
import 'package:in_pocket/features/auth/domain/entities/user_entity.dart';

part 'user_update_state.dart';

class UserUpdateCubit extends Cubit<UserUpdateState> {
  final UserService userService;

  UserUpdateCubit({required this.userService}) : super(UserUpdateInitial());

  /// Calls the updateUserData API and emits appropriate states.
  Future<void> updateUser({
    required String id,
    required String fullName,
    required String phone,
    String? country,
    String? city,
    String? dateOfBirth,
    String? gender,
  }) async {
    emit(UserUpdateLoading());
    try {
      final updatedUser = await userService.updateUserData(
        id: id,
        fullName: fullName,
        phone: phone,
        country: country,
        city: city,
        dateOfBirth: dateOfBirth,
        gender: gender,
      );
      emit(UserUpdateSuccess(
          userEntity: updatedUser, message: "User updated successfully"));
    } catch (e) {
      emit(UserUpdateFailure(message: e.toString()));
    }
  }
}
