import 'package:deals/features/notifications/data/models/notification.dart';
import 'package:deals/features/notifications/domain/repos/notifications_repo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepo notificationsRepo;
  final String userId; // Obtain from your authentication system

  NotificationsCubit({
    required this.notificationsRepo,
    required this.userId,
  }) : super(NotificationsInitial()) {
    fetchNotifications();

    // Listen to FCM messages using the static getter.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Optionally, you can show an in-app notification banner here.
      // Then refresh notifications.
      fetchNotifications();
    });
  }

  Future<void> fetchNotifications() async {
    emit(NotificationsLoading());
    final result = await notificationsRepo.getNotificationsByUserId(userId);
    result.fold(
      (failure) => emit(NotificationsFailure(error: failure.message)),
      (notifications) =>
          emit(NotificationsSuccess(notifications: notifications)),
    );
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final result = await notificationsRepo.markNotificationsAsRead(
      userId: userId,
      notificationIds: [notificationId],
    );
    result.fold(
      (failure) => emit(NotificationsFailure(error: failure.message)),
      (_) async {
        await fetchNotifications(); // Refresh after update
      },
    );
  }
}
