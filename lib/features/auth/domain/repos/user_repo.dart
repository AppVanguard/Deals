import 'package:dartz/dartz.dart';
import 'package:in_pocket/core/errors/faliure.dart';
import 'package:in_pocket/features/auth/domain/entities/user_entity.dart';

abstract class UserRepo {
  Future<Either<Failure, List<UserEntity>>> getAllUsers();
  Future<Either<Failure, UserEntity>> getUserById(String id);
  Future<Either<Failure, UserEntity>> updateUserData({
    required String id,
    required String fullName,
    required String phone,
    String? country,
    String? city,
    String? dateOfBirth,
    String? gender,
  });
}
