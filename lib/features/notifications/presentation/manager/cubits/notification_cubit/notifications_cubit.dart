import 'dart:developer';
import 'package:deals/features/notifications/domain/entities/notification_entity.dart';
import 'package:deals/features/notifications/domain/repos/notifications_repo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepo notificationsRepo;
  final String userId;

  NotificationsCubit({
    required this.notificationsRepo,
    required this.userId,
  }) : super(NotificationsInitial()) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Foreground FCM message received: ${message.data}");
      _handleNewFcmMessage(message);
    });
  }

  void _handleNewFcmMessage(RemoteMessage message) {
    try {
      // Build a data map from FCM message:
      // Use backend provided '_id' if available; fallback to message.messageId.
      final Map<String, dynamic> data = {
        '_id': message.data['_id'] ?? message.messageId,
        'title': message.notification?.title ?? message.data['title'],
        'body': message.notification?.body ?? message.data['body'],
        'image': message.data['image'],
        'coupon': message.data['coupon'],
      };

      final newEntity = NotificationEntity.fromRemoteMessage(data);
      log("Parsed FCM message: image: ${newEntity.image} title: ${newEntity.title} body: ${newEntity.body} id: ${newEntity.id} coupon: ${newEntity.coupon}");

      if (state is NotificationsSuccess) {
        final currentList = List<NotificationEntity>.from(
            (state as NotificationsSuccess).notifications);
        // If a notification with the same coupon already exists, update it.
        final index = currentList.indexWhere(
            (n) => n.coupon == newEntity.coupon && newEntity.coupon != null);
        if (index != -1) {
          final old = currentList[index];
          final updated = NotificationEntity(
            id: newEntity.id, // update with real id from backend
            userId: old.userId,
            title: old.title,
            body: old.body,
            read: old.read,
            createdAt: old.createdAt,
            image: newEntity.image, // update image if available
            coupon: newEntity.coupon,
          );
          currentList[index] = updated;
          emit(NotificationsSuccess(
              notifications: currentList, isRefreshing: false));
        } else if (!currentList.any((n) => n.id == newEntity.id)) {
          // Otherwise, insert the new notification if it's not already present.
          currentList.insert(0, newEntity);
          emit(NotificationsSuccess(
              notifications: currentList, isRefreshing: false));
        }
      }
    } catch (e) {
      log('Error parsing FCM message: $e');
    }
  }

  Future<void> fetchNotifications(String token) async {
    List<NotificationEntity> currentList = [];
    if (state is NotificationsSuccess) {
      currentList = (state as NotificationsSuccess).notifications;
      emit(
          NotificationsSuccess(notifications: currentList, isRefreshing: true));
    } else {
      emit(NotificationsLoading());
    }
    final result = await notificationsRepo.getNotificationsByUserId(
      userId: userId,
      token: token,
    );
    result.fold(
      (failure) => emit(NotificationsFailure(error: failure.message)),
      (fetchedList) {
        final newEntities = fetchedList
            .where((entity) =>
                !currentList.any((existing) => existing.id == entity.id))
            .toList();
        final mergedList = [...newEntities, ...currentList];
        mergedList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        emit(NotificationsSuccess(
            notifications: mergedList, isRefreshing: false));
      },
    );
  }

  Future<void> markNotificationAsRead(
      String notificationId, String token) async {
    final result = await notificationsRepo.markNotificationsAsRead(
      userId: userId,
      notificationIds: [notificationId],
      token: token,
    );
    result.fold(
      (failure) => emit(NotificationsFailure(error: failure.message)),
      (_) {
        if (state is NotificationsSuccess) {
          final currentList = List<NotificationEntity>.from(
              (state as NotificationsSuccess).notifications);
          final index = currentList.indexWhere((n) => n.id == notificationId);
          if (index != -1) {
            final old = currentList[index];
            final updated = NotificationEntity(
              id: old.id,
              userId: old.userId,
              title: old.title,
              body: old.body,
              read: true,
              createdAt: old.createdAt,
              image: old.image,
              coupon: old.coupon,
            );
            currentList[index] = updated;
            emit(NotificationsSuccess(
                notifications: currentList, isRefreshing: false));
          }
        }
      },
    );
  }

  Future<void> removeNotification(String notificationId) async {
    final result = await notificationsRepo.deleteNotification(
      userId: userId,
      notificationId: notificationId,
    );
    result.fold(
      (failure) => emit(NotificationsFailure(error: failure.message)),
      (_) {
        if (state is NotificationsSuccess) {
          final currentList = List<NotificationEntity>.from(
              (state as NotificationsSuccess).notifications);
          currentList.removeWhere((n) => n.id == notificationId);
          emit(NotificationsSuccess(
              notifications: currentList, isRefreshing: false));
        }
      },
    );
  }
}
