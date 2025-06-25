import 'package:deals/core/utils/dev_log.dart';
import 'package:dartz/dartz.dart';
import 'package:deals/core/errors/failure.dart';
import 'package:deals/core/repos/interface/notifications_permission_repo.dart';
import 'package:deals/core/service/notifications_permission_service.dart';

class NotificationsPermissionRepoImpl implements NotificationsPermissionRepo {
  final NotificationsPermissionService service;

  NotificationsPermissionRepoImpl({required this.service});

  @override
  Future<Either<Failure, void>> allowNotifications({
    required String firebaseUid,
    required String deviceToken,
    required String authToken,
  }) async {
    try {
      await service.allowNotifications(
        firebaseUid: firebaseUid,
        deviceToken: deviceToken,
        authToken: authToken,
      );
      return const Right(null);
    } catch (e, s) {
      log('Error in allowNotifications: $e\n$s');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> preventNotifications({
    required String userId,
    required String authToken,
  }) async {
    try {
      await service.preventNotifications(
        firebaseUid: userId,
        authToken: authToken,
      );
      return const Right(null);
    } catch (e, s) {
      log('Error in preventNotifications: $e\n$s');
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
