part of 'menu_cubit.dart';

@immutable
sealed class MenuState {}

final class MenuInitial extends MenuState {}

final class MenuLoading extends MenuState {}

final class MenuLogoutSuccess extends MenuState {
  final String message;
  MenuLogoutSuccess({required this.message});
}

final class MenuLogoutFailure extends MenuState {
  final String message;
  MenuLogoutFailure({required this.message});
}
