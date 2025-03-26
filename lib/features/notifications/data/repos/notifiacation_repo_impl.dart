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
  Future<Either<Failure, List<Notification>>> getNotificationsByUserId({
    required String userId,
    required String token,
  }) async {
    try {
      // 1) Fetch from remote
      final remoteModel =
          await service.getNotifications(userId: userId, token: token);
      final remoteList = remoteModel.data?.notifications ?? [];

      // 2) Cache each notification in Hive
      await localDataSource.cacheNotifications(userId, remoteList);

      // 3) Return the fresh list
      return Right(remoteList);
    } catch (e) {
      log('Remote fetch failed: $e');
      // 4) Fallback to local
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
    required String token,
  }) async {
    try {
      // 1) Remote patch
      await service.markAsRead(
          userId: userId, notificationIds: notificationIds, token: token);

      // 2) Local update
      await localDataSource.markLocalNotificationsRead(
        userId: userId,
        notificationIds: notificationIds,
      );

      return const Right(null);
    } catch (e) {
      log('Error marking notifications as read: $e');
      return Left(ServerFaliure(message: e.toString()));
    }
  }
}
