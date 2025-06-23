part of 'session_cubit.dart';

@immutable
sealed class SessionState {}

final class SessionInitial extends SessionState {}

final class SessionLoading extends SessionState {}

final class SessionLoggedOut extends SessionState {}

final class SessionFailure extends SessionState {
  final String message;
  SessionFailure({required this.message});
}
