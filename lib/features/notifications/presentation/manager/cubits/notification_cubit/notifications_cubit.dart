import 'dart:developer';
import 'package:deals/core/manager/cubit/safe_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';
import 'package:deals/features/notifications/domain/entities/notification_entity.dart';
import 'package:deals/features/notifications/domain/repos/notifications_repo.dart';

part 'notifications_state.dart';

class NotificationsCubit extends SafeCubit<NotificationsState> {
  final NotificationsRepo notificationsRepo;
  final String userId;

  String? _cachedToken;
  final int _limit = 20;
  int _offset = 0;
  bool _hasMore = true;

  NotificationsCubit({
    required this.notificationsRepo,
    required this.userId,
  }) : super(NotificationsInitial()) {
    // NO onMessage.listen(...) here
  }

  // Called from main.dart's single FCM listener when a new push arrives
  void handleIncomingForegroundMessage(RemoteMessage message) {
    final data = message.data;
    log("handleIncomingForegroundMessage: $data");

    if (data['_id'] != null && data['_id'].toString().isNotEmpty) {
      if (state is NotificationsSuccess) {
        final s = state as NotificationsSuccess;
        final newEntity = NotificationEntity.fromRemoteMessage({
          '_id': data['_id'],
          'title': message.notification?.title ?? data['title'],
          'body': message.notification?.body ?? data['body'],
          'image': data['image'],
        });
        final currentList = List<NotificationEntity>.from(s.notifications);
        if (!currentList.any((n) => n.id == newEntity.id)) {
          currentList.insert(0, newEntity);
          emit(s.copyWith(
            notifications: currentList,
            isLoadingMore: false,
            newLoadCount: 0,
          ));
        }
      } else {
        // if not in success state, do a forced fetch if we have a token
        if (_cachedToken != null) {
          fetchNotifications(_cachedToken!, reset: true);
        }
      }
    } else {
      // data incomplete => forced fetch
      if (_cachedToken != null) {
        fetchNotifications(_cachedToken!, reset: true);
      }
    }
  }

  Future<void> fetchNotifications(String token, {bool reset = false}) async {
    _cachedToken = token;
    if (reset) {
      _offset = 0;
      _hasMore = true;
      emit(NotificationsLoading());
    }

    List<NotificationEntity> currentList = [];
    if (!reset && state is NotificationsSuccess) {
      final s = state as NotificationsSuccess;
      currentList = s.notifications;
      emit(s.copyWith(isRefreshing: true));
    } else if (!reset) {
      emit(NotificationsLoading());
    }

    final result = await notificationsRepo.getNotificationsByUserId(
      userId: userId,
      token: token,
      limit: _limit,
      offset: _offset,
    );

    result.fold(
      (failure) => emit(NotificationsFailure(error: failure.message)),
      (fetchedList) {
        final newEntities = fetchedList
            .where((entity) => !currentList.any((old) => old.id == entity.id))
            .toList();
        final mergedList = [...currentList, ...newEntities];
        mergedList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        if (fetchedList.length < _limit) {
          _hasMore = false;
        }

        emit(NotificationsSuccess(
          notifications: mergedList,
          isRefreshing: false,
          isLoadingMore: false,
          newLoadCount: 0,
          hasMore: _hasMore,
          offset: _offset,
        ));
      },
    );
  }

  Future<void> loadMoreNotifications() async {
    if (!_hasMore) {
      log("No more notifications to load.");
      return;
    }
    if (_cachedToken == null) {
      log("No token. Can't load more yet.");
      return;
    }
    if (state is NotificationsSuccess) {
      var s = state as NotificationsSuccess;
      s = s.copyWith(isLoadingMore: true, newLoadCount: _limit);
      emit(s);
    } else {
      return;
    }

    _offset += _limit;
    final result = await notificationsRepo.getNotificationsByUserId(
      userId: userId,
      token: _cachedToken!,
      limit: _limit,
      offset: _offset,
    );

    result.fold(
      (failure) {
        _offset -= _limit;
        emit(NotificationsFailure(error: failure.message));
      },
      (fetchedList) {
        if (state is NotificationsSuccess) {
          var s = state as NotificationsSuccess;
          final currentList = List<NotificationEntity>.from(s.notifications);
          final newEntities = fetchedList
              .where((e) => !currentList.any((old) => old.id == e.id))
              .toList();
          currentList.addAll(newEntities);
          currentList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          if (fetchedList.length < _limit) {
            _hasMore = false;
          }

          emit(s.copyWith(
            notifications: currentList,
            isRefreshing: false,
            isLoadingMore: false,
            newLoadCount: 0,
            hasMore: _hasMore,
            offset: _offset,
          ));
        }
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
          final s = state as NotificationsSuccess;
          final currentList = List<NotificationEntity>.from(s.notifications);
          final index = currentList.indexWhere((n) => n.id == notificationId);
          if (index != -1) {
            final old = currentList[index];
            final updated = old.copyWith(read: true);
            currentList[index] = updated;
            emit(s.copyWith(notifications: currentList, isRefreshing: false));
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
          final s = state as NotificationsSuccess;
          final currentList = List<NotificationEntity>.from(s.notifications);
          currentList.removeWhere((n) => n.id == notificationId);
          emit(s.copyWith(notifications: currentList, isRefreshing: false));
        }
      },
    );
  }
}
