import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/features/auth/domain/repos/user_repo.dart';

part 'user_update_state.dart';

class UserUpdateCubit extends Cubit<UserUpdateState> {
  final UserRepo userRepo;

  UserUpdateCubit({required this.userRepo}) : super(UserUpdateInitial());

  Future<void> updateUser({
    required String id,
    String? country,
    String? city,
    String? dateOfBirth,
    String? gender,
  }) async {
    emit(UserUpdateLoading());
    final result = await userRepo.updateUserData(
      id: id,
      country: country,
      city: city,
      dateOfBirth: dateOfBirth,
      gender: gender,
    );
    result.fold(
      (failure) => emit(UserUpdateFailure(message: failure.message)),
      (updatedUser) => emit(UserUpdateSuccess(
        userEntity: updatedUser,
        message: "User updated successfully",
      )),
    );
  }
}
