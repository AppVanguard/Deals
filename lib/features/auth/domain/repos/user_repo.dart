import 'package:dartz/dartz.dart';
import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/core/errors/faliure.dart';

abstract class UserRepo {
  Future<Either<Failure, UserEntity>> getUserById(String id, String token);

  Future<Either<Failure, UserEntity>> updateUserAfterRegister({
    required String firebaseUid,
    String? country,
    String? city,
    String? dateOfBirth,
    String? gender,
    String? phone,
  });

  /// PATCH /users/:id  (needs token)
  Future<Either<Failure, UserEntity>> updateUserData({
    required String id,
    String? country,
    String? city,
    String? dateOfBirth,
    String? gender,
    required String token,
  });
}
