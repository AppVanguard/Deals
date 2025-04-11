part of 'user_update_cubit.dart';

@immutable
abstract class UserUpdateState {}

class UserUpdateInitial extends UserUpdateState {}

class UserUpdateLoading extends UserUpdateState {}

class UserUpdateSuccess extends UserUpdateState {
  final UserEntity userEntity;
  final String message;
  UserUpdateSuccess({
    required this.userEntity,
    required this.message,
  });
}

class UserUpdateFailure extends UserUpdateState {
  final String message;
  UserUpdateFailure({
    required this.message,
  });
}
