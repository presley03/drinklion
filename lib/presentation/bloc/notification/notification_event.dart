part of 'notification_bloc.dart';

/// Base event for NotificationBloc
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

/// Load notification schedules
class LoadNotificationSchedulesEvent extends NotificationEvent {
  const LoadNotificationSchedulesEvent();
}

/// Create notification schedule
class CreateNotificationScheduleEvent extends NotificationEvent {
  final String time; // HH:mm format
  final String? reminderType;

  const CreateNotificationScheduleEvent({
    required this.time,
    this.reminderType,
  });

  @override
  List<Object?> get props => [time, reminderType];
}

/// Update notification schedule
class UpdateNotificationScheduleEvent extends NotificationEvent {
  final NotificationSchedule schedule;

  const UpdateNotificationScheduleEvent(this.schedule);

  @override
  List<Object?> get props => [schedule];
}

/// Delete notification schedule
class DeleteNotificationScheduleEvent extends NotificationEvent {
  final String scheduleId;

  const DeleteNotificationScheduleEvent(this.scheduleId);

  @override
  List<Object?> get props => [scheduleId];
}

/// Enable notification
class EnableNotificationEvent extends NotificationEvent {
  final NotificationSchedule schedule;

  const EnableNotificationEvent(this.schedule);

  @override
  List<Object?> get props => [schedule];
}

/// Disable notification
class DisableNotificationEvent extends NotificationEvent {
  final NotificationSchedule schedule;

  const DisableNotificationEvent(this.schedule);

  @override
  List<Object?> get props => [schedule];
}

/// Schedule all enabled reminder notifications
class ScheduleReminderNotificationsEvent extends NotificationEvent {
  const ScheduleReminderNotificationsEvent();
}

/// Cancel all notifications
class CancelNotificationsEvent extends NotificationEvent {
  const CancelNotificationsEvent();
}
