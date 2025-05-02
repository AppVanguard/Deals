import 'dart:developer';

import 'package:deals/features/personal_data/domain/repos/personal_data_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

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
    load(); // fetch on open
  }

  void load() async {
    emit(PersonalDataLoading());
    final Either<Failure, UserEntity> result =
        await _repo.getPersonalData(id: userId);
    result.fold(
      (f) => emit(PersonalDataFailure(message: f.message)),
      (user) => emit(PersonalDataSuccess(user: user)),
    );
  }

  /// Call this with any subset of:
  /// fullName, phone, country, city, dateOfBirth, gender.
  Future<void> updatePersonalData({
    String? fullName,
    String? phone,
    String? country,
    String? city,
    String? dateOfBirth,
    String? gender,
  }) async {
    emit(PersonalDataLoading());
    final Either<Failure, UserEntity> result = await _repo.updatePersonalData(
      id: userId,
      fullName: fullName,
      phone: phone,
      country: country,
      city: city,
      dateOfBirth: dateOfBirth,
      gender: gender,
    );
    result.fold(
      (f) => emit(PersonalDataFailure(message: f.message)),
      (user) => emit(PersonalDataSuccess(user: user)),
    );
  }
}
