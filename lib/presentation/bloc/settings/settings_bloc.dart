import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drinklion/core/utils/logger.dart';
import 'package:drinklion/domain/entities/entities.dart';
import 'package:drinklion/domain/repositories/repositories.dart';

part 'settings_event.dart';
part 'settings_state.dart';

/// BLoC for managing user settings
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final UserRepository _userRepository;

  SettingsBloc(this._userRepository) : super(const SettingsInitial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdateNotificationSoundEvent>(_onUpdateNotificationSound);
    on<UpdateVibrationEvent>(_onUpdateVibration);
    on<UpdateThemeEvent>(_onUpdateTheme);
    on<UpdateLanguageEvent>(_onUpdateLanguage);
    on<UpdateFontSizeEvent>(_onUpdateFontSize);
    on<UpdateQuietHoursEvent>(_onUpdateQuietHours);
    on<ResetSettingsEvent>(_onResetSettings);
  }

  /// Load settings from database
  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(const SettingsLoading());

      final settings = await _userRepository.getUserSettings();

      if (settings == null) {
        // Create default settings
        final defaultSettings = UserSettings(
          userId: null,
          notificationSound: true,
          vibration: true,
          theme: 'light',
          language: 'id',
          fontSize: 'normal',
          createdAt: DateTime.now(),
        );
        emit(SettingsLoaded(defaultSettings));
      } else {
        emit(SettingsLoaded(settings));
      }
    } catch (e) {
      logger.e('Error loading settings', error: e);
      emit(SettingsError(e.toString()));
    }
  }

  /// Update notification sound setting
  Future<void> _onUpdateNotificationSound(
    UpdateNotificationSoundEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(const SettingsLoading());

      final currentSettings = await _userRepository.getUserSettings();
      if (currentSettings == null) {
        throw Exception('No settings found');
      }

      final updatedSettings = currentSettings.copyWith(
        notificationSound: event.enabled,
        updatedAt: DateTime.now(),
      );

      await _userRepository.saveUserSettings(updatedSettings);

      emit(SettingsUpdated(updatedSettings));
    } catch (e) {
      logger.e('Error updating notification sound', error: e);
      emit(SettingsError(e.toString()));
    }
  }

  /// Update vibration setting
  Future<void> _onUpdateVibration(
    UpdateVibrationEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(const SettingsLoading());

      final currentSettings = await _userRepository.getUserSettings();
      if (currentSettings == null) {
        throw Exception('No settings found');
      }

      final updatedSettings = currentSettings.copyWith(
        vibration: event.enabled,
        updatedAt: DateTime.now(),
      );

      await _userRepository.saveUserSettings(updatedSettings);

      emit(SettingsUpdated(updatedSettings));
    } catch (e) {
      logger.e('Error updating vibration', error: e);
      emit(SettingsError(e.toString()));
    }
  }

  /// Update theme
  Future<void> _onUpdateTheme(
    UpdateThemeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(const SettingsLoading());

      final currentSettings = await _userRepository.getUserSettings();
      if (currentSettings == null) {
        throw Exception('No settings found');
      }

      final updatedSettings = currentSettings.copyWith(
        theme: event.theme,
        updatedAt: DateTime.now(),
      );

      await _userRepository.saveUserSettings(updatedSettings);

      emit(SettingsUpdated(updatedSettings));
    } catch (e) {
      logger.e('Error updating theme', error: e);
      emit(SettingsError(e.toString()));
    }
  }

  /// Update language
  Future<void> _onUpdateLanguage(
    UpdateLanguageEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(const SettingsLoading());

      final currentSettings = await _userRepository.getUserSettings();
      if (currentSettings == null) {
        throw Exception('No settings found');
      }

      final updatedSettings = currentSettings.copyWith(
        language: event.language,
        updatedAt: DateTime.now(),
      );

      await _userRepository.saveUserSettings(updatedSettings);

      emit(SettingsUpdated(updatedSettings));
    } catch (e) {
      logger.e('Error updating language', error: e);
      emit(SettingsError(e.toString()));
    }
  }

  /// Update font size
  Future<void> _onUpdateFontSize(
    UpdateFontSizeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(const SettingsLoading());

      final currentSettings = await _userRepository.getUserSettings();
      if (currentSettings == null) {
        throw Exception('No settings found');
      }

      final updatedSettings = currentSettings.copyWith(
        fontSize: event.fontSize,
        updatedAt: DateTime.now(),
      );

      await _userRepository.saveUserSettings(updatedSettings);

      emit(SettingsUpdated(updatedSettings));
    } catch (e) {
      logger.e('Error updating font size', error: e);
      emit(SettingsError(e.toString()));
    }
  }

  /// Update quiet hours
  Future<void> _onUpdateQuietHours(
    UpdateQuietHoursEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(const SettingsLoading());

      final currentSettings = await _userRepository.getUserSettings();
      if (currentSettings == null) {
        throw Exception('No settings found');
      }

      final updatedSettings = currentSettings.copyWith(
        quietHoursStart: event.startTime,
        quietHoursEnd: event.endTime,
        updatedAt: DateTime.now(),
      );

      await _userRepository.saveUserSettings(updatedSettings);

      emit(SettingsUpdated(updatedSettings));
    } catch (e) {
      logger.e('Error updating quiet hours', error: e);
      emit(SettingsError(e.toString()));
    }
  }

  /// Reset settings to default
  Future<void> _onResetSettings(
    ResetSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(const SettingsLoading());

      final defaultSettings = UserSettings(
        userId: null,
        notificationSound: true,
        vibration: true,
        theme: 'light',
        language: 'id',
        fontSize: 'normal',
        createdAt: DateTime.now(),
      );

      await _userRepository.saveUserSettings(defaultSettings);

      emit(SettingsReset());
    } catch (e) {
      logger.e('Error resetting settings', error: e);
      emit(SettingsError(e.toString()));
    }
  }
}
