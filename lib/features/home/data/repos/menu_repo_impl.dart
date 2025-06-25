import 'package:deals/core/utils/logger.dart';

import 'package:dartz/dartz.dart';
import 'package:deals/constants.dart';
import 'package:deals/core/errors/failure.dart';
import 'package:deals/core/service/auth_api_service.dart';
import 'package:deals/core/service/shared_prefrences_singleton.dart';
import 'package:deals/features/home/domain/repos/menu_repo.dart';

class MenuRepoImpl implements MenuRepo {
  final AuthApiService authApiService;

  MenuRepoImpl({required this.authApiService});

  @override
  Future<Either<Failure, String>> logOut({required String firebaseUid}) async {
    try {
      appLog("try to logout");
      authApiService.logout(firebaseUid: firebaseUid);

      // 1) Turn off "remember me"
      Prefs.setBool(kRememberMe, false);

      appLog('Logout completed successfully.');
      return const Right('Logout completed successfully.');
    } catch (e) {
      appLog('Logout failed: $e');
      return Left(ServerFailure(message: 'Logout failed.'));
    }
  }
}
