import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:deals/core/errors/faliure.dart';
import 'package:deals/features/notifications/data/data_source/notifications_local_data_source.dart';
import 'package:deals/core/service/notifications_service.dart';
import 'package:deals/features/notifications/data/models/notification.dart';
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
  }) async {
    try {
      final NotificationsModel remoteModel =
          await service.getNotifications(firebaseUid: userId, token: token);
      final List<Notification> remoteList =
          remoteModel.data?.notifications ?? [];

      final localList = await localDataSource.getCachedNotifications(userId);

      // Merge read state from local cache.
      for (var remote in remoteList) {
        final localMatch = localList.firstWhereOrNull((l) => l.id == remote.id);
        if (localMatch != null && localMatch.read == true) {
          remote.read = true;
        }
      }

      await localDataSource.cacheNotifications(userId, remoteList);

      final domainList = remoteList
          .map((dataModel) => NotificationMapper.mapToEntity(dataModel))
          .toList();

      return Right(domainList);
    } catch (e) {
      log('Remote fetch failed: $e');
      final localList = await localDataSource.getCachedNotifications(userId);
      if (localList.isNotEmpty) {
        final domainList = localList
            .map((dataModel) => NotificationMapper.mapToEntity(dataModel))
            .toList();
        return Right(domainList);
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
      log('Error marking notifications as read: $e');
      return Left(ServerFaliure(message: e.toString()));
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
      log('Error deleting notification: $e');
      return Left(ServerFaliure(message: e.toString()));
    }
  }
}
