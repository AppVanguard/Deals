// lib/features/profile/presentation/manager/personal_data_cubit/personal_data_state.dart

part of 'personal_data_cubit.dart';

@immutable
abstract class PersonalDataState {}

// ─── INITIAL / LOAD STATES ───────────────────────────────────────────────────

/// Before anything has happened
class PersonalDataInitial extends PersonalDataState {}

/// While we’re fetching the user’s current data
class PersonalDataLoadInProgress extends PersonalDataState {}

/// Once we’ve successfully loaded the user’s data
class PersonalDataLoadSuccess extends PersonalDataState {
  final UserEntity user;
  PersonalDataLoadSuccess(this.user);
}

/// If the initial load fails
class PersonalDataLoadFailure extends PersonalDataState {
  final String message;
  PersonalDataLoadFailure(this.message);
}

// ─── UPDATE STATES ───────────────────────────────────────────────────────────

/// While we’re sending the PATCH
class PersonalDataUpdateInProgress extends PersonalDataState {}

/// After the PATCH returns successfully
class PersonalDataUpdateSuccess extends PersonalDataState {
  final UserEntity user;
  PersonalDataUpdateSuccess(this.user);
}

/// If the PATCH returns an error
class PersonalDataUpdateFailure extends PersonalDataState {
  final String message;
  PersonalDataUpdateFailure(this.message);
}
