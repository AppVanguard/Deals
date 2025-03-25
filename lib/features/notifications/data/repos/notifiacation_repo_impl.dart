import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:deals/core/errors/faliure.dart';
import 'package:deals/core/service/notifications_service.dart';
import 'package:deals/features/notifications/data/data_source/notifications_local_data_source.dart';
import 'package:deals/features/notifications/data/models/notification.dart';
import 'package:deals/features/notifications/domain/repos/notifications_repo.dart';

class NotificationsRepoImpl implements NotificationsRepo {
  final NotificationsService service;
  final NotificationsLocalDataSource localDataSource;

  NotificationsRepoImpl({
    required this.service,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Notification>>> getNotificationsByUserId(
      String userId) async {
    try {
      final remoteModel = await service.getNotifications(userId);
      final remoteList = remoteModel.data?.notifications ?? [];
      await localDataSource.cacheNotifications(userId, remoteList);
      return Right(remoteList);
    } catch (e) {
      log('Remote fetch failed: $e');
      final localList = await localDataSource.getCachedNotifications(userId);
      if (localList.isNotEmpty) {
        return Right(localList);
      } else {
        return Left(ServerFaliure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, void>> markNotificationsAsRead({
    required String userId,
    required List<String> notificationIds,
  }) async {
    try {
      await service.markAsRead(
          userId: userId, notificationIds: notificationIds);
      await localDataSource.markLocalNotificationsRead(
          userId: userId, notificationIds: notificationIds);
      return const Right(null);
    } catch (e) {
      log('markNotificationsAsRead error: $e');
      return Left(ServerFaliure(message: e.toString()));
    }
  }
}
