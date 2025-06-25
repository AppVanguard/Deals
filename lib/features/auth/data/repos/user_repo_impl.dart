import 'package:deals/core/utils/logger.dart';
import 'package:dartz/dartz.dart';
import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/core/errors/failure.dart';
import 'package:deals/core/mappers/user_mapper.dart';
import 'package:deals/core/service/user_service.dart';
import 'package:deals/features/auth/domain/repos/user_repo.dart';

class UserRepoImpl extends UserRepo {
  final UserService _userService;
  UserRepoImpl({required UserService userService}) : _userService = userService;

  @override
  Future<Either<Failure, UserEntity>> getUserById(
      String id, String token) async {
    try {
      final model = await _userService.getUserById(id, token);
      return Right(UserMapper.mapToEntity(model));
    } catch (e) {
      appLog('Error in getUserById: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserAfterRegister({
    required String firebaseUid,
    String? country,
    String? city,
    String? dateOfBirth,
    String? gender,
    String? phone,
  }) async {
    try {
      final model = await _userService.updateUserAfterRegister(
        firebaseUid: firebaseUid,
        country: country,
        city: city,
        dateOfBirth: dateOfBirth,
        gender: gender,
        phone: phone,
      );
      return Right(UserMapper.mapToEntity(model));
    } catch (e) {
      appLog('Error in updateUserAfterRegister: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserData({
    required String id,
    String? country,
    String? city,
    String? dateOfBirth,
    String? gender,
    required String token,
  }) async {
    try {
      final model = await _userService.updateUserData(
        id: id,
        country: country,
        city: city,
        dateOfBirth: dateOfBirth,
        gender: gender,
        token: token,
      );
      return Right(UserMapper.mapToEntity(model));
    } catch (e) {
      appLog('Error in updateUserData: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
