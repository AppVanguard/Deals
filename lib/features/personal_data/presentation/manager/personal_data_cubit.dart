// lib/features/profile/presentation/manager/personal_data_cubit/personal_data_cubit.dart

import 'package:deals/core/service/secure_storage_service.dart';
import 'package:deals/features/personal_data/domain/repos/personal_data_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:deals/core/errors/faliure.dart';
import 'package:deals/core/entities/user_entity.dart';

part 'personal_data_state.dart';

class PersonalDataCubit extends Cubit<PersonalDataState> {
  final PersonalDataRepo _repo;
  final String userId;

  PersonalDataCubit({
    required PersonalDataRepo repo,
    required this.userId,
  })  : _repo = repo,
        super(PersonalDataInitial()) {
    fetchPersonalData();
  }

  /// Initial load of the user’s data
  Future<void> fetchPersonalData() async {
    emit(PersonalDataLoadInProgress());
    final user = await SecureStorageService.getCurrentUser();

    final Either<Failure, UserEntity> result =
        await _repo.getPersonalData(id: userId, token: user!.token);
    result.fold(
      (f) => emit(PersonalDataLoadFailure(f.message)),
      (u) => emit(PersonalDataLoadSuccess(u)),
    );
  }

  /// Partial update (PATCH) of any fields
  Future<void> updatePersonalData({
    String? fullName,
    String? phone,
    String? country,
    String? city,
    String? dateOfBirth,
    String? gender,
  }) async {
    emit(PersonalDataUpdateInProgress());
    final user = await SecureStorageService.getCurrentUser();

    final Either<Failure, UserEntity> result = await _repo.updatePersonalData(
      id: userId,
      fullName: fullName,
      phone: phone,
      country: country,
      city: city,
      dateOfBirth: dateOfBirth,
      gender: gender,
      token: user!.token,
    );
    result.fold(
      (f) => emit(PersonalDataUpdateFailure(f.message)),
      (u) => emit(PersonalDataUpdateSuccess(u)),
    );
  }
}
