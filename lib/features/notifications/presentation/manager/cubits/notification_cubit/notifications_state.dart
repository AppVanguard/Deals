part of 'notifications_cubit.dart';

@immutable
abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsSuccess extends NotificationsState {
  final List<Notification> notifications;
  NotificationsSuccess({required this.notifications});
}

class NotificationsFailure extends NotificationsState {
  final String error;
  NotificationsFailure({required this.error});
}
