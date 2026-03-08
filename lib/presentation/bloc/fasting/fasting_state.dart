part of 'fasting_bloc.dart';

/// Base state for FastingBloc
abstract class FastingState extends Equatable {
  const FastingState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class FastingInitial extends FastingState {
  const FastingInitial();
}

/// Loading state
class FastingLoading extends FastingState {
  const FastingLoading();
}

/// Fasting mode enabled
class FastingEnabled extends FastingState {
  final bool enabled;
  final String? startTime; // HH:MM format
  final String? endTime; // HH:MM format

  const FastingEnabled({this.enabled = true, this.startTime, this.endTime});

  @override
  List<Object?> get props => [enabled, startTime, endTime];
}

/// Fasting mode disabled
class FastingDisabled extends FastingState {
  const FastingDisabled();
}

/// Fasting status checked
class FastingStatusChecked extends FastingState {
  final bool enabled;
  final bool isCurrentlyFasting;
  final String? startTime; // HH:MM format
  final String? endTime; // HH:MM format

  const FastingStatusChecked({
    required this.enabled,
    required this.isCurrentlyFasting,
    this.startTime,
    this.endTime,
  });

  @override
  List<Object?> get props => [enabled, isCurrentlyFasting, startTime, endTime];
}

/// Error state
class FastingError extends FastingState {
  final String message;

  const FastingError(this.message);

  @override
  List<Object?> get props => [message];
}
