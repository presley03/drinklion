part of 'reminder_bloc.dart';

/// Base state for ReminderBloc
abstract class ReminderState extends Equatable {
  const ReminderState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ReminderInitial extends ReminderState {
  const ReminderInitial();
}

/// Loading state
class ReminderLoading extends ReminderState {
  const ReminderLoading();
}

/// Reminders loaded successfully
class RemindersLoaded extends ReminderState {
  final List<ReminderLog> reminders;
  final double completionRate;

  const RemindersLoaded({required this.reminders, this.completionRate = 0.0});

  @override
  List<Object?> get props => [reminders, completionRate];
}

/// Reminder created successfully
class ReminderCreated extends ReminderState {
  final ReminderLog reminder;

  const ReminderCreated(this.reminder);

  @override
  List<Object?> get props => [reminder];
}

/// Reminder completed successfully
class ReminderCompleted extends ReminderState {
  final String reminderId;

  const ReminderCompleted(this.reminderId);

  @override
  List<Object?> get props => [reminderId];
}

/// Reminder skipped successfully
class ReminderSkipped extends ReminderState {
  final String reminderId;

  const ReminderSkipped(this.reminderId);

  @override
  List<Object?> get props => [reminderId];
}

/// Reminder deleted successfully
class ReminderDeleted extends ReminderState {
  const ReminderDeleted();
}

/// Completion rate retrieved
class CompletionRateRetrieved extends ReminderState {
  final double rate;

  const CompletionRateRetrieved(this.rate);

  @override
  List<Object?> get props => [rate];
}

/// No reminders found
class NoRemindersFound extends ReminderState {
  const NoRemindersFound();
}

/// Error state
class ReminderError extends ReminderState {
  final String message;

  const ReminderError(this.message);

  @override
  List<Object?> get props => [message];
}
