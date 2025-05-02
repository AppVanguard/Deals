
part of 'personal_data_cubit.dart';

@immutable
abstract class PersonalDataState {}

class PersonalDataInitial extends PersonalDataState {}

class PersonalDataLoading extends PersonalDataState {}

class PersonalDataSuccess extends PersonalDataState {
  final UserEntity user;
  PersonalDataSuccess({required this.user});
}

class PersonalDataFailure extends PersonalDataState {
  final String message;
  PersonalDataFailure({required this.message});
}
