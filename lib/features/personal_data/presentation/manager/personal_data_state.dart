part of 'personal_data_cubit.dart';

@immutable
abstract class PersonalDataState {}

// ─── INITIAL / LOAD STATES ──────────────────────────────
class PersonalDataInitial extends PersonalDataState {}

class PersonalDataLoadInProgress extends PersonalDataState {}

class PersonalDataLoadSuccess extends PersonalDataState {
  final UserEntity user;
  PersonalDataLoadSuccess(this.user);
}

class PersonalDataLoadFailure extends PersonalDataState {
  final String message;
  PersonalDataLoadFailure(this.message);
}

// ─── UPDATE STATES ──────────────────────────────────────
class PersonalDataUpdateInProgress extends PersonalDataState {}

class PersonalDataUpdateSuccess extends PersonalDataState {
  final UserEntity user;
  PersonalDataUpdateSuccess(this.user);
}

class PersonalDataUpdateFailure extends PersonalDataState {
  final String message;
  PersonalDataUpdateFailure(this.message);
}
