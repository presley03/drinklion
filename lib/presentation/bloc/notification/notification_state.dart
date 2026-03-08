part of 'notification_bloc.dart';

/// Base state for NotificationBloc
abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

/// Loading state
class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

/// Notification schedules loaded
class NotificationSchedulesLoaded extends NotificationState {
  final List<NotificationSchedule> schedules;

  const NotificationSchedulesLoaded(this.schedules);

  @override
  List<Object?> get props => [schedules];
}

/// Notification schedule created
class NotificationScheduleCreated extends NotificationState {
  final NotificationSchedule schedule;

  const NotificationScheduleCreated(this.schedule);

  @override
  List<Object?> get props => [schedule];
}

/// Notification schedule updated
class NotificationScheduleUpdated extends NotificationState {
  final NotificationSchedule schedule;

  const NotificationScheduleUpdated(this.schedule);

  @override
  List<Object?> get props => [schedule];
}

/// Notification schedule deleted
class NotificationScheduleDeleted extends NotificationState {
  const NotificationScheduleDeleted();
}

/// Reminders scheduled successfully
class RemindersScheduled extends NotificationState {
  final int count;

  const RemindersScheduled(this.count);

  @override
  List<Object?> get props => [count];
}

/// All notifications cancelled
class NotificationsCancelled extends NotificationState {
  const NotificationsCancelled();
}

/// No notification schedules found
class NoNotificationSchedulesFound extends NotificationState {
  const NoNotificationSchedulesFound();
}

/// Error state
class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}
