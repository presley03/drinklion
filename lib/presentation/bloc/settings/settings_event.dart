part of 'settings_bloc.dart';

/// Base event for SettingsBloc
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Load user settings
class LoadSettingsEvent extends SettingsEvent {
  const LoadSettingsEvent();
}

/// Update notification sound setting
class UpdateNotificationSoundEvent extends SettingsEvent {
  final bool enabled;

  const UpdateNotificationSoundEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Update vibration setting
class UpdateVibrationEvent extends SettingsEvent {
  final bool enabled;

  const UpdateVibrationEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Update theme (light/dark/system)
class UpdateThemeEvent extends SettingsEvent {
  final String theme;

  const UpdateThemeEvent(this.theme);

  @override
  List<Object?> get props => [theme];
}

/// Update language (id/en)
class UpdateLanguageEvent extends SettingsEvent {
  final String language;

  const UpdateLanguageEvent(this.language);

  @override
  List<Object?> get props => [language];
}

/// Update font size
class UpdateFontSizeEvent extends SettingsEvent {
  final String fontSize;

  const UpdateFontSizeEvent(this.fontSize);

  @override
  List<Object?> get props => [fontSize];
}

/// Update quiet hours
class UpdateQuietHoursEvent extends SettingsEvent {
  final String? startTime;
  final String? endTime;

  const UpdateQuietHoursEvent({this.startTime, this.endTime});

  @override
  List<Object?> get props => [startTime, endTime];
}

/// Reset settings to default
class ResetSettingsEvent extends SettingsEvent {
  const ResetSettingsEvent();
}
