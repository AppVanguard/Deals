// lib/features/personal_data/data/repos/presonal_data_repo_impl.dart

import 'package:deals/core/utils/logger.dart';

import 'package:dartz/dartz.dart';
import 'package:deals/core/errors/failure.dart';
import 'package:deals/core/mappers/user_mapper.dart';
import 'package:deals/core/service/user_service.dart';
import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/features/personal_data/domain/repos/personal_data_repo.dart';

class PersonalDataRepoImpl implements PersonalDataRepo {
  final UserService _userService;

  PersonalDataRepoImpl({required UserService userService})
      : _userService = userService;

  @override
  Future<Either<Failure, UserEntity>> getPersonalData({
    required String token,
    required String id,
  }) async {
    try {
      final model = await _userService.getUserById(id, token);
      return Right(UserMapper.mapToEntity(model));
    } catch (e) {
      appLog('getPersonalData error: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updatePersonalData({
    required String id,
    String? fullName,
    String? phone,
    String? country,
    String? city,
    String? dateOfBirth,
    String? gender,
    required String token,
  }) async {
    try {
      final model = await _userService.updateUserData(
        id: id,
        fullName: fullName,
        phone: phone,
        country: country,
        city: city,
        dateOfBirth: dateOfBirth,
        gender: gender,
        token: token,
      );
      return Right(UserMapper.mapToEntity(model));
    } catch (e) {
      appLog('updatePersonalData error: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
