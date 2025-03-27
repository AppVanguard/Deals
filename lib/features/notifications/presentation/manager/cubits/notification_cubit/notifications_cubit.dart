import 'package:deals/features/notifications/data/models/notification.dart';
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
    // Listen for FCM push in foreground. Insert new notifications on the fly.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleNewFcmMessage(message);
    });
  }

  void _handleNewFcmMessage(RemoteMessage message) {
    try {
      final newNotification = Notification.fromRemoteMessage(message);
      if (state is NotificationsSuccess) {
        final currentList = List<Notification>.from(
            (state as NotificationsSuccess).notifications);

        // Only add if not already present
        if (!currentList.any((n) => n.id == newNotification.id)) {
          currentList.insert(0, newNotification);
          emit(NotificationsSuccess(
              notifications: currentList, isRefreshing: false));
        }
      }
    } catch (e) {
      print('Error parsing FCM: $e');
    }
  }

  /// Called once to load notifications (or on user-initiated refresh).
  Future<void> fetchNotifications(String token) async {
    if (state is NotificationsInitial) {
      // Show a loading if we have absolutely no data
      emit(NotificationsLoading());
    } else if (state is NotificationsSuccess) {
      // If we already have data, just set isRefreshing = true for partial skeleton
      final current = (state as NotificationsSuccess).notifications;
      emit(NotificationsSuccess(notifications: current, isRefreshing: true));
    }

    final result = await notificationsRepo.getNotificationsByUserId(
      userId: userId,
      token: token,
    );
    result.fold(
      (failure) => emit(NotificationsFailure(error: failure.message)),
      (fetchedList) {
        // If we had old data, merge or replace as needed. Example: replace with new.
        emit(NotificationsSuccess(
            notifications: fetchedList, isRefreshing: false));
      },
    );
  }

  /// Mark a single notification as read, then refresh from repo
  Future<void> markNotificationAsRead(
      String notificationId, String token) async {
    final result = await notificationsRepo.markNotificationsAsRead(
      userId: userId,
      notificationIds: [notificationId],
      token: token,
    );
    result.fold(
      (failure) => emit(NotificationsFailure(error: failure.message)),
      (_) => fetchNotifications(token),
    );
  }
}
