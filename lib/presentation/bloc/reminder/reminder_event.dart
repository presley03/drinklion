part of 'reminder_bloc.dart';

/// Base event for ReminderBloc
abstract class ReminderEvent extends Equatable {
  const ReminderEvent();

  @override
  List<Object?> get props => [];
}

/// Load today's reminders
class LoadTodayRemindersEvent extends ReminderEvent {
  const LoadTodayRemindersEvent();
}

/// Load reminders by date range
class LoadRemindersByDateRangeEvent extends ReminderEvent {
  final DateTime startDate;
  final DateTime endDate;

  const LoadRemindersByDateRangeEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

/// Create new reminder
class CreateReminderEvent extends ReminderEvent {
  final DateTime scheduledTime;
  final String reminderType;

  const CreateReminderEvent({
    required this.scheduledTime,
    required this.reminderType,
  });

  @override
  List<Object?> get props => [scheduledTime, reminderType];
}

/// Mark reminder as completed
class CompleteReminderEvent extends ReminderEvent {
  final String reminderId;
  final String? quantity;

  const CompleteReminderEvent({required this.reminderId, this.quantity});

  @override
  List<Object?> get props => [reminderId, quantity];
}

/// Mark reminder as skipped
class SkipReminderEvent extends ReminderEvent {
  final String reminderId;
  final String? reason;

  const SkipReminderEvent({required this.reminderId, this.reason});

  @override
  List<Object?> get props => [reminderId, reason];
}

/// Get completion rate for today
class GetCompletionRateEvent extends ReminderEvent {
  const GetCompletionRateEvent();
}

/// Delete reminder
class DeleteReminderEvent extends ReminderEvent {
  final String reminderId;

  const DeleteReminderEvent(this.reminderId);

  @override
  List<Object?> get props => [reminderId];
}

/// Refresh/reload reminders
class RefreshRemindersEvent extends ReminderEvent {
  const RefreshRemindersEvent();
}
