// lib/features/profile/domain/repos/personal_data_repo.dart

import 'package:dartz/dartz.dart';
import 'package:deals/core/errors/faliure.dart';
import 'package:deals/core/entities/user_entity.dart';

abstract class PersonalDataRepo {
  /// Fetch the current user profile by its [id].
  Future<Either<Failure, UserEntity>> getPersonalData({
    required String id,
  });

  /// Update any subset of the user’s editable fields.
  Future<Either<Failure, UserEntity>> updatePersonalData({
    required String id,
    String? fullName,
    String? phone,
    String? country,
    String? city,
    String? dateOfBirth,
    String? gender,
  });
}
