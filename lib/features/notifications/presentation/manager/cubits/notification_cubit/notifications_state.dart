// lib/features/notifications/presentation/manager/cubits/notification_cubit/notifications_state.dart

part of 'notifications_cubit.dart';

@immutable
abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsSuccess extends NotificationsState {
  final List<NotificationEntity> notifications;
  final bool isRefreshing; // For top-level refresh or pull-to-refresh
  final bool isLoadingMore; // Are we loading more at the bottom?
  final int newLoadCount; // How many placeholders to show for new items
  final bool hasMore; // Does the server have more?
  final int offset; // current offset

  NotificationsSuccess({
    required this.notifications,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.newLoadCount = 0,
    this.hasMore = true,
    this.offset = 0,
  });

  NotificationsSuccess copyWith({
    List<NotificationEntity>? notifications,
    bool? isRefreshing,
    bool? isLoadingMore,
    int? newLoadCount,
    bool? hasMore,
    int? offset,
  }) {
    return NotificationsSuccess(
      notifications: notifications ?? this.notifications,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      newLoadCount: newLoadCount ?? this.newLoadCount,
      hasMore: hasMore ?? this.hasMore,
      offset: offset ?? this.offset,
    );
  }
}

class NotificationsFailure extends NotificationsState {
  final String error;
  NotificationsFailure({required this.error});
}
