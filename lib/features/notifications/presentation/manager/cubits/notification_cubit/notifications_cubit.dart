import 'package:deals/core/utils/logger.dart';
import 'package:deals/core/manager/cubit/safe_cubit.dart';
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
          hasMore: _hasMore,
          offset: _offset,
        ));
      },
    );
  }

  Future<void> loadMoreNotifications() async {
    if (!_hasMore) {
      appLog("No more notifications to load.");
      return;
    }
    if (_cachedToken == null) {
      appLog("No token. Can't load more yet.");
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
