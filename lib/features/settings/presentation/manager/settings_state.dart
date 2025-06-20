// lib/features/settings/presentation/manager/settings_state.dart

part of 'settings_cubit.dart';

abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsPushSuccess extends SettingsState {
  final bool isEnabled;
  SettingsPushSuccess({required this.isEnabled});
}

class SettingsPushFailure extends SettingsState {
  final String message;
  SettingsPushFailure({required this.message});
}

class SettingsChangePasswordSuccess extends SettingsState {
  final String message;
  SettingsChangePasswordSuccess({required this.message});
}

class SettingsChangePasswordFailure extends SettingsState {
  final String message;
  SettingsChangePasswordFailure({required this.message});
}

class SettingsDeleteAccountSuccess extends SettingsState {
  final String message;
  SettingsDeleteAccountSuccess({required this.message});
}

class SettingsDeleteAccountFailure extends SettingsState {
  final String message;
  SettingsDeleteAccountFailure({required this.message});
}
