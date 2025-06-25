import 'package:deals/core/manager/cubit/safe_cubit.dart';
import 'package:meta/meta.dart';
import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/features/auth/domain/repos/user_repo.dart';

part 'user_update_state.dart';

class UserUpdateCubit extends SafeCubit<UserUpdateState> {
  final UserRepo userRepo;
  UserUpdateCubit({required this.userRepo}) : super(UserUpdateInitial());

  /// يستخدم بعد إنشاء الحساب مباشرة
  /// (PATCH /users/updateAfterRegister/:firebase_uid)
  Future<void> updateUserAfterRegister({
    required String firebaseUid,
    String? country,
    String? city,
    String? dateOfBirth,
    String? gender,
    String? phone,
  }) async {
    emit(UserUpdateLoading());

    final result = await userRepo.updateUserAfterRegister(
      firebaseUid: firebaseUid,
      country: country,
      city: city,
      dateOfBirth: dateOfBirth,
      gender: gender,
      phone: phone,
    );

    result.fold(
      (failure) => emit(UserUpdateFailure(message: failure.message)),
      (updatedUser) => emit(
        UserUpdateSuccess(
          userEntity: updatedUser,
          message: 'User updated successfully',
        ),
      ),
    );
  }
}
