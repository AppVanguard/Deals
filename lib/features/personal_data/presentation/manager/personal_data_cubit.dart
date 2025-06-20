import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:deals/core/manager/cubit/requires_user_mixin.dart';

import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/core/errors/failure.dart';
import 'package:deals/features/personal_data/domain/repos/personal_data_repo.dart';

part 'personal_data_state.dart';

class PersonalDataCubit extends Cubit<PersonalDataState>
    with RequiresUser<PersonalDataState> {
  final PersonalDataRepo _repo;
  final String userId;

  PersonalDataCubit({
    required PersonalDataRepo repo,
    required this.userId,
  })  : _repo = repo,
        super(PersonalDataInitial()) {
    fetchPersonalData();
  }

  /*────────────────── initial GET ──────────────────*/

  Future<void> fetchPersonalData() async {
    emit(PersonalDataLoadInProgress());

    final storedUser =
        await requireUser((msg) => PersonalDataLoadFailure(msg));
    if (storedUser == null) return;

    final Either<Failure, UserEntity> res =
        await _repo.getPersonalData(id: userId, token: storedUser.token);

    res.fold(
      (f) => emit(PersonalDataLoadFailure(f.message)),
      (u) {
        // Merge token from secure-storage in case GET /users doesn’t include it
        final merged = _mergeUserWithToken(u, storedUser.token);
        emit(PersonalDataLoadSuccess(merged));
      },
    );
  }

  /*────────────────── PATCH update ──────────────────*/

  Future<void> updatePersonalData({
    String? fullName,
    String? phone,
    String? country,
    String? city,
    String? dateOfBirth,
    String? gender,
  }) async {
    emit(PersonalDataUpdateInProgress());

    // Load current user to preserve the existing JWT
    final storedUser =
        await requireUser((msg) => PersonalDataUpdateFailure(msg));
    if (storedUser == null) return;

    final Either<Failure, UserEntity> res = await _repo.updatePersonalData(
      id: userId,
      fullName: fullName,
      phone: phone,
      country: country,
      city: city,
      dateOfBirth: dateOfBirth,
      gender: gender,
      token: storedUser.token,
    );

    res.fold(
      (f) => emit(PersonalDataUpdateFailure(f.message)),
      (updated) {
        final merged = _mergeUserWithToken(updated, storedUser.token);
        emit(PersonalDataUpdateSuccess(merged));
      },
    );
  }

  /*───────────────── helper ─────────────────*/

  /// Ensures the returned `UserEntity` keeps the old auth token.
  UserEntity _mergeUserWithToken(UserEntity user, String token) {
    // If your UserEntity already has copyWith → use it
    try {
      return user.copyWith(token: token);
    } catch (_) {
      // Manual rebuild fallback
      return UserEntity(
        id: user.id,
        uId: user.uId,
        token: token,
        fullName: user.fullName,
        email: user.email,
        phone: user.phone,
        country: user.country,
        city: user.city,
        dateOfBirth: user.dateOfBirth,
        gender: user.gender,
      );
    }
  }
}
