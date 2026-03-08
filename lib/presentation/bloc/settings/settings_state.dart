part of 'settings_bloc.dart';

/// Base state for SettingsBloc
abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

/// Loading state
class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

/// Settings loaded successfully
class SettingsLoaded extends SettingsState {
  final UserSettings settings;

  const SettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

/// Settings updated successfully
class SettingsUpdated extends SettingsState {
  final UserSettings settings;

  const SettingsUpdated(this.settings);

  @override
  List<Object?> get props => [settings];
}

/// Settings reset to default
class SettingsReset extends SettingsState {
  const SettingsReset();
}

/// Error state
class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
