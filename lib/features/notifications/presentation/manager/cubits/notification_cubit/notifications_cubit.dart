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
    // Optionally, you can initialize a fetch here if you have a token at construction time.
    // fetchNotifications(token);
    // Listen to push messages if you want auto-refresh:
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // If you want to auto-refresh, call fetchNotifications with a valid token here.
    });
  }

  Future<void> fetchNotifications(String token) async {
    emit(NotificationsLoading());
    final result = await notificationsRepo.getNotificationsByUserId(
      userId: userId,
      token: token,
    );
    result.fold(
      (failure) => emit(NotificationsFailure(error: failure.message)),
      (notifications) =>
          emit(NotificationsSuccess(notifications: notifications)),
    );
  }

  Future<void> markNotificationAsRead(
      String notificationId, String token) async {
    // We can show a loading or keep the same state while marking as read
    final result = await notificationsRepo.markNotificationsAsRead(
      userId: userId,
      notificationIds: [notificationId],
      token: token,
    );
    result.fold(
      (failure) => emit(NotificationsFailure(error: failure.message)),
      (_) => fetchNotifications(token), // Refresh after update
    );
  }
}
