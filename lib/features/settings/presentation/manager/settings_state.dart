part of 'settings_cubit.dart';

@immutable
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
