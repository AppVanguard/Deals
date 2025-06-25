import 'package:deals/core/utils/logger.dart';
import 'package:dartz/dartz.dart';
import 'package:deals/core/errors/failure.dart';
import 'package:deals/core/service/notifications_service.dart';
import 'package:deals/features/notifications/data/data_source/notifications_local_data_source.dart';
import 'package:deals/features/notifications/data/models/notification.dart'
    as DataModel;
import 'package:deals/features/notifications/data/models/notifications_model.dart';
import 'package:deals/features/notifications/domain/entities/notification_entity.dart';
import 'package:deals/features/notifications/domain/mappers/notification_mapper.dart';
import 'package:deals/features/notifications/domain/repos/notifications_repo.dart';
import 'package:collection/collection.dart';

class NotificationsRepoImpl implements NotificationsRepo {
  final NotificationsService service;
  final NotificationsLocalDataSource localDataSource;

  NotificationsRepoImpl({
    required this.service,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotificationsByUserId({
    required String userId,
    required String token,
    required int limit,
    required int offset,
  }) async {
    try {
      // 1) Fetch from remote with limit/offset
      final NotificationsModel remoteModel = await service.getNotifications(
        firebaseUid: userId,
        token: token,
        limit: limit,
        offset: offset,
      );
      final List<DataModel.Notification> remoteList =
          remoteModel.data?.notifications ?? [];

      // 2) Merge read state from local
      final localList = await localDataSource.getCachedNotifications(userId);
      for (var remote in remoteList) {
        final localMatch = localList.firstWhereOrNull((l) => l.id == remote.id);
        if (localMatch != null && localMatch.read == true) {
          remote.read = true;
        }
      }

      // 3) Cache them
      await localDataSource.cacheNotifications(userId, remoteList);

      // 4) Convert to domain
      final domainList = remoteList
          .map((dataModel) => NotificationMapper.mapToEntity(dataModel))
          .toList();

      return Right(domainList);
    } catch (e) {
      appLog('Remote fetch failed: $e');
      // fallback to local
      final localList = await localDataSource.getCachedNotifications(userId);
      if (localList.isNotEmpty) {
        final domainList = localList
            .map((dataModel) => NotificationMapper.mapToEntity(dataModel))
            .toList();
        return Right(domainList);
      } else {
        return Left(ServerFailure(message: e.toString()));
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
      await service.markAsRead(
        firebaseUid: userId,
        notificationIds: notificationIds,
        token: token,
      );
      await localDataSource.markLocalNotificationsRead(
        userId: userId,
        notificationIds: notificationIds,
      );
      return const Right(null);
    } catch (e) {
      appLog('Error marking notifications as read: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification({
    required String userId,
    required String notificationId,
  }) async {
    try {
      await localDataSource.deleteNotification(userId, notificationId);
      return const Right(null);
    } catch (e) {
      appLog('Error deleting notification: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
