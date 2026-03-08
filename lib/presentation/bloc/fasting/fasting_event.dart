part of 'fasting_bloc.dart';

/// Base event for FastingBloc
abstract class FastingEvent extends Equatable {
  const FastingEvent();

  @override
  List<Object?> get props => [];
}

/// Load fasting settings
class LoadFastingSettingsEvent extends FastingEvent {
  const LoadFastingSettingsEvent();
}

/// Enable fasting mode
class EnableFastingModeEvent extends FastingEvent {
  final String? startTime; // HH:MM format
  final String? endTime; // HH:MM format

  const EnableFastingModeEvent({this.startTime, this.endTime});

  @override
  List<Object?> get props => [startTime, endTime];
}

/// Disable fasting mode
class DisableFastingModeEvent extends FastingEvent {
  const DisableFastingModeEvent();
}

/// Update fasting times
class UpdateFastingTimesEvent extends FastingEvent {
  final String? startTime; // HH:MM format
  final String? endTime; // HH:MM format

  const UpdateFastingTimesEvent({this.startTime, this.endTime});

  @override
  List<Object?> get props => [startTime, endTime];
}

/// Check current fasting status
class CheckFastingStatusEvent extends FastingEvent {
  const CheckFastingStatusEvent();
}
