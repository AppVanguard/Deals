import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:in_pocket/core/errors/faliure.dart';
import 'package:in_pocket/core/service/auth_api_service.dart';
import 'package:in_pocket/features/home/domain/repos/menu_repo.dart';

class MenuRepoImpl implements MenuRepo {
  final AuthApiService authApiService;

  MenuRepoImpl({required this.authApiService});

  @override
  Future<Either<Failure, String>> logOut({required String firebaseUid}) async {
    try {
      log("try to logout");
      authApiService.logout(firebaseUid: firebaseUid);
      log('Logout completed successfully.');
      return const Right('Logout completed successfully.');
    } catch (e) {
      log('Logout failed: $e');
      return Left(ServerFaliure(message: 'Logout failed.'));
    }
  }
}
