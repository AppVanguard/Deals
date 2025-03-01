import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:deals/core/errors/faliure.dart';
import 'package:deals/core/service/user_service.dart';
import 'package:deals/features/auth/domain/entities/user_entity.dart';
import 'package:deals/features/auth/domain/repos/user_repo.dart';

class UserRepoImpl extends UserRepo {
  final UserService userService;

  UserRepoImpl({required this.userService});

  @override
  Future<Either<Failure, List<UserEntity>>> getAllUsers() async {
    try {
      final users = await userService.getAllUsers();
      return right(users);
    } catch (e) {
      log('Error in UserRepoImpl.getAllUsers: $e');
      return left(ServerFaliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserById(String id) async {
    try {
      final user = await userService.getUserById(id);
      return right(user);
    } catch (e) {
      log('Error in UserRepoImpl.getUserById: $e');
      return left(ServerFaliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserData({
    required String id,
    String? country,
    String? city,
    String? dateOfBirth,
    String? gender,
  }) async {
    try {
      final updatedUser = await userService.updateUserData(
        id: id,
        country: country,
        city: city,
        dateOfBirth: dateOfBirth,
        gender: gender,
      );
      return right(updatedUser);
    } catch (e) {
      log('Error in UserRepoImpl.updateUserData: $e');
      return left(ServerFaliure(message: e.toString()));
    }
  }
}
