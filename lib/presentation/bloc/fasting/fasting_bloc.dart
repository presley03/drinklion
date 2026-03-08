import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drinklion/core/utils/logger.dart';
import 'package:drinklion/domain/repositories/repositories.dart';

part 'fasting_event.dart';
part 'fasting_state.dart';

/// BLoC for managing fasting mode
class FastingBloc extends Bloc<FastingEvent, FastingState> {
  final UserRepository _userRepository;

  FastingBloc(this._userRepository) : super(const FastingInitial()) {
    on<LoadFastingSettingsEvent>(_onLoadFastingSettings);
    on<EnableFastingModeEvent>(_onEnableFastingMode);
    on<DisableFastingModeEvent>(_onDisableFastingMode);
    on<UpdateFastingTimesEvent>(_onUpdateFastingTimes);
    on<CheckFastingStatusEvent>(_onCheckFastingStatus);
  }

  /// Load fasting settings
  Future<void> _onLoadFastingSettings(
    LoadFastingSettingsEvent event,
    Emitter<FastingState> emit,
  ) async {
    try {
      emit(const FastingLoading());

      final settings = await _userRepository.getUserSettings();

      if (settings == null) {
        emit(const FastingDisabled());
      } else {
        if (settings.fastingModeEnabled) {
          emit(
            FastingEnabled(
              enabled: true,
              startTime: settings.fastingStartTime,
              endTime: settings.fastingEndTime,
            ),
          );
        } else {
          emit(const FastingDisabled());
        }
      }
    } catch (e) {
      logger.e('Error loading fasting settings', error: e);
      emit(FastingError(e.toString()));
    }
  }

  /// Enable fasting mode
  Future<void> _onEnableFastingMode(
    EnableFastingModeEvent event,
    Emitter<FastingState> emit,
  ) async {
    try {
      emit(const FastingLoading());

      final currentSettings = await _userRepository.getUserSettings();
      if (currentSettings == null) {
        throw Exception('No settings found');
      }

      final updatedSettings = currentSettings.copyWith(
        fastingModeEnabled: true,
        fastingStartTime: event.startTime,
        fastingEndTime: event.endTime,
        updatedAt: DateTime.now(),
      );

      await _userRepository.saveUserSettings(updatedSettings);

      emit(
        FastingEnabled(
          enabled: true,
          startTime: event.startTime,
          endTime: event.endTime,
        ),
      );
    } catch (e) {
      logger.e('Error enabling fasting mode', error: e);
      emit(FastingError(e.toString()));
    }
  }

  /// Disable fasting mode
  Future<void> _onDisableFastingMode(
    DisableFastingModeEvent event,
    Emitter<FastingState> emit,
  ) async {
    try {
      emit(const FastingLoading());

      final currentSettings = await _userRepository.getUserSettings();
      if (currentSettings == null) {
        throw Exception('No settings found');
      }

      final updatedSettings = currentSettings.copyWith(
        fastingModeEnabled: false,
        updatedAt: DateTime.now(),
      );

      await _userRepository.saveUserSettings(updatedSettings);

      emit(const FastingDisabled());
    } catch (e) {
      logger.e('Error disabling fasting mode', error: e);
      emit(FastingError(e.toString()));
    }
  }

  /// Update fasting times
  Future<void> _onUpdateFastingTimes(
    UpdateFastingTimesEvent event,
    Emitter<FastingState> emit,
  ) async {
    try {
      emit(const FastingLoading());

      final currentSettings = await _userRepository.getUserSettings();
      if (currentSettings == null) {
        throw Exception('No settings found');
      }

      final updatedSettings = currentSettings.copyWith(
        fastingStartTime: event.startTime,
        fastingEndTime: event.endTime,
        updatedAt: DateTime.now(),
      );

      await _userRepository.saveUserSettings(updatedSettings);

      emit(
        FastingEnabled(
          enabled: currentSettings.fastingModeEnabled,
          startTime: event.startTime,
          endTime: event.endTime,
        ),
      );
    } catch (e) {
      logger.e('Error updating fasting times', error: e);
      emit(FastingError(e.toString()));
    }
  }

  /// Check current fasting status
  Future<void> _onCheckFastingStatus(
    CheckFastingStatusEvent event,
    Emitter<FastingState> emit,
  ) async {
    try {
      final settings = await _userRepository.getUserSettings();

      if (settings == null || !settings.fastingModeEnabled) {
        emit(const FastingDisabled());
        return;
      }

      final now = DateTime.now();
      final startTime = settings.fastingStartTime;
      final endTime = settings.fastingEndTime;

      bool isCurrentlyFasting = false;

      if (startTime != null && endTime != null) {
        // Check if current time is between fasting hours
        final startMinutes = _parseTimeToMinutes(startTime);
        final endMinutes = _parseTimeToMinutes(endTime);
        final currentMinutes = now.hour * 60 + now.minute;

        if (startMinutes < endMinutes) {
          // Same day fasting (e.g., 08:00 - 16:00)
          isCurrentlyFasting =
              currentMinutes >= startMinutes && currentMinutes <= endMinutes;
        } else {
          // Overnight fasting (e.g., 20:00 - 08:00)
          isCurrentlyFasting =
              currentMinutes >= startMinutes || currentMinutes <= endMinutes;
        }
      }

      emit(
        FastingStatusChecked(
          enabled: settings.fastingModeEnabled,
          isCurrentlyFasting: isCurrentlyFasting,
          startTime: startTime,
          endTime: endTime,
        ),
      );
    } catch (e) {
      logger.e('Error checking fasting status', error: e);
      emit(FastingError(e.toString()));
    }
  }

  /// Parse HH:MM time string to total minutes since midnight
  static int _parseTimeToMinutes(String timeString) {
    try {
      final parts = timeString.split(':');
      final hours = int.parse(parts[0]);
      final minutes = int.parse(parts[1]);
      return hours * 60 + minutes;
    } catch (e) {
      logger.e('Error parsing time string: $timeString', error: e);
      return 0;
    }
  }
}
